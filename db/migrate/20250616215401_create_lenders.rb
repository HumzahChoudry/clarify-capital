class CreateLenders < ActiveRecord::Migration[7.1]
  def change
    create_table :lenders do |t|
      t.string :name, null: false
      t.decimal :minimum_loan_amount, precision: 10, scale: 2
      t.decimal :maximum_loan_amount, precision: 10, scale: 2
      t.decimal :interest_rate, precision: 5, scale: 2
      t.integer :minimum_credit_score, default: 300
      t.timestamps
    end
    
    add_index :lenders, :minimum_credit_score
    add_index :lenders, :interest_rate
  end
end
