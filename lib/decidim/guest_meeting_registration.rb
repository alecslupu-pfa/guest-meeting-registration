# frozen_string_literal: true

require "decidim/guest_meeting_registration/admin"
require "decidim/guest_meeting_registration/engine"
require "decidim/guest_meeting_registration/admin_engine"

module Decidim
  # This namespace holds the logic of the `GuestMeetingRegistration` component. This component
  # allows users to create guest_meeting_registration in a participatory space.
  module GuestMeetingRegistration
    include ActiveSupport::Configurable

    autoload :RegistrationSerializer, "decidim/guest_meeting_registration/registration_serializer"
    autoload :AccountRegistration, "decidim/guest_meeting_registration/account_registration"

    config_accessor :deface_enabled do
      ENV.fetch("DEFACE_ENABLED", nil) == "true" || Rails.env.test?
    end
  end
end
