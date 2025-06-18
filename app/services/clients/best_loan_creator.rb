module Clients
  class BestLoanCreator
    def initialize(client:, amount:)
      @client = client
      @amount = amount.to_f
    end

    def call
      return failure("Invalid amount") if @amount <= 0
      return failure("Client must have a credit score") if @client.credit_score.nil?

      best_lender = find_best_lender
      
      return failure("Unable to create loan.") unless best_lender

      create_loan_for_lender(best_lender)
    end

    private

    def find_best_lender
      Lender
        .where("minimum_credit_score IS NULL OR minimum_credit_score <= ?", @client.credit_score)
        .where("(minimum_loan_amount IS NULL OR minimum_loan_amount <= ?) AND (maximum_loan_amount IS NULL OR maximum_loan_amount >= ?)", @amount, @amount)
        .order(:interest_rate)
        .first
    end

    def create_loan_for_lender(lender)
      loan = Loan.new(
        client: @client,
        lender: lender,
        amount: @amount,
        status: :pending
      )

      if loan.save
        success(loan)
      else
        failure(loan.errors.full_messages.to_sentence)
      end
    end

    def success(loan)
      { success: true, value: loan }
    end

    def failure(message)
      { success: false, error: message }
    end
  end
end