# frozen_string_literal: true

require "decidim/core/test/factories"

FactoryBot.define do
  factory :guest_meeting_registration_settings, class: "Decidim::GuestMeetingRegistration::Setting" do
    organization
    enable_guest_registration { false }

    trait :enabled do
      enable_guest_registration { true }
    end
  end
end
