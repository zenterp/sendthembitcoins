module Facebook
  class FriendFinder
    def initialize(oauth_access_token)
      @graph = Koala::Facebook::API.new(oauth_access_token)
    end 

    def search(name)
      name.downcase!
      friends.reject do |friend|
        friend['name'].scan(name).empty?
      end
    end

    def friends
      @friends ||= begin
        @graph.get_connections('me', 'friends').map do |friend|
           friend['name'] = friend['name'].downcase
           friend
        end
      end
    end
  end
end
