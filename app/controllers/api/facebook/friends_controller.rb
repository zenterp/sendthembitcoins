class Api::Facebook::FriendsController < ApplicationController
  # GET /api/facebook/friends/search
  def search
    query = params.require(:query)
    access_token = params.require(:access_token)
    friend_finder = Facebook::FriendFinder.new(access_token)
    render json: friend_finder.search(query)
  end
end
