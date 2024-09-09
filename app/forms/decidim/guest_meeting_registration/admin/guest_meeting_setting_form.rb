# frozen_string_literal: true

module Decidim
  module GuestMeetingRegistration
    module Admin
      class GuestMeetingSettingForm < Decidim::Form
        attribute :enable_guest_registration, Boolean, default: false
        attribute :enable_registration_confirmation, Boolean, default: false
        attribute :enable_cancellation, Boolean, default: false
        attribute :disable_account_confirmation, Boolean, default: false
      end
    end
  end
end
