# frozen_string_literal: true

module Decidim
  module GuestMeetingRegistration
    class RegistrationRequest < ApplicationRecord
      belongs_to :organization, class_name: "Decidim::Organization", foreign_key: :decidim_organization_id
      belongs_to :meeting, class_name: "Decidim::Meetings::Meeting", foreign_key: :decidim_meetings_meetings_id
      belongs_to :user, class_name: "Decidim::User", optional: true, foreign_key: :decidim_user_id

      delegate :component, to: :meeting, prefix: false

      def create_confirmation_code!
        update!(confirmation_token: SecureRandom.hex)
      end
    end
  end
end
