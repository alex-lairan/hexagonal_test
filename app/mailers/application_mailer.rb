# frozen_string_literal: true

class ApplicationMailer < ActionMailer::Base
  default from: 'no-reply@sandbox40a8d69737d04d6bb79d9368c833b511.mailgun.org'
  layout 'mailer'
end
