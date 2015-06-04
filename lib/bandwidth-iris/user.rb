module BandwidthIris
  USER_PATH = 'users'

  class User
    extend ClientWrapper
    include ApiItem

    def self.list(client)
      list = client.make_request(:get, USER_PATH)[0][:users][:user]
      list = if list.is_a?(Array) then list else [list] end
      list.map do |i|
        User.new(i, client)
      end
    end
    wrap_client_arg :list


  end
end
