# frozen_string_literal: true

module Decidim
  module GuestMeetingRegistration
    class GuestMeetingRegistrationMailer < Decidim::ApplicationMailer
      include Decidim::ApplicationHelper
      helper Decidim::ResourceHelper

      helper Decidim::ApplicationHelper

      helper_method :confirmation_url

      def send_confirmation(registration_request, current_locale)
        @organization = registration_request.organization
        @registration_request = registration_request

        I18n.with_locale(current_locale || registration_request.organization.default_locale) do
          mail(to: registration_request.email,
               subject: I18n.t("decidim.guest_meeting_registration.guest_meeting_registration_mailer.send_confirmation.subject",
                               meeting_title: translated_attribute(registration_request.meeting.title)))
        end
      end

      private

      def confirmation_url(confirmation_token: nil)
        "#{meeting_base}/guest-registration/confirm/#{confirmation_token}"
      end

      def meeting_base
        Decidim::EngineRouter.main_proxy(@registration_request.meeting.component).meeting_url(@registration_request.meeting)
      end
    end
  end
end
