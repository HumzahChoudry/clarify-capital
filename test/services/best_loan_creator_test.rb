require "test_helper"

class BestLoanCreatorTest < ActiveSupport::TestCase
  def setup
    @client = Client.create!(
      name: "Test Client",
      email: "test@example.com",
      credit_score: 700
    )

    @lender1 = Lender.create!(
      name: "Lender One",
      minimum_credit_score: 650,
      minimum_loan_amount: 5000,
      maximum_loan_amount: 10000,
      interest_rate: 5.0
    )

    @lender2 = Lender.create!(
      name: "Lender Two",
      minimum_credit_score: 680,
      minimum_loan_amount: 3000,
      maximum_loan_amount: 7000,
      interest_rate: 4.5
    )

    @lender3 = Lender.create!(
      name: "Lender Three",
      minimum_credit_score: 720,
      minimum_loan_amount: 4000,
      maximum_loan_amount: 12000,
      interest_rate: 6.0
    )
  end

  test "creates loan with best eligible lender (lowest interest rate)" do
    service = Clients::BestLoanCreator.new(client: @client, amount: 6000)
    result = service.call

    assert result[:success], "Expected success to be true"
    loan = result[:value]
    assert loan.persisted?, "Loan should be persisted"
    assert_equal @client.id, loan.client_id
    assert_equal @lender2.id, loan.lender_id
    assert_equal 6000, loan.amount
    assert_equal "pending", loan.status
  end

  test "returns error when no lenders meet client credit score" do
    @lender1.update!(minimum_credit_score: 800)
    @lender2.update!(minimum_credit_score: 800)
    @lender3.update!(minimum_credit_score: 800)

    service = Clients::BestLoanCreator.new(client: @client, amount: 6000)
    result = service.call

    refute result[:success], "Expected success to be false"
    assert_equal "Unable to create loan.", result[:error]
  end

  test "returns error when amount is out of lender range" do
    service = Clients::BestLoanCreator.new(client: @client, amount: 15000) # > all max amounts
    result = service.call

    refute result[:success], "Expected success to be false"
    assert_equal "Unable to create loan.", result[:error]
  end

  test "returns error when amount is invalid (<= 0)" do
    service = Clients::BestLoanCreator.new(client: @client, amount: 0)
    result = service.call

    refute result[:success], "Expected success to be false"
    assert_equal "Invalid amount", result[:error]
  end
end
