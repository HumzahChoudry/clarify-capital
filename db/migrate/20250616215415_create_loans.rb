class CreateLoans < ActiveRecord::Migration[7.1]
  def change
    create_table :loans do |t|
      t.references :client, null: false, foreign_key: true
      t.references :lender, null: false, foreign_key: true
      t.decimal :amount, precision: 10, scale: 2, null: false
      t.integer :status, default: 0
      t.timestamps
    end
    
    add_index :loans, :status
    add_index :loans, [:client_id, :status]
  end
end
