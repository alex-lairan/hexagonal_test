# frozen_string_literal: true

class ApplicationMailer < ActionMailer::Base
  default from: 'no-reply@hexagonal-coworking.com'
  layout 'mailer'
end
