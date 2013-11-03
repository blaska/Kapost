require "rest_client"
require "json"

require "kapost/version"
require "kapost/configuration"
require "kapost/content"
require "kapost/client"

module Kapost
  extend Configuration

  # TODO: Figure our how to over-ride RestClient's errors :nodoc:
  class KapostError < StandardError
    attr_reader :error

    def initialize(error)
      @error = error
      super
    end
  end

  class Unauthorized < KapostError; end
  class Forbidden < KapostError; end
  class NotFound < KapostError; end
  class ServerError < KapostError; end
  class BadGateway < KapostError; end
  class ServiceUnavailable < KapostError; end

end
