require "test_helper"

class ClientsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @client = Client.create!(name: "Test Client", email: "test@example.com", credit_score: 700)
    @lender = Lender.create!(
      name: "Test Lender",
      minimum_credit_score: 650,
      minimum_loan_amount: 1000,
      maximum_loan_amount: 10000,
      interest_rate: 5.0
    )
  end

  test "should get index" do
    get clients_url
    assert_response :success
  end

  test "should get new" do
    get new_client_url
    assert_response :success
  end

  test "should show client" do
    get client_url(@client)
    assert_response :success
  end

  test "should get edit" do
    get edit_client_url(@client)
    assert_response :success
  end

  test "should create best loan with eligible lender" do
    post create_best_loan_client_url(@client), params: { amount: 5000 }

    loan = Loan.last
    assert_equal @client, loan.client
    assert_equal @lender, loan.lender
    assert_equal 5000, loan.amount
    assert_redirected_to client_path(@client)
    assert_equal "Best loan created!", flash[:notice]
  end

  test "should redirect with alert if no eligible lenders" do
    @lender.update!(minimum_credit_score: 800) # client no longer eligible

    post create_best_loan_client_url(@client), params: { amount: 5000 }

    assert_redirected_to client_path(@client)
    assert_match(/Unable to create loan/, flash[:alert])
  end
end
