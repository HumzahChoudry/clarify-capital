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

    if amount < lender.minimum_loan_amount
      errors.add(:amount, "must be at least #{lender.minimum_loan_amount}")
    elsif amount > lender.maximum_loan_amount
      errors.add(:amount, "must be less than or equal to #{lender.maximum_loan_amount}")
    end
  end

  def client_meets_credit_score
    return if client.nil? || lender.nil? || client.credit_score.nil?

    if client.credit_score < lender.minimum_credit_score
      errors.add(:client, "does not meet the lender’s minimum credit score of #{lender.minimum_credit_score}")
    end
  end
end
