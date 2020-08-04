# frozen_string_literal: true

class Request < ApplicationRecord
  EXPIRATION_WARNING = 3.month
  EXPIRATION_TIME = EXPIRATION_WARNING + 15.days

  enum status: %i[unconfirmed confirmed accepted expired]

  scope :for_email, lambda { |email|
    where(email: email).where(status: %i[confirmed accepted])
  }

  scope :waiting, -> { where(status: %i[unconfirmed confirmed]) }

  scope :warned, -> { where(is_expiration_warned: true) }
  scope :not_warned, -> { where(is_expiration_warned: false) }

  scope :expired_at, ->(time = DateTime.now) { where(arel_table[:last_confirmation].lt(time - EXPIRATION_TIME)) }
  scope :expiring, lambda { |time = DateTime.now|
    expiring = time - EXPIRATION_WARNING
    expired = time - EXPIRATION_TIME
    where(arel_table[:last_confirmation].between(expired..expiring))
  }

  def self.accept!
    request = confirmed.order(created_at: :desc).limit(1).first
    request&.accept!
  end

  def accept!
    status.accepted!
  end
end
