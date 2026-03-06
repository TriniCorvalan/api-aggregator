class UserStatus < ApplicationRecord
  validates :full_name, :experience, :pending_tasks_count, :next_urgent_task, presence: true
end
