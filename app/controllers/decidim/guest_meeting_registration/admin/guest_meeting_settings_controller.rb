# frozen_string_literal: true

module Decidim
  module GuestMeetingRegistration
    module Admin
      class GuestMeetingSettingsController < ApplicationController
        def edit
          enforce_permission_to :update, :organization, organization: current_organization

          @form = form(Decidim::GuestMeetingRegistration::Admin::GuestMeetingSettingForm).from_model(meeting_registration_settings)
        end

        def update
          enforce_permission_to :update, :organization, organization: current_organization

          @form = form(Decidim::GuestMeetingRegistration::Admin::GuestMeetingSettingForm).from_params(params)

          UpdateGuestMeetingSettings.call(meeting_registration_settings, @form) do
            on(:ok) do
              flash[:notice] = I18n.t("organization.update.success", scope: "decidim.admin")
              redirect_to action: :edit
            end

            on(:invalid) do
              flash.now[:alert] = I18n.t("organization.update.error", scope: "decidim.admin")
              render :edit
            end
          end
        end

        private

        def meeting_registration_settings
          @meeting_registration_settings ||= Decidim::GuestMeetingRegistration::Setting.where(organization: current_organization).first_or_create
        end
      end
    end
  end
end
