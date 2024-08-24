# frozen_string_literal: true

module Decidim
  module GuestMeetingRegistration
    module HasQuestionnaire
      extend ActiveSupport::Concern

      included do
        include FormFactory

        helper_method :visitor_already_answered?, :meeting, :update_url, :form_path
        invisible_captcha on_spam: :spam_detected

        def form_path
          Decidim::EngineRouter.main_proxy(current_component).meeting_path(meeting)
        end

        # token is used as a substitute of user_id if unregistered
        def session_token
          id = current_user&.id
          session_id = request.session[:session_id] if request&.session

          return nil unless id || session_id

          @session_token ||= tokenize(id || session_id)
        end

        def meeting
          @meeting ||= Decidim::Meetings::Meeting.where(component: current_component).find(params[:meeting_id])
        end

        def visitor_already_answered?
          if meeting.registration_form_enabled?
            questionnaire.answered_by?(current_user || session_token)
          else
            Decidim::GuestMeetingRegistration::RegistrationRequest.exists?(session_token: session_token)
          end
        end

        def tokenize(id, length: 10)
          tokenizer = if meeting.registration_form_enabled?
                        Decidim::Tokenizer.new(salt: questionnaire.salt || questionnaire.id, length: length)
                      else
                        Decidim::Tokenizer.new(salt: meeting.id.to_s, length: length)
                      end
          tokenizer.int_digest(id).to_s
        end

        def template
          if meeting.registration_form_enabled?
            "decidim/guest_meeting_registration/questionnaires/show"
          else
            "decidim/guest_meeting_registration/questionnaires/simplified"
          end
        end

        # You can implement this method in your controller to change the URL
        # where the questionnaire will be submitted.
        def update_url
          "#{form_path}/guest-registration/answer"
        end
      end
    end
  end
end
