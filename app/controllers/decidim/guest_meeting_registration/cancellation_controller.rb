# frozen_string_literal: true

module Decidim
  module GuestMeetingRegistration
    class CancellationController < Decidim::Meetings::ApplicationController
      def show
        @registration_request = Decidim::GuestMeetingRegistration::RegistrationRequest.where(
          organization: current_organization,
          cancellation_token: params[:id]
        ).first!

        Decidim::GuestMeetingRegistration::CancelRegistration.call(@registration_request) do
          on(:ok) do
            flash[:notice] = I18n.t("cancellation.success", scope: "decidim.guest_meeting_registration")
            redirect_to Decidim::EngineRouter.main_proxy(@registration_request.component).meeting_path(@registration_request.meeting)
          end

          on(:invalid) do
            flash[:notice] = I18n.t("cancellation.error", scope: "decidim.guest_meeting_registration")
            redirect_to Decidim::EngineRouter.main_proxy(@registration_request.component).meeting_path(@registration_request.meeting)
          end
        end
      end
    end
  end
end
