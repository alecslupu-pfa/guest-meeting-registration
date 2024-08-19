# frozen_string_literal: true

module Decidim
  module GuestMeetingRegistration
    module Admin
      # This controller is the abstract class from which all other controllers of
      # this engine inherit.
      #
      # Note that it inherits from `Decidim::Admin::Components::BaseController`, which
      # override its layout and provide all kinds of useful methods.
      class ApplicationController < Decidim::Admin::ApplicationController
        layout "decidim/admin/settings"
      end
    end
  end
end
