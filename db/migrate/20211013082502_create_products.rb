class CreateProducts < ActiveRecord::Migration[6.1]
  def change
    create_table :products do |t|
      t.string :name, null: false
      t.decimal :price, null: false
      t.text :description
      t.integer :quantity, null: false
      t.boolean :status, null: false, default: 0
      t.references :category, null: false, foreign_key: true

      t.timestamps
    end
    add_index :products, :price
    add_index :products, :name
  end
end
