lib = File.expand_path("../../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require "ruby-bandwidth-iris"

def order_numbers_in_area_code(client, site_id:, sippeer_id:, area_code: 919, quantity: 1)
  order_data = {
      :name => "Test",
      :site_id => site_id,
      :area_code_search_and_order_type => {
          :area_code => area_code,
          :quantity => quantity
      }
  }
  order_result = BandwidthIris::Order.create(client, order_data)
  order_id = order_result.to_data[:id]
  return order_id
end

def get_order_by_id(client, order_id:, attempts: 0)
  begin
    order_result = BandwidthIris::Order.get(client, order_id)
    return order_result
  rescue Exception => e
    if attempts > 3
      puts("Completely Failed fetching Order")
      raise StandardError.new e
    end
    puts("Error Message: #{e.message}\nCode:#{e.code}")
    attempts = attempts+1
    sleep(1)
    return get_order_by_id(client, order_id: order_id, attempts: attempts)
  end
end

def get_order_response_by_id(client, order_id:, attempts: 0)
  begin
    order_response = BandwidthIris::Order.get_order_response(client, order_id)
    order_data = order_response.to_data
    numbers = order_response.completed_numbers
    completed_number = order_data[:completed_numbers][:telephone_number][:full_number]
    return order_data
  rescue Exception => e
    if attempts > 3
      puts("Completely Failed fetching Order")
      raise StandardError.new e
    end
    puts("Error Message: #{e.message}\nCode:#{e.code}")
    attempts = attempts+1
    sleep(1)
    return get_order_response(client, order_id: order_id, attempts: attempts)
  end
end


def get_numbers_from_order_id(client, order_id:)
  order = BandwidthIris::Order.new({:id => order_id}, client)
  numbers_result = order.get_tns
  return numbers_result
end

def get_numbers_from_order(order)
  numbers_result = order.get_tns
  return numbers_result
end

def main
  bandwidth_account_id = ENV["BANDWIDTH_ACCOUNT_ID"]
  bandwidth_user_name = ENV["BANDWIDTH_API_USER"]
  bandwidth_password = ENV["BANDWIDTH_API_PASSWORD"]
  bandwidth_site_id = ENV["BANDWIDTH_SITE_ID"]
  bandwidth_to_sippeer_id = ENV["BANDWIDTH_SIPPEER_ID"]
  client = BandwidthIris::Client.new(bandwidth_account_id, bandwidth_user_name, bandwidth_password)
  order_id = order_numbers_in_area_code(client, site_id: bandwidth_site_id, sippeer_id: bandwidth_to_sippeer_id)
  my_order = get_order_by_id(client, order_id: order_id)
  my_order_response = get_order_response_by_id(client, order_id: order_id)
  my_numbers = get_numbers_from_order_id(client, order_id:order_id)
  my_numbers = get_numbers_from_order(my_order)
end

if __FILE__ == $0
  main
end
