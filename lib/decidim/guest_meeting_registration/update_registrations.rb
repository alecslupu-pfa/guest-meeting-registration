# frozen_string_literal: true

module Decidim
  module GuestMeetingRegistration
    module UpdateRegistrations
      def update_meeting_registrations
        meeting.registrations_enabled = form.registrations_enabled
        meeting.registration_form_enabled = form.registration_form_enabled

        if form.registrations_enabled
          meeting.available_slots = form.available_slots
          meeting.reserved_slots = form.reserved_slots
          meeting.registration_terms = form.registration_terms
          meeting.customize_registration_email = form.customize_registration_email

          meeting.enable_guest_registration = form.enable_guest_registration
          meeting.enable_registration_confirmation = form.enable_registration_confirmation
          meeting.enable_cancellation = form.enable_cancellation
          meeting.disable_account_confirmation = form.disable_account_confirmation

          meeting.registration_email_custom_content = form.registration_email_custom_content if form.customize_registration_email
        end

        meeting.save!
      end
    end
  end
end
