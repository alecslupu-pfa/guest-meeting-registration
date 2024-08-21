# frozen_string_literal: true

module Decidim
  module GuestMeetingRegistration
    class SendConfirmationInviteJob < ApplicationJob
      queue_as :mailers
      def perform(registration_request_id, locale)
        registration_request = Decidim::GuestMeetingRegistration::RegistrationRequest.find(registration_request_id)

        GuestMeetingRegistrationMailer.send_confirmation(registration_request, locale).deliver_now!
      end
    end
  end
end
