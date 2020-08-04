# frozen_string_literal: true

module Requests
  # Given a user with a request
  # When he confirm his interest for the request with the mail code
  # Then it adds 3 more month
  class ConfirmInterestRequest
    include Dry::Monads[:result]
    include Dry::Monads::Do.for(:call)
    extend Dry::Initializer

    option :request_model, default: -> { Request }

    def call(params)
      request = yield search_request(params)
      request = yield confirm_interest(request)

      Success(request)
    end

    private

    def search_request(params)
      request = @request_model.where(confirmation_code: params[:confirmation_code]).find(params[:id])

      Success(request)
    rescue ActiveRecord::RecordNotFound
      Failure(record: ['is not found'])
    end

    def confirm_interest(request)
      request.update last_confirmation: DateTime.now, is_expiration_warned: false

      Success(request)
    end
  end
end
