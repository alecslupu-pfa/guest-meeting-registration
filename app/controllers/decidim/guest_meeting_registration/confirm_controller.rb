# frozen_string_literal: true

module Decidim
  module GuestMeetingRegistration
    class ConfirmController < Decidim::Meetings::ApplicationController
      def show
        @registration_request = Decidim::GuestMeetingRegistration::RegistrationRequest.where(
          organization: current_organization,
          meeting: meeting,
          confirmation_token: params[:id]
        ).first!

        Decidim::GuestMeetingRegistration::CreateRegistration.call(@registration_request) do
          on(:ok) do
            flash[:notice] = I18n.t("registrations.create.success", scope: "decidim.meetings")
            redirect_to Decidim::EngineRouter.main_proxy(@registration_request.component).meeting_path(@registration_request.meeting)
          end

          on(:invalid) do
            flash[:alert] = I18n.t("registrations.create.success", scope: "decidim.meetings")
            redirect_to Decidim::EngineRouter.main_proxy(@registration_request.component).meeting_path(@registration_request.meeting)
          end
        end
      end

      private

      def meeting
        @meeting ||= Decidim::Meetings::Meeting.where(component: current_component).find(params[:meeting_id])
      end
    end
  end
end
