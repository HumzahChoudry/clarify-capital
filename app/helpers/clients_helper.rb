module ClientsHelper
  def display_or_na(value)
    value.present? ? value : "N/A"
  end
end
