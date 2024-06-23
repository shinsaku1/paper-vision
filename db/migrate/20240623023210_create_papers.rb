class CreatePapers < ActiveRecord::Migration[7.1]
  def change
    create_table :papers do |t|
      t.string :type

      t.string :state

      t.jsonb :attrs

      t.timestamps

      t.index :type
      t.index :state
      t.index :attrs, using: :gin
    end
  end
end
