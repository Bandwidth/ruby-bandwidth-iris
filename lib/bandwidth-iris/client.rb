require 'faraday'
require 'certified'
require 'active_support/xml_mini'
require 'active_support/core_ext/hash/conversions'
require 'active_support/core_ext/string/inflections'


module BandwidthIris

  class Client
    def initialize (account_id = nil, user_name = nil, password = nil, options = nil)
      if user_name == nil && password == nil && options == nil
        if account_id && account_id.is_a?(Hash)
          options = account_id
        end
      end
      options = options || @global_options
      account_id = options[:account_id] unless account_id
      user_name = options[:user_name] || options[:username]  unless user_name
      password = options[:password] unless password
      options[:api_endpoint] = @@global_options[:api_endpoint] unless options[:api_endpoint]
      options[:api_version] = @@global_options[:api_version] unless options[:api_version]
      api_endpoint = options[:api_endpoint] || "https://api.inetwork.com"
      api_version = options[:api_version] || "v1.0"

      @build_path = lambda {|path| "/#{api_version}" + (if path[0] == "/" then path else "/#{path}" end) }
      @set_adapter = lambda {|faraday| faraday.adapter(Faraday.default_adapter)}
      @create_connection = lambda{||
        Faraday.new(api_endpoint) { |faraday|
          faraday.basic_auth(user_name, password)
          faraday.headers['Accept'] = 'text/xml'
          @set_adapter.call(faraday)
        }
      }
      @concat_account_path = lambda {|path| "/accounts/#{account_id}" + (if path[0] == "/" then path else "/#{path}" end) }
      @api_endpoint = api_endpoint
      @api_version = api_version
    end

    attr_reader :api_endpoint, :api_version

    @@global_options = {}

    # Return global options
    def Client.global_options
      @@global_options
    end

    # Set global options
    def Client.global_options=(v)
      @@global_options = v
    end

    # Extract id from location header
    # @param location [String] location header value
    # @return [String] extracted id
    def Client.get_id_from_location_header(location)
      items = (location || '').split('/')
      raise StandardError.new('Missing id in the location header') if items.size < 2
      items.last
    end

    # Make HTTP request to IRIS API
    # @param method [Symbol] http method to make
    # @param path [string] path of url (exclude api verion and endpoint) to make call
    # @param data [Hash] data  which will be sent with request (for :get and :delete request they will be sent with query in url)
    # @return [Array] array with 2 elements: parsed json data of response and response headers
    def make_request(method, path, data = {})
      d  = camelcase(data)
      connection = @create_connection.call()
      response =  if method == :get || method == :delete
                    connection.run_request(method, @build_path.call(path), nil, nil) do |req|
                      req.params = d unless d == nil || d.empty?
                    end
                  else
                    connection.run_request(method, @build_path.call(path), build_doc(d).to_xml(), {'Content-Type' => 'text/xml'})
                  end
      check_response(response)
      [if response.body.strip().size > 0 then parse_xml(response.body) else {} end, symbolize(response.headers || {})]
    end

    # Check response object and raise error if status code >= 400
    # @param response response object
    def check_response(response)
      if response.status >= 400
        parsed_body = parse_xml(response.body || '')
        code = find_first_descendant(parsed_body, :error_code)
        description = find_first_descendant(parsed_body, :description)
        unless code
          error = find_first_descendant(parsed_body, :error)
          if error
            code = error[:code]
            description = error[:description]
          else
            errors = find_first_descendant(parsed_body, :errors)
            if errors.length == 0
              code = find_first_descendant(parsed_body, :result_code)
              description = find_first_descendant(parsed_body, :result_message)
            else
              raise Errors::AgregateError.new(errors.map {|e| Errors::GenericError.new(e[:code], e[:description], response.status)})
            end
          end
        end
        raise Errors::GenericError.new(code, description, response.status) if code && description && code != '0'
        raise Errors::GenericError.new('', "Http code #{response.status}", response.status)
      end
    end

    # Build url path like /accounts/<account-id>/<path>
    def concat_account_path(path)
      @concat_account_path.call(path)
    end

    # Return new configured connection object
    # @return [Faraday::Connection] connection
    def create_connection()
      @create_connection.call()
    end

    protected

    # Convert all keys of a hash to camel cased strings
    def camelcase v
      case
        when v.is_a?(Array)
          v.map {|i| camelcase(i)}
        when v.is_a?(Hash)
          result = {}
          v.each do |k, val|
            result[k.to_s().camelcase(:lower)] = camelcase(val)
          end
          result
        else
          v
      end
    end

    # Convert all keys of hash to underscored symbols
    def symbolize v
      case
        when v.is_a?(Array)
          v.map {|i| symbolize(i)}
        when v.is_a?(Hash)
          result = {}
          v.each do |k, val|
            result[k.underscore().to_sym()] = symbolize(val)
          end
          result
        else
          v
      end
    end

    def parse_xml(xml)
      doc = ActiveSupport::XmlMini.parse(xml)
      process_parsed_doc(doc)
    end

    def build_doc(v)
      case
        when v.is_a?(Array)
          v.map {|i| build_doc(i)}
        when v.is_a?(Hash)
          result = {}
          v.each do |k, val|
            result[k.to_s().camelcase(:lower)] = build_doc(val)
          end
          result
        else
          v
      end
    end

    def process_parsed_doc(v)
      case
        when v.is_a?(Array)
          v.map {|i| process_parsed_doc(i)}
        when v.is_a?(Hash)
          result = {}
          v.each do |k, val|
            key =  if k.downcase() == 'lata' then :lata else k.underscore().to_sym() end
            result[key] = process_parsed_doc(val)
          end
          result
        when v == "true" || v == "false"
          v == "true"
        when /^\d{4}\-\d{2}-\d{2}T\d{2}\:\d{2}\:\d{2}(\.\d{3})?Z$/.match(v)
          DateTime.iso8601(v)
        when /\d{10}/.match(v)
          v
        when /\A[-+]?[0-9]*\.?[0-9]+\Z/.match(v)
          Float(v)
        else
          v
      end
    end
  end
end
