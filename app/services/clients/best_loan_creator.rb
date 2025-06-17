module Clients
  class BestLoanCreator
    def initialize(client:, amount:)
      @client = client
      @amount = amount.to_i
    end

    def call
      return failure("Invalid amount") if @amount <= 0

      best_lender = Lender
        .where("minimum_credit_score <= ?", @client.credit_score || 300)
        .where("minimum_loan_amount <= ? AND maximum_loan_amount >= ?", @amount, @amount)
        .order(:interest_rate)
        .first

      if best_lender
        loan = Loan.create(
          client: @client,
          lender: best_lender,
          amount: @amount,
          status: :pending
        )

        loan.persisted? ? success(loan) : failure(loan.errors.full_messages.to_sentence)
      else
        failure("Unable to create loan.")
      end
    end

    private

    def success(loan)
      { success: true, value: loan }
    end

    def failure(message)
      { success: false, error: message }
    end
  end
end