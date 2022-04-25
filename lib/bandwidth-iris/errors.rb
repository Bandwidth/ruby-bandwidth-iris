module BandwidthIris
  module Errors
    # Generic error class
    class GenericError < StandardError
      # @return [String] HTTP status code
      attr_reader :http_status

      # return [String] Reason
      attr_reader :reason

      # return [Hash] Headers
      attr_reader :headers

      # return [Hash] Body
      attr_reader :body

      # @return [String] Iris Error code
      attr_reader :code

      # @api private
      def initialize http_status, reason, headers, body
        @http_status = http_status
        @reason = reason
        @headers = headers
        @body = body
        @code = body.nil? ? '' : body[:error][:code]
        super message = "HTTP Error\nStatus Code: #{@http_status}\nReason: #{@reason}\nHTTP Headers: #{@headers}\nResponse Body: #{@body}\nIris Error Code: #{@code}"
      end
    end

    # Agregate error class
    class AgregateError < StandardError
      # @return [Array] errors
      attr_reader :errors

      # @api private
      def initialize errorss
        super "Multiple errors"
        @errors = errors
      end
    end
  end
end
