class CreateOrders < ActiveRecord::Migration[6.1]
  def change
    create_table :orders do |t|
      t.string :name
      t.decimal :total_price
      t.string :phone, null: false
      t.string :address, null: false
      t.string :note
      t.integer :status, null: false, default: 0
      t.references :user, null: false, foreign_key: true
      t.references :address, null: false, foreign_key: true

      t.timestamps
    end
  end
end
