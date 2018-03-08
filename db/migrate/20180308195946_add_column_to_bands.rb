class AddColumnToBands < ActiveRecord::Migration[5.1]
  def change
    add_column :bands, :user_id, :integer, null: false
  end
end
