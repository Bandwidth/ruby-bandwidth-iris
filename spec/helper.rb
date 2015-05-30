require 'simplecov'
require 'coveralls'
require 'yaml'

SimpleCov.formatter = SimpleCov::Formatter::MultiFormatter[
  SimpleCov::Formatter::HTMLFormatter,
  Coveralls::SimpleCov::Formatter
]
SimpleCov.start()

require 'ruby-bandwidth-iris'
require 'rspec'

RSpec.configure do |config|
  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end


RSpec.configure do |conf|
  include BandwidthIris
end



module Helper
  @xml = YAML.load(File.read(File.join(File.dirname(__FILE__), 'xml.yml')))
  def self.get_client()
    Client.new('accountId', 'username', 'password')
  end

  def self.setup_environment()
    Client.global_options[:account_id] = 'accountId'
    Client.global_options[:username] = 'username'
    Client.global_options[:password] = 'password'
    @stubs = Faraday::Adapter::Test::Stubs.new()
  end

  def self.stubs()
    @stubs
  end
  
  def self.xml()
    @xml
  end

  def self.camelcase v
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
end

class  BandwidthIris::Client
  alias_method :old_initialize, :initialize
  def initialize (account_id = nil, user_name = nil, password = nil, options = nil)
    old_initialize(account_id, user_name, password, options)
    @stubs = if account_id  then  Faraday::Adapter::Test::Stubs.new() else Helper.stubs end
    @set_adapter = lambda{|faraday| faraday.adapter(:test, @stubs)}
  end
 def stubs()
  @stubs
 end
end

