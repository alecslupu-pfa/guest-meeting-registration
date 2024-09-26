# frozen_string_literal: true

require "decidim/guest_meeting_registration/engine"

module Decidim
  # This namespace holds the logic of the `GuestMeetingRegistration` component. This component
  # allows users to create guest_meeting_registration in a participatory space.
  module GuestMeetingRegistration
    include ActiveSupport::Configurable

    autoload :UpdateRegistrations, "decidim/guest_meeting_registration/update_registrations"
    autoload :MeetingRegistrationForm, "decidim/guest_meeting_registration/meeting_registration_form"
    autoload :RegistrationSerializer, "decidim/guest_meeting_registration/registration_serializer"
    autoload :AccountRegistration, "decidim/guest_meeting_registration/account_registration"

    config_accessor :deface_enabled do
      ENV.fetch("DEFACE_ENABLED", nil) == "true" || Rails.env.test?
    end
  end
end
