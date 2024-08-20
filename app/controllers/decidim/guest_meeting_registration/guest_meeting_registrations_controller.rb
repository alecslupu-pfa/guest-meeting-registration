# frozen_string_literal: true

module Decidim
  module GuestMeetingRegistration
    class GuestMeetingRegistrationsController < Decidim::Meetings::ApplicationController
      include Decidim::Forms::Concerns::HasQuestionnaire

      def create
        @form = form(Decidim::GuestMeetingRegistration::QuestionnaireForm).from_model(questionnaire)
        render template: "decidim/guest_meeting_registration/questionnaires/show"
      end

      def answer
        @form = form(Decidim::GuestMeetingRegistration::QuestionnaireForm).from_params(params, session_token: session_token)

        Decidim::GuestMeetingRegistration::JoinMeeting.call(meeting, @form) do
          on(:ok) do
            flash[:notice] = I18n.t("registrations.create.success", scope: "decidim.meetings")
            redirect_to after_answer_path
          end

          on(:invalid) do
            flash.now[:alert] = I18n.t("registrations.create.invalid", scope: "decidim.meetings")
            render template: "decidim/guest_meeting_registration/questionnaires/show"
          end

          on(:invalid_form) do
            flash.now[:alert] = I18n.t("answer.invalid", scope: i18n_flashes_scope)
            render template: "decidim/guest_meeting_registration/questionnaires/show"
          end
        end
      end

      private

      # You can implement this method in your controller to change the URL
      # where the questionnaire will be submitted.
      def update_url
        "#{form_path}/guest-registration/answer"
      end

      def after_answer_path
        form_path
      end

      def form_path
        Decidim::EngineRouter.main_proxy(current_component).meeting_path(meeting)
      end

      def allow_unregistered?
        meeting_registration_settings.enable_guest_registration?
      end

      def allow_answers?
        meeting.registrations_enabled? && meeting.registration_form_enabled? && meeting.has_available_slots?
      end

      def questionnaire_for
        meeting
      end

      def meeting
        @meeting ||= Decidim::Meetings::Meeting.where(component: current_component).find(params[:meeting_id])
      end

      def meeting_registration_settings
        @meeting_registration_settings ||= Decidim::GuestMeetingRegistration::Setting.where(organization: current_organization).first_or_create
      end
    end
  end
end
