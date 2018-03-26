class CreateShops < ActiveRecord::Migration[5.1]
  def change
    create_table :categories do |t|
      t.string :name
      t.timestamps
    end

    create_table :shops do |t|
      t.string :name
      t.references :category, foreign_key: true
      t.timestamps
    end
  end
end
