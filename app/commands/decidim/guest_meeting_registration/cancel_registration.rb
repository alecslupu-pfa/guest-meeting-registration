# frozen_string_literal: true

module Decidim
  module GuestMeetingRegistration
    class CancelRegistration < Decidim::Command
      def initialize(registration_request)
        @registration_request = registration_request
      end

      def call
        Decidim::GuestMeetingRegistration::LeaveMeeting.call(meeting, user)
        destroy_follow
        @registration_request.destroy

        broadcast(:ok)
      rescue StandardError
        broadcast(:invalid)
      end

      private

      attr_reader :registration_request

      delegate :meeting, :user, to: :registration_request

      def destroy_follow
        Decidim::DeleteFollow.call(follow_form, user)
      end

      def follow_form
        Decidim::FollowForm
          .from_params(followable_gid: meeting.to_signed_global_id.to_s)
          .with_context(current_user: user)
      end
    end
  end
end
