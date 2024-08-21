# frozen_string_literal: true

module Decidim
  module GuestMeetingRegistration
    module Admin
      class UpdateGuestMeetingSettings < Decidim::Command
        def initialize(guest_meeting_settings, form)
          @guest_meeting_settings = guest_meeting_settings
          @form = form
        end

        def call
          return broadcast(:invalid) if form.invalid?

          update_guest_meeting_settings
          broadcast(:ok)
        end

        private

        attr_reader :form

        def update_guest_meeting_settings
          Decidim.traceability.update!(
            @guest_meeting_settings,
            form.current_user,
            attributes
          )
        end

        def attributes
          {
            enable_guest_registration: form.enable_guest_registration,
            enable_registration_confirmation: form.enable_registration_confirmation,
            enable_cancellation: form.enable_cancellation
          }
        end
      end
    end
  end
end
