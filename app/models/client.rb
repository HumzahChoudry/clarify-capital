class Client < ApplicationRecord
  has_many :loans, dependent: :destroy
  has_many :lenders, through: :loans

  validates :email, presence: true, uniqueness: true
  validates :name, presence: true

  # FICO range of 300 to 850; allow nil for client without application
  validates :credit_score, numericality: {
    only_integer: true,
    greater_than_or_equal_to: 300,
    less_than_or_equal_to: 850
  }, allow_nil: true
end
