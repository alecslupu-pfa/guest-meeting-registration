# frozen_string_literal: true

module Decidim
  module GuestMeetingRegistration
    class Setting < ApplicationRecord
      belongs_to :organization,
                 foreign_key: "decidim_organization_id",
                 class_name: "Decidim::Organization"
    end
  end
end
