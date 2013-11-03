module Kapost
  # Intended to be extended in the base module namespace.
  #
  # @example
  #   module Kapost
  #     extend Configuration
  #   end
  #
  # Provides a simple DSL to configure the Kapost client
  #
  # @example
  #   Kapost.configure do |config|
  #     config.api_token = ENV['KAPOST_API_KEY']
  #     config.instance  = ENV['KAPOST_INSTANCE']
  #   end
  #
  module Configuration
    VALID_PARAMS    = [:api_token, :api_version, :endpoint, :instance, :api_path, :format, :user_agent, :domain].freeze
    REQUIRED_PARAMS = [:api_token, :instance]

    DEFAULT_DOMAIN      = 'kapost.com'
    DEFAULT_API_TOKEN   = nil
    DEFAULT_API_VERSION = 'v1'
    DEFAULT_API_PATH    = 'api'
    DEFAULT_INSTANCE    = nil
    DEFAULT_USER_AGENT  = "Kapost Ruby API Wrapper #{Kapost::VERSION}".freeze
    DEFAULT_FORMAT      = :json

    attr_accessor *VALID_PARAMS

    # Ensures default configuration is applied when the module is extended
    def self.extended(base)
      base.apply_config
    end

    # Applies default configuration options when the module is extended
    def apply_config
      self.domain      = DEFAULT_DOMAIN
      self.api_token   = DEFAULT_API_TOKEN
      self.api_version = DEFAULT_API_VERSION
      self.api_path    = DEFAULT_API_PATH
      self.instance    = DEFAULT_INSTANCE
      self.user_agent  = DEFAULT_USER_AGENT
      self.format      = DEFAULT_FORMAT
    end

    # Provides a common DSL for configuration
    def configure
      yield self
    end

    # Construct an options hash
    def options
      Hash[*VALID_PARAMS.map { |key| [key, send(key)] }.flatten]
    end

  end
end