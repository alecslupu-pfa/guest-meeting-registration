# frozen_string_literal: true

require "rails"
require "deface"
require "decidim/core"

module Decidim
  module GuestMeetingRegistration
    # This is the engine that runs on the public interface of guest_meeting_registration.
    class Engine < ::Rails::Engine
      isolate_namespace Decidim::GuestMeetingRegistration

      routes do
        resource :guest_meeting_registration, path: "/", only: [:create, :destroy] do
          collection do
            get :create
            get :decline_invitation
            get :join, action: :show
            post :answer
          end
        end

        root to: "guest_meeting_registration#show"
      end

      initializer "decidim_admin_guest_meeting_registration.mount_routes", before: "decidim_admin.mount_routes" do
        Decidim::Meetings::Engine.routes.append do
          scope "/meetings/:meeting_id/guest-registration" do
            mount Decidim::GuestMeetingRegistration::Engine => "/"
          end
        end
      end

      initializer "decidim_guest_meeting_registration.views" do
        Rails.application.configure do
          config.deface.enabled = Decidim::GuestMeetingRegistration.deface_enabled
        end
      end

      initializer "decidim_guest_meeting_registration.add_cells_view_paths" do
        Cell::ViewModel.view_paths << File.expand_path("#{Decidim::GuestMeetingRegistration::Engine.root}/app/cells")
        Cell::ViewModel.view_paths << File.expand_path("#{Decidim::GuestMeetingRegistration::Engine.root}/app/views") # for partials
      end

      initializer "decidim_guest_meeting_registration.webpacker.assets_path" do
        Decidim.register_assets_path File.expand_path("app/packs", root)
      end
    end
  end
end
