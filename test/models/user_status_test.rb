require "test_helper"

class UserStatusTest < ActiveSupport::TestCase
  test "should create user status" do
    user_status = UserStatus.create(full_name: "John Doe", experience: "Rookie", pending_tasks_count: 0, next_urgent_task: "")
    assert user_status.valid?
  end

  test "should not create user status without full name" do
    user_status = UserStatus.create(experience: "Rookie", pending_tasks_count: 0, next_urgent_task: "")
    assert_not user_status.valid?
  end

  test "should not create user status without experience" do
    user_status = UserStatus.create(full_name: "John Doe", pending_tasks_count: 0, next_urgent_task: "")
    assert_not user_status.valid?
  end

  test "should create user status without pending tasks count 0 as default" do
    user_status = UserStatus.create(full_name: "John Doe", experience: "Rookie", next_urgent_task: "")
    assert user_status.valid?
    assert_equal user_status.pending_tasks_count, 0
  end

  test "should create user status with blank next urgent task" do
    user_status = UserStatus.create(full_name: "John Doe", experience: "Rookie", pending_tasks_count: 0, next_urgent_task: "")
    assert user_status.valid?
  end
end
