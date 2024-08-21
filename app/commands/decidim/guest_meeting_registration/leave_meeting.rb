# frozen_string_literal: true

module Decidim
  module GuestMeetingRegistration
    class LeaveMeeting < Decidim::Meetings::LeaveMeeting
      private

      def decrement_score; end
    end
  end
end
