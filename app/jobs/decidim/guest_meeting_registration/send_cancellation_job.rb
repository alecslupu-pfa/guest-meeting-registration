# frozen_string_literal: true

module Decidim
  module GuestMeetingRegistration
    class SendCancellationJob < ApplicationJob
      queue_as :mailers
      def perform(registration_request_id)
        registration_request = Decidim::GuestMeetingRegistration::RegistrationRequest.find(registration_request_id)

        GuestMeetingRegistrationMailer.send_cancellation_request(registration_request).deliver_now!
      end
    end
  end
end
