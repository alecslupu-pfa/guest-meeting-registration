# frozen_string_literal: true

require "spec_helper"

describe "Admin manages registration settings", type: :system do
  let!(:registration) { create(:guest_meeting_registration) }
  let(:meeting) { registration.meeting }

  before do
    switch_to_host(meeting.organization.host)
  end

  def meeting_path
    Decidim::EngineRouter.main_proxy(meeting.component).meeting_url(meeting)
  end

  def cancellation_url(cancellation_token)
    "#{meeting_path}/guest-registration/cancellation/#{cancellation_token}"
  end
  #
  # it "raises not found error" do
  #   expect { visit cancellation_url("foobar") }.to raise_error(ActiveRecord::RecordNotFound)
  # end

  it "cancels the registration" do
    expect{ visit cancellation_url(registration.cancellation_token) }.to change(Decidim::GuestMeetingRegistration::RegistrationRequest, :count).by(-1)
  end

end