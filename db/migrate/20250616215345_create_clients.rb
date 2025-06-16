class CreateClients < ActiveRecord::Migration[7.1]
  def change
    create_table :clients do |t|
      t.string :email, null: false
      t.string :name, null: false
      t.string :phone
      t.integer :credit_score
      t.timestamps
    end
    
    add_index :clients, :email, unique: true
    add_index :clients, :credit_score
  end
end
