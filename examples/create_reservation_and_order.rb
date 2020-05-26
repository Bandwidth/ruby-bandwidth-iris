lib = File.expand_path("../../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require 'ruby-bandwidth-iris'

$bandwidth_account_id = ENV['BANDWIDTH_ACCOUNT_ID']
$bandwidth_user_name = ENV['BANDWIDTH_API_USER']
$bandwidth_password = ENV['BANDWIDTH_API_PASSWORD']
## Fill these in
$bandwidth_site_id = ENV['BANDWIDTH_SITE_ID']
$bandwidth_to_sippeer_id = ENV['BANDWIDTH_SIPPEER_ID']


def get_order_by_id(client, order_id:, attempts: 0)
  begin
    order_result = BandwidthIris::Order.get(client, order_id)
    return order_result
  rescue Exception => e
    if attempts > 3
      puts("Completely Failed fetching Order")
      raise StandardError.new e
    end
    puts("Error Message: #{e.message}")
    attempts = attempts+1
    sleep(1)
    return get_order_by_id(client, order_id: order_id, attempts: attempts)
  end
end

def get_numbers_from_order_id(client, order_id:)
  order = BandwidthIris::Order.new({:id => order_id}, client)
  numbers_result = order.get_tns
  return numbers_result
end

def order_numbers_with_reservation_id(client, reservation_id:, number:)
  order_data = {
      :name => "Reservation Test",
      :site_id => $bandwidth_site_id,
      :existing_telephone_number_order_type => {
          :telephone_number_list => [
              :telephone_number => number
          ],
          :reservation_id_list => [
            :reservation_id => reservation_id
          ]
      }
  }
  order_result = BandwidthIris::Order.create(client, order_data)
  return order_result
end

def reserve_numbers(client, number:)
  reservation = BandwidthIris::TnReservation.create(client, number)
  return reservation
end

def search_numbers(client, area_code: 919)
  list = BandwidthIris::AvailableNumber.list(client, {:area_code => area_code, :quantity => 5})
  return list
end

def main()
  client = BandwidthIris::Client.new($bandwidth_account_id, $bandwidth_user_name, $bandwidth_password)
  available_numbers = search_numbers(client)
  number = available_numbers[0]
  reservation = reserve_numbers(client, number: number)
  reservation_id = reservation.id
  order = order_numbers_with_reservation_id(client, reservation_id: reservation_id, number: number)
  order_id = order.id
  puts(order_id)
  my_order = get_order_by_id(client, order_id: order_id)
  my_numbers = get_numbers_from_order_id(client, order_id:order_id)
  puts(my_numbers)
end

if __FILE__ == $0
  main
end
