# frozen_string_literal: true

module Decidim
  module GuestMeetingRegistration
    module RegistrationSerializer
      def serialize
        insert_after_key(super, :user, :guest, guest_data)
      end

      private

      # I asked my AI friend to gimme a suggestion on how to do this.
      def insert_after_key(original_hash, key_to_find, key_to_insert, value_to_insert)
        new_hash = {}

        original_hash.each do |key, value|
          new_hash[key] = value
          new_hash[key_to_insert] = value_to_insert if key == key_to_find
        end

        new_hash
      end

      # I have not yet defined a way to avoid this N+1 query
      def guest_data
        Decidim::GuestMeetingRegistration::RegistrationRequest.exists?(meeting: resource.meeting, user: resource.user) ? "Yes" : "No"
      end
    end
  end
end
