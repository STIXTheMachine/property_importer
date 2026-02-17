# frozen_string_literal: true

# Base class for services
class ApplicationService

  # Improves ergonomics by allowing you to use MyService.call(my_args) rather than MyService.new(my_args).call
  def self.call(*args)
    new(*args).call
  end
end
