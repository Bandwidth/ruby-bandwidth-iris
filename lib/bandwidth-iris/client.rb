require 'faraday'
require 'faraday_middleware'
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
          account_id = nil
        end
      end
      options = options || @@global_options
      account_id = options[:account_id] unless account_id
      user_name = options[:user_name] || options[:username]  unless user_name
      password = options[:password] unless password
      options[:api_endpoint] = @@global_options[:api_endpoint] unless options[:api_endpoint]
      options[:api_version] = @@global_options[:api_version] unless options[:api_version]
      api_endpoint = options[:api_endpoint] || "https://dasbhoard.bandwidth.com"
      api_version = options[:api_version] || "v1.0"

      @build_path = lambda {|path| "/#{api_version}" + (if path[0] == "/" then path else "/#{path}" end) }
      @set_adapter = lambda {|faraday| faraday.adapter(Faraday.default_adapter)}
      @create_connection = lambda{||
        Faraday.new(api_endpoint) { |faraday|
          faraday.basic_auth(user_name, password)
          #faraday.response :logger
          faraday.headers['Accept'] = 'application/xml'
          faraday.headers['user-agent'] = 'Ruby-Bandwidth-Iris'
          faraday.use FaradayMiddleware::FollowRedirects
          @set_adapter.call(faraday)
        }
      }
      @concat_account_path = lambda {|path| "/accounts/#{account_id}" + (if path then (if path[0] == "/" then path else "/#{path}" end) else '' end) }
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
    # @return [Array] array with 2 elements: parsed  data of response and response headers
    def make_request(method, path, data = {})
      connection = @create_connection.call()
      response =  if method == :get || method == :delete
                    d  = camelcase(data)
                    connection.run_request(method, @build_path.call(path), nil, nil) do |req|
                      req.params = d unless d == nil || d.empty?
                    end
                  else
                    xml_to_send = build_xml(data) # help debug
                    connection.run_request(method, @build_path.call(path), xml_to_send, {'Content-Type' => 'application/xml'})
                  end
      body = check_response(response)
      [body || {}, symbolize(response.headers || {})]
    end

    # Makes an HTTP request for file uploads
    # @param method [Symbol] http method to make
    # @param path [string] path of url (exclude api verion and endpoint) to make call
    # @param data [string] the raw binary string representing the file to upload
    # @param content_type [string] the content type of the request
    # @return [Array] array with 2 elements: parsed  data of response and response headers
    def make_request_file_upload(method, path, data, content_type)
      connection = @create_connection.call()
      response = connection.run_request(method, @build_path.call(path), data, {'Content-Type' => content_type})
      body = check_response(response)
      [body || {}, symbolize(response.headers || {})]
    end

    # Makes an HTTP request for a file download
    # @param method [Symbol] http method to make
    # @param path [string] path of url (exclude api verion and endpoint) to make call
    # @param data [Hash] data  which will be sent with request (for :get and :delete request they will be sent with query in url)
    # @return [string] raw response from the API
    def make_request_file_download(method, path, data = {})
      connection = @create_connection.call()
      response =  if method == :get || method == :delete
                    d  = camelcase(data)
                    connection.run_request(method, @build_path.call(path), nil, nil) do |req|
                      req.params = d unless d == nil || d.empty?
                    end
                  else
                    connection.run_request(method, @build_path.call(path), build_xml(data), {'Content-Type' => 'application/xml'})
                  end
      return response.body
    end

    # Check response object and raise error if status code >= 400
    # @param response response object
    def check_response(response)
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
          if errors == nil || errors.length == 0
            code = find_first_descendant(parsed_body, :result_code)
            description = find_first_descendant(parsed_body, :result_message)
          else
            errors = [errors] if errors.is_a?(Hash)
            raise Errors::AgregateError.new(errors.map {|e| Errors::GenericError.new(e[:code], e[:description], response.status)})
          end
        end
      end
      raise Errors::GenericError.new(code, description, response.status) if code && description && code != '0' && code != 0
      raise Errors::GenericError.new('', "Http code #{response.status}", response.status) if response.status >= 400
      parsed_body
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

    def build_xml(data)
       doc = build_doc(data, data.keys.first.to_s().camelcase(:upper))
       doc.values.first.to_xml({:root => doc.keys.first, :skip_types => true, :indent => 0 })
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
      process_parsed_doc(doc.values.first)
    end

    def build_doc(v, name)
      case
        when v.is_a?(Array)
          list = v.map {|i| build_doc(i, name)}
          list.extend(XmlArraySerializer)
          list.element_name = name
          list
        when v.is_a?(Hash)
          result = {}
          v.each do |k, val|
            if k[0] != '_'
              element_name = v["_#{k}XmlElement"] || (k.to_s().camelcase(:upper))
              result[element_name] = build_doc(val, element_name)
            end
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
          return process_parsed_doc(v['__content__']) if v.keys.length == 1 && v['__content__']
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
        when /\A\d{9}\d?\Z/.match(v)
          v
        when /\A[1-9]\d*\Z/.match(v)
          Integer(v)
        when /\A[-+]?[0-9]*\.?[0-9]+\Z/.match(v)
          Float(v)
        else
          v
      end
    end

    def find_first_descendant v, name
      result = nil
      case
        when v.is_a?(Array)
          v.each do |val|
            result = find_first_descendant(val, name)
            break if result
          end
        when v.is_a?(Hash)
          v.each do |k, val|
            if k == name
              result = val
              break
            else
              result = find_first_descendant(val, name)
              break if result
            end
          end
      end
      result
    end
  end

  module XmlArraySerializer
    def element_name=(name)
      @element_name = name
    end

    def to_xml(options = {})
      builder = options[:builder]
      self.map do |item|
        if item.class.method_defined?(:to_xml)
          builder << item.to_xml({skip_instruct: true, root: @element_name, skip_types: true, indent:0})
        else
          builder << "<#{@element_name}>#{item}</#{@element_name}>"
        end
      end
      builder
    end
  end
end

