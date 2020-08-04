class RequestsController < ApplicationController
  include Dry::Monads[:result]

  def create
    case Requests::CreateRequest.new.call(params.to_unsafe_h['request'])
    in Success(request)
      render json: { request: request }, status: 201
    in Failure(result) if result.is_a? Dry::Validation::Result
      render json: { errors: result.errors.to_h }, status: 400
    in Failure(errors)
      render json: { errors: errors }, status: 400
    else
      raise 'Unexpected behaviour'
    end
  end

  def new
    @request = Request.new
  end

  def confirm
    case Requests::ConfirmEmailRequest.new.call(params)
    in Success(request)
      render json: { request: request }, status: 200
    in Failure(*errors)
      render json: { errors: errors }, status: 400
    else
      raise 'Unexpected behaviour'
    end
  end

  def reconfirm
    case Requests::ConfirmInterestRequest.new.call(params)
    in Success(request)
      render json: { request: request }, status: 200
    in Failure(*errors)
      render json: { errors: errors }, status: 400
    else
      raise 'Unexpected behaviour'
    end
  end
end
