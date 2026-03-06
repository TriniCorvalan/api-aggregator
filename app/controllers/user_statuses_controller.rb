class UserStatusesController < ApplicationController
  include HTTParty

  def show
    get_user_data_from_api
    full_name = @user_data['firstName'] + ' ' + @user_data['lastName']
    experience = @user_data['age'] > 50 ? 'Veteran' : 'Rookie'

    get_todos_from_api
    pending_tasks_count = @todos.count { |todo| todo['completed'] == false }
    next_urgent_task = @todos.find { |todo| todo['completed'] == false }&.dig('todo') || ''

    @user_status = UserStatus.create(full_name: full_name, experience: experience, pending_tasks_count: pending_tasks_count, next_urgent_task: next_urgent_task)
    render json: @user_status.as_json
  end

  private

  def get_user_data_from_api
    response = HTTParty.get("https://dummyjson.com/users/#{params[:id]}")
    @user_data = JSON.parse(response.body)
  end

  def get_todos_from_api
    response = HTTParty.get("https://dummyjson.com/todos/user/#{params[:id]}")
    @todos = JSON.parse(response.body)['todos']
  end
end
