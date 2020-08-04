# frozen_string_literal: true

module Requests
  # Given a user
  # When he creates a request
  # Then it is stored as unconfirmed request
  # And send a mail to the email address
  class CreateRequest
    include Dry::Monads[:result]
    include Dry::Monads::Do.for(:call)
    extend Dry::Initializer

    option :request_model, default: -> { Request }
    option :contract, default: -> { CreationContract.new }
    option :mailer, default: -> { RequestsMailer }
    option :code_generator, default: -> { CodeGenerator.new }

    def call(params)
      schema = yield validate(params)
      yield ensure_unique_email(schema)
      request = yield persist(schema)
      yield send_email(request)

      Success(request)
    end

    private

    def validate(params)
      @contract.call(params).to_monad
    end

    def ensure_unique_email(schema)
      if @request_model.for_email(schema[:email]).exists?
        Failure(email: ['is already taken'])
      else
        Success(schema)
      end
    end

    def persist(schema)
      model = @request_model.create(
        **schema.values,
        status: 'unconfirmed',
        confirmation_code: code_generator.generate,
        last_confirmation: DateTime.now
      )
      Success(model)
    end

    def send_email(request)
      mail = @mailer.with(request: request).validate_email
      mail.deliver_now

      Success(request)
    end
  end
end
