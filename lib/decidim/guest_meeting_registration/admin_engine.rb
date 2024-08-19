# frozen_string_literal: true

module Decidim
  module GuestMeetingRegistration
    # This is the engine that runs on the public interface of `GuestMeetingRegistration`.
    class AdminEngine < ::Rails::Engine
      isolate_namespace Decidim::GuestMeetingRegistration::Admin

      paths["db/migrate"] = nil
      paths["lib/tasks"] = nil

      routes do
        scope "/organization" do
          resource :guest_meeting_settings, only: [:edit, :update]
        end
      end

      initializer "decidim_admin_guest_meeting_registration.mount_routes", before: "decidim_admin.mount_routes" do
        Decidim::Admin::Engine.routes.append do
          mount Decidim::GuestMeetingRegistration::AdminEngine => "/"
        end
      end

      initializer "decidim_admin_guest_meeting_registration.add_half_signup_menu_to_admin", before: "decidim_admin.admin_settings_menu" do
        Decidim.menu :admin_settings_menu do |menu|
          # /organization/
          menu.add_item :edit_organization,
                        I18n.t("menu.guest_meeting_registration_settings", scope: "decidim.guest_meeting_registration"),
                        decidim_guest_meeting_registration_admin.edit_guest_meeting_settings_path,
                        position: 1.1,
                        if: allowed_to?(:update, :organization, organization: current_organization),
                        active: is_active_link?(decidim_guest_meeting_registration_admin.edit_guest_meeting_settings_path)
        end
      end
    end
  end
end
