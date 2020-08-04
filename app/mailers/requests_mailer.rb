# frozen_string_literal: true

class RequestsMailer < ApplicationMailer
  def validate_email
    @request = params[:request]
    @url = APP_DOMAIN + "/requests/#{@request.id}/confirm?confirmation_code=#{@request.confirmation_code}"

    mail(to: @request.email, subject: 'Validate your email')
  end

  def expiring
    @request = params[:request]
    @url = APP_DOMAIN + "/requests/#{@request.id}/reconfirm?confirmation_code=#{@request.confirmation_code}"

    mail(to: @request.email, subject: 'Your request expiring')
  end
end
