# frozen_string_literal: true

module Decidim
  module GuestMeetingRegistration
    module Admin
      class GuestMeetingSettingForm < Decidim::Form
        attribute :enable_guest_registration, Boolean, default: false
      end
    end
  end
end
