# frozen_string_literal: true

module Decidim
  module GuestMeetingRegistration
    class JoinMeeting < Decidim::Meetings::JoinMeeting
      # Initializes a JoinMeeting Command.
      #
      # meeting - The current instance of the meeting to be joined.
      # user - The user joining the meeting.
      # registration_form - A form object with params; can be a questionnaire.
      def initialize(meeting, registration_form)
        @meeting = meeting
        @registration_form = registration_form
      end

      # Creates a meeting registration if the meeting has registrations enabled
      # and there are available slots.
      #
      # Broadcasts :ok if successful, :invalid otherwise.
      def call
        return broadcast(:invalid_form) unless registration_form.valid?

        create_user

        return broadcast(:invalid) unless can_join_meeting?
        return broadcast(:invalid) if answer_questionnaire == :invalid

        meeting.with_lock do
          create_registration
          accept_invitation
          send_email_confirmation
          send_notification_confirmation
          notify_admin_over_percentage
          # increment_score
        end
        follow_meeting
        broadcast(:ok)
      rescue ActiveRecord::RecordInvalid
        broadcast(:invalid)
      end

      private

      attr_reader :meeting, :user, :registration, :registration_form

      def create_user
        @user = current_organization.users.where(email: registration_form.email).first_or_initialize
        raise ActiveRecord::RecordInvalid if user.persisted?

        user.email = registration_form.email
        user.name = registration_form.name
        user.nickname = UserBaseEntity.nicknamize(registration_form.name, organization: current_organization)
        user.skip_confirmation!
        user.tos_agreement = "1"
        user.password = SecureRandom.hex
        user.notification_settings = { "close_meeting_reminder" => "0" }
        user.notifications_sending_frequency = "real_time"
        user.notification_types = "followed-only"
        user.save!
      end

      def send_notification_confirmation
        Decidim::EventsManager.publish(
          event: "decidim.events.meetings.meeting_registration_confirmed",
          event_class: Decidim::Meetings::MeetingRegistrationNotificationEvent,
          resource: @meeting,
          affected_users: [@user],
          extra: {
            registration_code: @registration.code
          }
        )
      end

      def increment_score; end
    end
  end
end
