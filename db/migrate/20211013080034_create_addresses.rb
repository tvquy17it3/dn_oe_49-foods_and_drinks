class CreateAddresses < ActiveRecord::Migration[6.1]
  def change
    create_table :addresses do |t|
      t.string :name
      t.string :phone, null: false
      t.string :address, null: false
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
