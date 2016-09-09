class CreateUniversities < ActiveRecord::Migration[5.0]
  def change
    create_table :universities do |t|
      t.string :name, null: false
      t.string :code, null: false, unique: true
      t.string :logo
      t.json :data, default: {}
      t.json :right_answer, default: {}

      t.timestamps
    end
  end
end
