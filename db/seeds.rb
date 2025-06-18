require 'faker'

Rails.logger.debug "Seeding..."

Loan.destroy_all
Client.destroy_all
Lender.destroy_all

# Create Clients
clients = 30.times.map do
  Client.create!(
    name: Faker::Name.name,
    email: Faker::Internet.unique.email,
    phone: Faker::PhoneNumber.phone_number,
    credit_score: rand(300..850)
  )
end

# Create Lenders
lenders = 10.times.map do
  min_amount = rand(1_000..5_000)
  max_amount = min_amount + rand(5_000..20_000)
  Lender.create!(
    name: Faker::Company.name,
    interest_rate: rand(3.0..12.0).round(2),
    minimum_loan_amount: min_amount,
    maximum_loan_amount: max_amount,
    minimum_credit_score: rand(300..650)
  )
end

# Create Loans
20.times do
  client = clients.sample
  lender = lenders.select { |l| client.credit_score && client.credit_score >= l.minimum_credit_score }.sample

  next unless lender

  amount = rand(lender.minimum_loan_amount..lender.maximum_loan_amount).round(2)
  Loan.create!(
    client: client,
    lender: lender,
    amount: amount,
    status: Loan.statuses.keys.sample
  )
end

Rails.logger.debug { "Seeded #{Client.count} clients, #{Lender.count} lenders, and #{Loan.count} loans." }
