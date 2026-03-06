class CreateUserStatuses < ActiveRecord::Migration[7.2]
  def change
    create_table :user_statuses do |t|
      t.string :full_name, null: false
      t.string :experience, null: false
      t.integer :pending_tasks_count, null: false, default: 0
      t.string :next_urgent_task, null: false, default: ''
      t.timestamps null: false
    end
    add_index :user_statuses, :id, unique: true
  end
end
