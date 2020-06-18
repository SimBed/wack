class CreateAttempts < ActiveRecord::Migration[5.2]
  def change
    create_table :attempts do |t|
      t.datetime :DoA
      t.text :summary
      t.references :user, foreign_key: true
      t.references :workout, foreign_key: true

      t.timestamps
    end
    add_index :attempts, [:user_id, :created_at]
    add_index :attempts, [:workout_id, :created_at]
  end
end
