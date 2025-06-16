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
end
