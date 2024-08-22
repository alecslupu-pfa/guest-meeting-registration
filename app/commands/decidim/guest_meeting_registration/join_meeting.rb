# frozen_string_literal: true

module Decidim
  module GuestMeetingRegistration
    class JoinMeeting < Decidim::Meetings::JoinMeeting
      private

      def increment_score; end

      def questionnaire?
        meeting.registration_form_enabled? && registration_form.model_name == "questionnaire"
      end
    end
  end
end
