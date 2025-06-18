class Loan < ApplicationRecord
  belongs_to :client
  belongs_to :lender

  enum :status, {
    pending: 0,
    approved: 1,
    rejected: 2,
    funded: 3,
    canceled: 4
  }

  validates :amount, numericality: { greater_than: 0 }
  validate :amount_within_lender_limits
  validate :client_meets_credit_score

  private

  def amount_within_lender_limits
    return if lender.nil? || amount.nil?

    # Check minimum loan amount if present
    if lender.minimum_loan_amount && amount < lender.minimum_loan_amount
      errors.add(:amount, "must be at least #{lender.minimum_loan_amount}")
    end
    
    # Check maximum loan amount if present
    if lender.maximum_loan_amount && amount > lender.maximum_loan_amount
      errors.add(:amount, "must be less than or equal to #{lender.maximum_loan_amount}")
    end
  end

  def client_meets_credit_score
    return if client.nil? || lender.nil?
    
    if client.credit_score.nil?
      errors.add(:client, "must have a credit score to qualify for a loan")
    elsif lender.minimum_credit_score && client.credit_score < lender.minimum_credit_score
      errors.add(:client, "does not meet the lender's minimum credit score of #{lender.minimum_credit_score}")
    end
  end
end