class CreateWideAreas < ActiveRecord::Migration[5.1]
  def change
    create_table :wide_areas do |t|
      t.string :name

      t.timestamps
    end
  end
end
