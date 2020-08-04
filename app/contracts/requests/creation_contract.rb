# frozen_string_literal: true

module Requests
  class CreationContract < Dry::Validation::Contract
    params do
      required(:name).filled(:str?)
      required(:email).filled(:str?)
      required(:phone_number).filled(:str?)
      required(:biography).filled(:str?)
    end

    rule(:email) do
      unless URI::MailTo::EMAIL_REGEXP.match(value)
        key.failure('has invalid format')
      end
    end
  end
end
