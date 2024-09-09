# frozen_string_literal: true

class AddDisableNormalAccountToRegisterSettings < ActiveRecord::Migration[6.0]
  def change
    add_column :decidim_guest_meeting_registration_settings, :disable_account_confirmation, :boolean, default: false
  end
end
