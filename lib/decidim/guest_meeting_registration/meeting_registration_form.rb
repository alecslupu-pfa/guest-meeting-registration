# frozen_string_literal: true

module Decidim
  module GuestMeetingRegistration
    module MeetingRegistrationForm
      def self.prepended(base)
        base.class_eval do
          attribute :enable_guest_registration, ActiveModel::Type::Boolean, default: false
          attribute :enable_registration_confirmation, ActiveModel::Type::Boolean, default: false
          attribute :enable_cancellation, ActiveModel::Type::Boolean, default: false
          attribute :disable_account_confirmation, ActiveModel::Type::Boolean, default: false
        end
      end
    end
  end
end
