# frozen_string_literal: true

class CreateGuestMeetingRegistrationSettings < ActiveRecord::Migration[6.0]
  def change
    create_table :decidim_guest_meeting_registration_settings do |t|
      t.boolean :enable_guest_registration, default: false
      t.references :decidim_organization, foreign_key: true, index: { name: :index_guest_meeting_registration_settings_on_organization_id }

      t.timestamps
    end
  end
end
