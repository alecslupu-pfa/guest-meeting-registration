# frozen_string_literal: true

module Decidim
  module GuestMeetingRegistration
    class JoinMeetingButtonCell < Decidim::ViewModel
      delegate :enable_guest_registration?, to: :meeting_registration_settings, prefix: false
      delegate :on_different_platform?, :has_available_slots?, :registration_form_enabled?, :remaining_slots, to: :model, prefix: false
      delegate :current_user, to: :controller, prefix: false
      delegate_missing_to :controller

      def show
        return original_button if current_user.present?
        return original_button if on_different_platform?
        return original_button unless registration_form_enabled?
        return original_button unless enable_guest_registration?

        render
      end

      private

      def guest_registration_path
        Decidim::EngineRouter.main_proxy(current_component).decidim_guest_meeting_registration_path(meeting_id: model.id)
      end

      def button_classes
        return "button expanded button--sc" if big_button?

        "button card__button button--sc small"
      end

      def big_button?
        options[:big_button]
      end

      def i18n_join_text
        return I18n.t("join", scope: "decidim.meetings.meetings.show") if has_available_slots?

        I18n.t("no_slots_available", scope: "decidim.meetings.meetings.show")
      end

      def shows_remaining_slots?
        options[:show_remaining_slots] && model.available_slots.positive?
      end

      def original_button
        cell "decidim/meetings/join_meeting_button", model, **options
      end

      def meeting_registration_settings
        @meeting_registration_settings ||= Decidim::GuestMeetingRegistration::Setting.where(organization: current_organization).first_or_create
      end
    end
  end
end
