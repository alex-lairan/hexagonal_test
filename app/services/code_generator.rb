# frozen_string_literal: true

require 'securerandom'

class CodeGenerator
  def call
    SecureRandom.hex
  end

  alias generate call
end
