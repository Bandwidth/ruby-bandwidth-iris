# ruby-bandwidth-iris

[![Build Status](https://travis-ci.org/bandwidthcom/ruby-bandwidth-iris.svg)](https://travis-ci.org/bandwidthcom/ruby-bandwidth-iris)

Ruby Client library for IRIS / BBS API

## Release Notes

| Release Version | Notes |
|--|--|
| 1.0.5 | Fixed incorrect generation of XML for a Disconnect request |
| 2.0.0 | Added `importTnOrders`, `removeImportedTnOrders`, `inserviceNumbers`, and `importTnChecker` endpoints. This release also changed the response body of `BandwidthIris::InServiceNumber.list()`. Please make sure to update your code to include this change. |
| 2.0.1 | Updated gem dependencies to be less restrictive |
| 2.1.0 | Added `csrs` endpoints |
| 2.2.0 | Added `loas` endpoints to `importTnOrders` |
| 3.0.0.pre | Removed functionality that causes an error to be raised when some type of `error` field is returned in the XML body response. This change reduces the situations that cause an error to be thrown to simply be 4XX and 5XX http responses. This change was made to improve communication when an error is found. Please update your code to handle this change. |

### 3.x.x release

```ruby
failed_import_tn_order = "some_id"
begin
    response = BandwidthIris::ImportTnOrders.get_import_tn_order(failed_import_tn_order)
    puts response[0]
rescue BandwidthIris::Errors::GenericError => e
    puts e
end
```

#### 2.x.x result

```
Messaging route of External Third Party TNs is not configured.
```

#### 3.x.x result

```
{:customer_order_id=>"custom_id", :order_create_date=>Mon, 02 Mar 2020 20:56:48 +0000, :account_id=>123, :created_by_user=>"user", :order_id=>"0f2", :last_modified_date=>Mon, 02 Mar 2020 20:56:48 +0000, :site_id=>123, :subscriber=>{:name=>"Company INC", :service_address=>{:house_number=>123, :street_name=>"Street", :city=>"City", :state_code=>"XY", :zip=>12345, :county=>"County", :country=>"Country", :address_type=>"Service"}}, :loa_authorizing_person=>"Person", :telephone_numbers=>{:telephone_number=>"5554443333"}, :processing_status=>"FAILED", :errors=>{:error=>{:code=>19005, :description=>"Messaging route of External Third Party TNs is not configured.", :telephone_numbers=>{:telephone_number=>"5554443333"}}}, :sip_peer_id=>123}
```

## Install

Run

```
gem install ruby-bandwidth-iris
```

## Run Tests

Run

```
bundle install
rake spec
```

to run the tests

## Usage

```ruby
require 'ruby-bandwidth-iris'

# Using  directly
client = BandwidthIris::Client.new('accountId', 'userName', 'password')
sites = BandwidthIris::Site.list(client)

# Or you can use default client instance (do this only once)
BandwidthIris::Client.global_options = {
  :account_id => 'accountId',
  :username => 'userName',
  :password => 'password'
}

# Now you can call any functions without first arg 'client'

sites = BandwidthIris::Site.list()

```

## Examples
There is an 'examples' folder in the source tree that shows how each of the API objects work with simple example code.  To run the examples:

```bash
$ cd examples
$ cp config.yml.example config.yml
```
Edit the config.yml to match your IRIS credentials and run the examples individually.  e.g.

```bash
ruby covered_rate_centers.rb
```
If the examples take command line parameters, you will get the usage by just executing the individual script.


## API Objects
### General principles
When fetching objects from the API, it will always return an object that has the client
instantiated so that you can call dependent methods as well as update, delete.

Example:
```ruby
site = BandwidthIris::Site.create({siteObject})

# or

site = BandwidthIris::Site.create(client, {siteObject})

```

Each entity has a get, list, create, update and delete method if appropriate.

All properties are underscored and low-cased for Ruby readability, and are converted on the fly to the proper
case by the internals of the API when converted to XML.

## Available Numbers

```Ruby
list = BandwidthIris::AvailableNumber.list(query)
```

## Available NpaNxx
```ruby
list = BandwidthIris::AvailableNpaNxx.list({:area_code => "818", :quantity =>5})
```

## Cities
```ruby
list = BandwidthIris::City.list({:available => true, :state =>"CA"})
```

## Covered Rate Centers
```ruby
BandwidthIris::CoveredRateCenter.list({:zip => "27601"})
```

## Disconnected Numbers
Retrieves a list of disconnected numbers for an account
```ruby
BandwidthIris::DiscNumber.list({:area_code => "919"})
```

## Disconnect Numbers
The Disconnect object is used to disconnect numbers from an account.  Creates a disconnect order that can be tracked

### Create Disconnect
```ruby
order = BandwidthIris::Disconnect.create("Disconnect Order Name", ["9195551212", "9195551213"])
```

### Add Note to Disconnect
```ruby
order.add_note({:user_id => "my id", :description => "Test"})
```

### Get Notes for Disconnect
```ruby
order.get_notes()
```

## Dlda

### Create Ddla
```ruby
dlda_data = {
  :customer_order_id => "Your Order Id",
  :dlda_tn_groups => [
    :dlda_tn_group => {
      :telephone_numbers => ["9195551212"],
      :subscriber_type => "RESIDENTIAL",
      :listing_type => "LISTED",
      :listing_name => {
        :first_name => "John",
        :last_name => "Smith"
      },
      :list_address => true,
      :address => {
        :house_number => "123",
        :street_name => "Elm",
        :street_suffix => "Ave",
        :city => "Carpinteria",
        :state_code => "CA",
        :zip => "93013",
        :address_type => "DLDA"
      }
    }
  ]
}

BandwidthIris::Dlda.create(dlda_data)
```

### Get Dlda
```ruby
dlda = Bandwidth::Dlda.get("dlda_id")
```

### Get Dlda History
```ruby
dlda.get_history()
```

### List Dldas
```ruby
BandwidthIris::Dlda.list({:telephone_number => "9195551212"})
```

## Import To Account
This path is generally not available to Bandwidth accounts, and as such is not documented in this API

## In Service Numbers

### List InService Numbers
```ruby
BandwidthIris::InServiceNumber.list({:area_code => "919"})
```

### Get InService Number Detail
```ruby
BandwidthIris::InServiceNumber.get("9195551212")
```

## Lidb

### Create
```ruby
data = {
  :customer_order_id => "A test order",
  :lidb_tn_groups => {
    :lidb_tn_group => {
      :telephone_numbers => ["8048030097", "8045030098"],
      :subscriber_information => "Joes Grarage",
      :use_type => "RESIDENTIAL",
      :visibility => "PUBLIC"
    }
  }
}
BandwidthIris::Lidb.create(data)
```
### Get Lidb
```ruby
BandwidthIris::Lidb.get("lidb_id")
```
### List Lidb
```ruby
BandwidthIris::Lidb.list({:telephone_number => "9195551212"})
```

## LNP Checker
### Check LNP
```ruby
numbers = ["9195551212", "9195551213"]
full_check = true
BandwidthIris::LnpChecker.check(numbers, full_check)
```

## LSR Orders
### Create LSR Order
```ruby
data = {
  :pon => "Some Pon",
  :customer_order_id => "MyId5",
  'sPID' => "123C",
  :billing_telephone_number => "9192381468",
  :requested_foc_date => "2015-11-15",
  :authorizing_person => "Jim Hopkins",
  :subscriber => {
    :subscriber_type => "BUSINESS",
    :business_name => "BusinessName",
    :service_address => {
      :house_number => "11",
      :street_name => "Park",
      :street_suffix => "Ave",
      :city => "New York",
      :state_code => "NY",
      :zip => "90025"
    },
    :account_number => "123463",
    :pin_number => "1231"
  },
  :list_of_telephone_numbers => {
    :telephone_number => ["9192381848", "9192381467"]
  }
}

BandwidthIris::LsrOrder.create(data)
```
### Get LSR Order
```ruby
BandwidthIris::LsrOrder.get("lsr_order_response_id")
```
### List LSR Orders
```ruby
BandwidthIris::LsrOrder.list({:pon =>"Some Pon"})
```
### Update LSR Order
```ruby
order.requestedFocDate = "2015-11-16"
BandwidthIris::LsrOrder.update(order)
```
### Get LSR Order History
```ruby
order.get_history()
```
### Get LSR Order Notes
```ruby
order.get_notes()
```
### Add LSR Order Note
```ruby
note = {:user_id => "my id", :description => "Test"}
order.add_note(note)
```

## Orders
### Create Order
```ruby
order_data = {
  :name => "A Test Order",
  :site_id => 1111,
  :existing_telephone_number_order_type => {
    :telephone_number_list =>
      {
        :telephone_number => ["9195551212"]
      }

  }
}

BandwidthIris::Order.create(order_data)
```
### Get Order
```ruby
order = BandwidthIris::Order.get("order_id")
```
### List Orders
```ruby
BandwidthIris::Order.list(query)
```
### Order Instance Methods
```ruby
// get Area Codes
order.get_area_codes()

// add note to order
note = {:user_id => "my id", :description => "Test"}
order.add_note(note)

//get Npa Nxxs
order.get_npa_nxx()

// get number totals
order.get_totals()

// get all Tns for an order
order.get_tns()

// get order history
order.get_history()

// get order notes
order.get_notes()
```

## Port Ins
### Create PortIn
```ruby
data = {
  :site_id =>1234,
  :peer_id => 5678,
  :billing_telephone_number => "9195551212",
  :subscriber => {
    :subscriber_type => "BUSINESS",
    :business_name => "Company",
    :service_address => {
      :house_number => "123",
      :street_name => "EZ Street",
      :city => "Raleigh",
      :state_code => "NC",
      :county => "Wake"
    }
  },
  :loa_authorizing_person => "Joe Blow",
  :list_of_phone_numbers => {
    :phone_number => ["9195551212"]
  },
  :billing_type => "PORTIN"
}

portin_response = BandwidthIris::PortIn.create(data)
```
## Get PortIn
```ruby
portIn = BandwidthIris::PortIn.get("portin_id", callback)
```

### PortIn Instance methods
```ruby
portIn.update(data)
portIn.delete()
```
### PortIn File Management
```ruby

# Add File
portIn.create_file(IO.read("myFile.txt"))

# Update File
portIn.update_file("myFile.txt", IO.read("myFile.txt"))

# Get File
portIn.get_file("myFile.txt")

# Get File Metadata
portIn.get_file_metadata("myFile.txt")

# Get Files
portIn.get_files()
```

## Port Out
### List PortOuts
```ruby
query = {:status => "complete"}
list = BandwidthIris::PortOut.list(query)
```
### Get PortOut
```ruby
portout = BandwidthIris::PortOut.get("portout_id")
```

## Rate Centers
### List Ratecenters
```ruby
query = {:available => true, :state => "CA"}
BandwidthIris::RateCenter.list(query)
```

## SIP Peers
### Create SIP Peer
```ruby
data = {
  :peer_name => "A New SIP Peer",
  :is_default_peer => false,
  :short_messaging_protocol =>"SMPP",
  :site_id => selectedSite,
  :voice_hosts =>
    {
      :host => [{
        :host_name => "1.1.1.1"
      }]
    },
  :sms_hosts =>
    {
      :host => [{
        :host_name => "1.1.1.1"
      }]
    },
  :termination_hosts =>
    {
        :termination_host =>[{
        :host_name => "1.1.1.1",
        :port => 5060
      }]
    }

}

BandwidthIris::SipPeer.create(data)
```
### Get SIP Peer
```ruby
sipPeer = BandwidthIris::SipPeer.get("sippeer_id")
```
### List SIP Peers
```ruby
BandwidthIris::SipPeer.list(sipPeer.siteId)
```
### Delete SIP Peer
```ruby
sipPeer.delete()
```
### SipPeer TN Methods
```ruby
# get TN for this peer
sipPeer.get_tns(number)  

# get all TNs for this peer
sipPeer.get_tns()

# Update TNs for this peer
tns = {:full_number => "123456", :rewrite_user => "test"}
sipPeer.update_tns(number, tns)

#  Move Tns to new peer
numbers_to_move = ["9195551212", "9195551213"]
sipPeer.move_tns(numbers_to_move)
```

## Sites

### Create A Site
A site is what is called Location in the web UI.
```ruby
site = {
  :name =>"A new site",
  :description =>"A new description",
  :address => {
    :house_number => "123",
    :street_name => "Anywhere St",
    :city => "Raleigh",
    :state_code =>"NC",
    :zip => "27609",
    :address_type => "Service"
  }
};
site = BandwidthIris::Site.create(site)
```

### Get A Site
```ruby
site = BandwidthIris::Site.get("site_id")
```

### Updating a Site
```ruby
site.update({:name => "New name"})
```
### Deleting a Site
```ruby
site.delete()
```
### Listing All Sites
```ruby
BandwidthIris::Site.list()
```

### Site SipPeer Methods
```ruby
# get Sip Peers
site.get_sip_peers()

# get Sip Peer
site.get_sip_peer("sip_peer_id")

# create Sip Peer
sip_peer = {:name =>"SIP Peer"}
site.create_sip_peer(sipPeer)
```

## Subscriptions
### Create Subscription
```ruby
subscription = {
  :order_type => "orders",
  :callback_subcription => {
    :URL => "http://mycallbackurl.com",
    :user => "userid",
    :expiry => 12000
  }
}
BandwidthIris::Subscription.create(subscription)
```
### Get Subscription
```ruby
BandwidthIris::Subscription.get("subscription_id")
```
### List Subscriptions
```ruby
BandwidthIris::Subscription.list(query)
```
### Subscription Instance Methods
```ruby
# update subscription
updatedData = {:order_type => "portins"}
subscription.update(updatedData)

# delete subscription
subscription.delete()
});
```

## TNs
### Get TN
```ruby
tn = BandwidthIris::Tn.get("9195555555")
```
### List TNs
```ruby
BandwidthIris::Tn.list(query)
```
### TN Instance Methods
```ruby
# Get TN Details
tn = tn.geti_tn_details()

# Get Sites
tn.get_sites()

# Get Sip Peers
tn.get_sip_peers()

# Get Rate Center
tn.get_rate_center()
```

## TN Reservation

### Create TN Reservation
```ruby
BandwidthIris::TnReservation.create({:reserved_tn => "9195551212"})
```

### Get TN Reservation
```ruby
tn = BandwidthIris::TnReservation.get("tn_reservation_id")
```

### Delete TN Reservation
```ruby
tn.delete()
```

## Hosted Messaging

### Create Import TN Order
```ruby
import_tn_order = {
    :customer_order_id => "id",
    :site_id => "12345",
    :sip_peer_id => "23456",
    :subscriber => {
        :service_address => {
            :city => "city",
            :house_number => "1",
            :street_name => "Street",
            :state_code => "XY",
            :zip => "54345",
            :county => "County"
        },
        :name => "Company INC"
    },
    :loa_authorizing_person => "Test Person",
    :telephone_numbers => {
        :telephone_number => ["5554443333"]
    }
}
response = BandwidthIris::ImportTnOrders.create_import_tn_order(import_tn_order)
puts response
```

### Get Import TN Orders
```ruby
response = BandwidthIris::ImportTnOrders.get_import_tn_orders({
    :createdDateFrom => "2013-10-22T00:00:00.000Z",
    :createdDateTo => "2013-10-25T00:00:00.000Z"}
)
puts response
```

### Get Import TN Order By ID
```ruby
response = BandwidthIris::ImportTnOrders.get_import_tn_order("id")
puts response
```

### Get Import TN Order History
```ruby
response = BandwidthIris::ImportTnOrders.get_import_tn_order_history("id")
puts response
```

### Check TNs Portability
```ruby
response = BandwidthIris::ImportTnChecker.check_tns_portability({
    :telephone_numbers => {
        :telephone_number => ["5554443333", "5553334444"]
    }
})
puts response
```

### List InService Numbers (2.0.0 release)
```ruby
response = BandwidthIris::InServiceNumber.list()
puts response[0]
#{:total_count=>2, :links=>{:first=>"Link=<https://dashboard.bandwidth.com:443/v1.0/accounts/99/inserviceNumbers?page=1&size=500>;rel=\"first\";"}, :telephone_numbers=>{:count=>2, :telephone_number=>["5554443333", "5554442222"]}}
```

### Get Remove Imported TN Orders
```ruby
response = BandwidthIris::RemoveImportedTnOrders.get_remove_imported_tn_orders({
    :createdDateFrom => "2013-10-22T00:00:00.000Z",
    :createdDateTo => "2013-10-25T00:00:00.000Z"
})
puts response
```

### Get Remove Imported TN Order
```ruby
response = BandwidthIris::RemoveImportedTnOrders.get_remove_imported_tn_order("order_id")
puts response
```

### Get Remove Imported TN Order History
```ruby
response = BandwidthIris::RemoveImportedTnOrders.get_remove_imported_tn_order_history("order_id")
puts response
```

### Create Remove Imported TN Order
```ruby
remove_imported_tn_order = {
    :customer_order_id => "custom string",
    :telephone_numbers => {
        :telephone_number => ["5554443333", "5554442222"]
    }
}

response = BandwidthIris::RemoveImportedTnOrders.create_remove_imported_tn_order(remove_imported_tn_order)
puts response
```

### Get LOAs
```ruby
response = BandwidthIris::ImportTnOrders.get_loa_files("order_id")
puts response[0][:result_message]
puts response[0][:file_names] #this can be a single string (if there's 1 file) or an array of strings (if there's multiple files)
```

### Upload LOA
Valid `mime_types` can be found on the [Dashboard API Reference](https://dev.bandwidth.com/numbers/apiReference.html) under `/accounts /{accountId} /importTnOrders /{orderid} /loas`

Mime types are expected to be in the format `x/y`, such as `application/pdf` or `text/plain`

```ruby
BandwidthIris::ImportTnOrders.upload_loa_file("order_id", "binary_file_contents", "mime_type")
```

```ruby
f = open("loa.pdf", "rb")
file_content = f.read
f.close()

BandwidthIris::ImportTnOrders.upload_loa_file("order_id", file_content, "application/pdf")
```

### Download LOA
Note: Make sure to grab the desired file ID from the response of `BandwidthIris::ImportTnOrders.get_loa_files("order_id")` in the field `response[0][:file_names]`

```ruby
f = open("write.pdf", "wb")
response = BandwidthIris::ImportTnOrders.download_loa_file("order_id", "file_id")
f.puts(response)
f.close()
```

### Replace LOA
```ruby
BandwidthIris::ImportTnOrders.replace_loa_file("order_id", "file_id", "binary_file_contents", "mime_type")
```

### Delete LOA
```ruby
BandwidthIris::ImportTnOrders.delete_loa_file("order_id", "file_id")
```

### Get LOA Metadata
```ruby
response = BandwidthIris::ImportTnOrders.get_loa_file_metadata("order_id", "file_id")
puts response[0][:document_name]
puts response[0][:file_name]
```

### Update LOA Metadata
```ruby
metadata = {
    :document_name => "file_name",
    :document_type => "LOA"    
}
BandwidthIris::ImportTnOrders.update_loa_file_metadata("order_id", "file_id", metadata)
```

### Delete LOA Metadata
```ruby
BandwidthIris::ImportTnOrders.delete_loa_file_metadata("order_id", "file_id")
```

## CSR

### Create CSR Order

```ruby
csr_data = {
    :customer_order_id => "order id",
    :working_or_billing_telephone_number => "5554443333"
}

response = BandwidthIris::Csr.create(csr_data)
puts response[0][:order_id]
```

### Replace CSR Order

```ruby
csr_data = {
    :customer_order_id => "order id",
    :working_or_billing_telephone_number => "5554443333"
}

response = BandwidthIris::Csr.replace("csr_id", csr_data)
puts response[0][:order_id]
```

### Get CSR Order

```ruby
response = BandwidthIris::Csr.get("csr_id")
puts response[0][:order_id]
```

### Get CSR Order Notes

```ruby
response = BandwidthIris::Csr.get_notes("csr_id")
puts response[0][:note][0][:id]
```

### Add CSR Order Note

```ruby
note_data = {
    :user_id => "id",
    :description => "description"
}

BandwidthIris::Csr.add_note("csr_id", note_data)
```

### Update CSR Order Note

```ruby
note_data = {
    :user_id => "id",
    :description => "description"
}

BandwidthIris::Csr.update_note("csr_id", "note_id", note_data)
```
