# frozen_string_literal: true

require "decidim/core/test/factories"

FactoryBot.define do
  factory :guest_meeting_registration_settings, class: "Decidim::GuestMeetingRegistration::Setting" do
    organization
    enable_guest_registration { false }
    enable_registration_confirmation { false }
    enable_cancellation { false }

    trait :enabled do
      enable_guest_registration { true }
    end

    trait :require_confirmation do
      enable_registration_confirmation { true }
    end
    trait :cancellable do
      enable_cancellation { true }
    end
  end
end
