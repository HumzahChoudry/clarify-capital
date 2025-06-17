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

  before_save :format_phone_number

  private 

  def format_phone_number
    return if phone.blank?

    # Remove all non-digit characters
    digits = phone.gsub(/\D/, "") 

    # Strip leading country code if it's '1' and total is 11 digits
    digits = digits[1..] if digits.length == 11 && digits.starts_with?("1")

    # Only format if exactly 10 digits
    self.phone =
      if digits.length == 10
        "#{digits[0..2]}-#{digits[3..5]}-#{digits[6..9]}"
      else
        # fallback to raw input if format unknown
        phone 
      end
  end

end
