class UserStatus < ApplicationRecord
  validates :full_name, :experience, :pending_tasks_count, presence: true
  validates :next_urgent_task, presence: true, allow_blank: true
end
