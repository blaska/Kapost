module Kapost
  class Client

    include Content

    attr_accessor *Configuration::VALID_PARAMS

    # Create a new instance of Kapost::Client
    #
    # @param [Hash] options Options to configure the client
    #
    # @example
    #   client = Kapost::Client.new(:api_key => ENV['KAPOST_API_KEY'], :instance => ENV['KAPOST_INSTANCE'])
    #
    # @raise [ArgumentError] when required options are not set
    # @return [Object]
    def initialize(options = {})
      config = Kapost.options.merge(options)

      Configuration::REQUIRED_PARAMS.map do |param|
        raise ArgumentError, "Required parameter: #{param} is not set" if config[param].nil?
      end

      Configuration::VALID_PARAMS.each { |key| send("#{key}=", config[key]) }

      fqdn = [Kapost.instance, Kapost.domain].join('.')
      url  = ["https://#{fqdn}", Kapost.api_path, Kapost.api_version].join('/')

      @client = ::RestClient::Resource.new(url, :user => Kapost.api_token, :password => nil, :user_agent => Kapost.user_agent)
    end

    private

    # Performs an HTTP GET operation
    #
    # @private
    # @param [String] path The path to the resource
    # @param [Hash] params Parameters to be sent with the request
    # @return [Hash] response body
    def get(path, params)
      parse_response @client[path].get(:params => params)
    end

    # Performs an HTTP POST operation
    #
    # @private
    # @param [String] path The path to the resource
    # @param [Hash] params Parameters to be sent with the request
    # @return [Hash] response body
    def post(path, params)
      parse_response @client[path].post(params)
    end

    # Performs an HTTP PUT operation
    #
    # @private
    # @param [String] path The path to the resource
    # @param [Hash] params Parameters to be sent with the request
    # @return [Hash] response body
    def put(path, params)
      parse_response @client[path].put(params)
    end

    # Performs an HTTP DELETE operation
    #
    # @private
    # @param [String] path The path to the resource
    # @param [Hash] params Parameters to be sent with the request
    # @return [Boolean]
    def delete(path, params)
      parse_response @client[path].delete(:params => params)
    end

    # Validates the response & raises any errors encountered
    #
    # @private
    # @param [Object] response The response object
    # @return [Hash] The response body
    # @raise [KapostError]
    def parse_response(response)
      case response.code
      # Successful get/create/update
      when 200..201
        JSON.parse(response, :symbolize_names => true)[:response]
      # Successful delete
      when 204
        true
      when 400
        raise Kapost::BadRequest, "[#{response.code}] Input parameters were missing or in the incorrect format"
      when 401
        raise Kapost::Unauthorized, "[#{response.code}] Incorrect authentication credentials"
      when 403
        raise Kapost::Forbidden, "[#{response.code}] Credentials were correct but the account doesn't have permission to perform the action)"
      when 404
        raise Kapost::NotFound, "[#{response.code}] The entity requested by id or slug doesn't exist)"
      when 500
        raise Kapost::ServerError, response.code
      when 502
        raise Kapost::BadGateway, response.code
      when 503
        raise Kapost::ServiceUnavailable, response.code
      else
        raise "Response was not understood"
      end
    end

  end
end