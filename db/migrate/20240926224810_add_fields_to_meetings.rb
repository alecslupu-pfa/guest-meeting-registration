# frozen_string_literal: true

class AddFieldsToMeetings < ActiveRecord::Migration[6.0]
  def change
    add_column :decidim_meetings_meetings, :enable_guest_registration, :boolean, default: false
    add_column :decidim_meetings_meetings, :enable_registration_confirmation, :boolean, default: false
    add_column :decidim_meetings_meetings, :enable_cancellation, :boolean, default: false
    add_column :decidim_meetings_meetings, :disable_account_confirmation, :boolean, default: false
  end
end