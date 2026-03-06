class UserStatusesController < ApplicationController
  include HTTParty

  def show
    get_user_data_from_api
    render json: @user_data
  end

  private

  def get_user_data_from_api
    response = HTTParty.get("https://dummyjson.com/users/#{params[:id]}")
    @user_data = JSON.parse(response.body)
  end
end
