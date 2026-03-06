class UserStatusesController < ApplicationController
  def show
    user_data = dummy.user(params[:id])
    full_name = "#{user_data['firstName']} #{user_data['lastName']}"
    experience = user_data['age'] > 50 ? 'Veteran' : 'Rookie'

    todos_response = dummy.todos_by_user(params[:id])
    todos_list = todos_response['todos'] || []
    pending_tasks_count = todos_list.count { |todo| todo['completed'] == false }
    next_urgent_task = todos_list.find { |todo| todo['completed'] == false }&.dig('todo') || ''

    @user_status = UserStatus.new(
      full_name: full_name,
      experience: experience,
      pending_tasks_count: pending_tasks_count,
      next_urgent_task: next_urgent_task
    )

    if @user_status.save
      render json: @user_status.as_json, status: :ok
    else
      render json: { errors: @user_status.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def dummy
    @dummy ||= DummyClient.new
  end
end
