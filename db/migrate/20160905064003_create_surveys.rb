class CreateSurveys < ActiveRecord::Migration[5.0]
  def change
    create_table :surveys do |t|
      t.json :answer
      t.float :score
      t.belongs_to :university, foreign_key: true

      t.timestamps
    end
  end
end
