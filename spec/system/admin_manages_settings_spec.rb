# frozen_string_literal: true

require "spec_helper"

describe "Admin manages registration settings", type: :system do
  let(:organization) { create(:organization) }
  let(:user) { create(:user, :admin, :confirmed, organization: organization) }

  before do
    switch_to_host(organization.host)
    login_as user, scope: :user
  end

  it "enables the registration settings" do
    expect(Decidim::GuestMeetingRegistration::Setting.last).to be_nil

    visit decidim_admin.edit_organization_path
    click_on "Guest meeting settings"

    check "Enable guest registration"
    check "Enable registration confirmation"

    expect(Decidim::GuestMeetingRegistration::Setting.last).not_to be_enable_guest_registration
    expect(Decidim::GuestMeetingRegistration::Setting.last).not_to be_enable_registration_confirmation

    click_on "Update"

    expect(Decidim::GuestMeetingRegistration::Setting.last).to be_enable_guest_registration
    expect(Decidim::GuestMeetingRegistration::Setting.last).to be_enable_registration_confirmation
  end

  it "disables the registration settings" do
    create(:guest_meeting_registration_settings, :enabled, :require_confirmation, organization: organization)

    visit decidim_admin.edit_organization_path
    click_on "Guest meeting settings"

    uncheck "Enable guest registration"
    uncheck "Enable registration confirmation"

    expect(Decidim::GuestMeetingRegistration::Setting.last).to be_enable_guest_registration
    expect(Decidim::GuestMeetingRegistration::Setting.last).to be_enable_registration_confirmation

    click_on "Update"

    expect(Decidim::GuestMeetingRegistration::Setting.last).not_to be_enable_guest_registration
    expect(Decidim::GuestMeetingRegistration::Setting.last).not_to be_enable_registration_confirmation
  end
end
