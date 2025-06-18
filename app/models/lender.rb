class Lender < ApplicationRecord
  has_many :loans, dependent: :destroy
  has_many :clients, through: :loans

  validates :name, presence: true

  # Allow nil for lender in onboarding
  validates :interest_rate, numericality: {
    greater_than_or_equal_to: 0,
    less_than_or_equal_to: 100
  }, allow_nil: true

  validates :minimum_loan_amount, :maximum_loan_amount, numericality: {
    greater_than: 0
  }, allow_nil: true

  # FICO range of 300 to 850; allow nil for lender in onboarding
  validates :minimum_credit_score, numericality: {
    only_integer: true,
    greater_than_or_equal_to: 300,
    less_than_or_equal_to: 850
  }, allow_nil: true

  # Custom validation to ensure max >= min when both present
  validate :maximum_loan_amount_greater_than_minimum

  private

  def maximum_loan_amount_greater_than_minimum
    return if minimum_loan_amount.nil? || maximum_loan_amount.nil?
    
    if maximum_loan_amount < minimum_loan_amount
      errors.add(:maximum_loan_amount, "must be greater than minimum loan amount")
    end
  end
end