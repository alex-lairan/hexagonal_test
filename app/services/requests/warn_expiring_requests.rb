# frozen_string_literal: true

module Requests
  # Given a system with requests
  # When a request have more than 3 months
  # Then it mark requests as expiring and send an email
  class WarnExpiringRequests
    include Dry::Monads[:result]
    include Dry::Monads::Do.for(:call)
    extend Dry::Initializer

    option :request_model, default: -> { Request }
    option :mailer, default: -> { RequestsMailer }

    def call(current_date)
      requests = @request_model.waiting.expiring(current_date).not_warned

      send_warning_to(requests)
      requests.update is_expiration_warned: true

      Success(requests)
    end

    private

    # TODO: Bulk email sending
    def send_warning_to(requests)
      requests.map { @mailer.with(request: _1).expiring }
              .map(&:deliver_now)
    end
  end
end
