class AddFileToUniversity < ActiveRecord::Migration[5.0]
  def change
    add_column :universities, :file, :string
  end
end
