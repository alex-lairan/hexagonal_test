# frozen_string_literal: true

module Requests
  # Given a user with a request
  # When he validates his request with the mail code
  # Then it validates his request
  # And lock the email address until the request expire
  class ConfirmEmailRequest
    include Dry::Monads[:result]
    include Dry::Monads::Do.for(:call)
    extend Dry::Initializer

    option :request_model, default: -> { Request }

    def call(params)
      request = yield search_request(params)
      yield ensure_unique_email(request)
      request = yield confirm(request)

      Success(request)
    end

    private

    def search_request(params)
      request = @request_model.where(confirmation_code: params[:confirmation_code]).find(params[:id])

      Success(request)
    rescue ActiveRecord::RecordNotFound
      Failure(record: ['is not found'])
    end

    def ensure_unique_email(request)
      if @request_model.for_email(request.email).exists?
        Failure(email: ['is already taken'])
      else
        Success(request)
      end
    end

    def confirm(request)
      request.confirmed!

      Success(request)
    end
  end
end
