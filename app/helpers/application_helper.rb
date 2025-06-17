module ApplicationHelper
  include Pagy::Frontend
  def display_or_na(value)
    value.present? ? value : "N/A"
  end

  def display_currency_or_na(amount)
    amount.present? ? number_to_currency(amount) : "N/A"
  end

  def display_percentage_or_na(value)
    value.present? ? "#{number_with_precision(value, precision: 2)}%" : "N/A"
  end
end
