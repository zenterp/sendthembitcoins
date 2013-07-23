module Oauth
  class Linkedin
    def self.user_from_omniauth(omniauth_hash)
      return {
        uid: omniauth_hash['uid'],
        username: omniauth_hash['info']['nickname'],
        image: omniauth_hash['info']['image']
      }   
    end 
  end
end 