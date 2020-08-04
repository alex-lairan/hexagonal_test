# frozen_string_literal: true

module Requests
  # Given a system with requests
  # When a request have more than 3 months and 15 days
  # Then it mark requests as expired
  class ExpireRequests
    include Dry::Monads[:result]
    include Dry::Monads::Do.for(:call)
    extend Dry::Initializer

    option :request_model, default: -> { Request }

    def call(current_date)
      requests = @request_model.waiting.expired_at(current_date).warned
      requests.update status: :expired

      Success(requests)
    end
  end
end
