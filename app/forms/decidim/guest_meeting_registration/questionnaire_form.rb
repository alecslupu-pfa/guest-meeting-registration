# frozen_string_literal: true

module Decidim
  module GuestMeetingRegistration
    class QuestionnaireForm < Decidim::Forms::QuestionnaireForm
      attribute :email
      attribute :name

      validates :name, presence: true
      validates :email, presence: true, "valid_email_2/email": { disposable: true }
    end
  end
end
