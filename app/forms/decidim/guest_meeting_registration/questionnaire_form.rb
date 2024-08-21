# frozen_string_literal: true

module Decidim
  module GuestMeetingRegistration
    class QuestionnaireForm < Decidim::Forms::QuestionnaireForm
      attribute :email
      attribute :name

      validates :name, presence: true
      validates :email, presence: true, "valid_email_2/email": { disposable: true }

      def initialize(attributes = {})
        @submitted_params = attributes.deep_symbolize_keys.slice(:responses, :email, :name, :public_participation, :tos_agreement)

        super
      end

      attr_reader :submitted_params

      def session_token_in_context; end
    end
  end
end
