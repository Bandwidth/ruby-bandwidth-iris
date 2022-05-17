lib = File.expand_path('../../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require 'yaml'
require 'ruby-bandwidth-iris'
config = YAML.load_file('config.yml')

BandwidthIris::Client.global_options = {
  :api_endpoint => config['api_endpoint'],
  :user_name => config['user_name'],
  :password => config['password'],
  :account_id => config['account_id']
}

@portins = Array.new    # All portins on the account will be stored in this array
page = BandwidthIris::PortIn.list({'page': 1, 'size': 5})   # Get the first page of paginated portin results

def get_portins(page)   # Recursively check for more pages of results and populate array with portins from current page
    page.each do |portin|
        @portins.push(portin)
    end
    unless page.next.nil?
        get_portins(page.next)
    end
end

get_portins(page)
puts "Total Port-Ins: #{@portins.length()}"  # Print total number of portins on account
