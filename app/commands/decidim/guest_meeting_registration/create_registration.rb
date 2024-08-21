# frozen_string_literal: true

module Decidim
  module GuestMeetingRegistration
    class CreateRegistration < Decidim::Command
      def initialize(registration_request)
        @registration_request = registration_request
      end

      def call
        return broadcast(:invalid_form) unless registration_form.valid?
        return broadcast(:invalid) unless meeting.registrations_enabled? && meeting.has_available_slots?

        create_user
        add_user_to_request!

        Decidim::GuestMeetingRegistration::JoinMeeting.call(meeting, user, registration_form)

        send_cancellation_link! if enable_cancellation?
        broadcast(:ok)
      end

      private

      attr_reader :user, :registration_request

      delegate :meeting, to: :registration_request
      delegate :questionnaire, to: :meeting
      delegate :enable_cancellation?, to: :meeting_registration_settings

      def send_cancellation_link!
        Decidim::GuestMeetingRegistration::SendCancellationJob.perform_later(registration_request.id)
      end

      def meeting_registration_settings
        @meeting_registration_settings ||= Decidim::GuestMeetingRegistration::Setting.where(organization: current_organization).first_or_create
      end

      def registration_form
        @registration_form ||= Decidim::GuestMeetingRegistration::QuestionnaireForm.from_params(registration_request.form_data).with_context(form_context)
      end

      def add_user_to_request!
        @registration_request.user = @user
        @registration_request.confirmed_at = Time.zone.now
        @registration_request.confirmation_token = nil
        @registration_request.save!
      end

      def form_context
        {
          current_organization: current_organization,
          current_component: current_component,
          current_user: current_user,
          current_participatory_space: current_participatory_space,
          session_token: session_token
        }
      end

      # token is used as a substitute of user_id if unregistered
      def session_token
        id = current_user&.id
        session_id = request.session[:session_id] if request&.session

        return nil unless id || session_id

        @session_token ||= tokenize(id || session_id)
      end

      def tokenize(id, length: 10)
        tokenizer = Decidim::Tokenizer.new(salt: questionnaire.salt || questionnaire.id, length: length)
        tokenizer.int_digest(id).to_s
      end

      def create_user
        @user = current_organization.users.where(email: registration_form.email).first_or_initialize
        return if user.persisted?

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
    end
  end
end
