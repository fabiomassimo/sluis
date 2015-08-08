# Parameter validation
require 'json-schema'

module Requests
  class Base
    def self.schema
      {
          "description"=> "schema for a generic request",
          "additionalProperties" => false
      }
    end

    def self.protected
      false
    end

    def self.valid_parameters?(params)
      valid = false
      message = nil
      begin
        valid = JSON::Validator.validate!(self.schema, params)
      rescue JSON::Schema::ValidationError
        message = $!.message
      end
      return valid,message
    end

    def self.grant_access?(request)
      if ENV['RACK_ENV'] != 'development'
      #   #TODO: Is this needed?
      #   if request.env['HTTP_X_API_TOKEN'] != self.hmac_for_request(request)
      #     return false, "Access to a protected resource without authorization"
      #   end
      end

      if self.protected
        #TODO: Implement protection policy
      end

      true
    end


    def self.hmac_for_request(request)
      # get request url including HTTP method
      request_url = "#{request.request_method}#{request.scheme}#{request.host_with_port}#{request.path}"

      # # create request string by appending request parameters to request url (in alphabetical order)
      request_string = request_url

      request.params.keys.sort.each_with_index do |key, index|
        value = URI.escape(request.params[key])
        request_string << "#{key}=#{value}"

        unless index == request.params.keys.length - 1
          request_string << '&'
        end
      end

      # create SHA256 hash based on request string
      digest = OpenSSL::Digest::SHA256.new
      return OpenSSL::HMAC.hexdigest(digest, Settings::Helpers.get_settings.hmac_secret, request_string)
    end


  end
end