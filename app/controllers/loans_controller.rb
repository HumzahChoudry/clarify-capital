class LoansController < ApplicationController
  before_action :set_loan, only: %i[edit update]
  before_action :set_parent_entities, only: %i[new create edit update]
  before_action :filter_loan_candidates, only: %i[new edit]

  def index 
    @status = params[:status]
    loans = @status.present? ? Loan.where(status: @status) : Loan.all
    @loans_count = loans.count
    @pagy, @loans = pagy(loans.includes(:client, :lender).order(created_at: :desc), items: 20)
  end

  def new
    @loan ||= Loan.new
    @loan.client_id ||= @client&.id
    @loan.lender_id ||= @lender&.id
  end

  def create
    @loan = Loan.new(loan_params)
    if @loan.save
      redirect_to client_path(@loan.client_id), notice: 'Loan created.'
    else
      filter_loan_candidates
      render :new, status: :unprocessable_entity
    end
  end

  def edit; end

  def update
    if @loan.pending?
      if @loan.update(loan_params)
        redirect_to client_path(@loan.client_id), notice: 'Loan updated.'
      else
        filter_loan_candidates
        render :edit, status: :unprocessable_entity
      end
    else
      # Only allow status updates for non-pending loans
      if @loan.update(loan_params.slice(:status))
        redirect_to client_path(@loan.client_id), notice: 'Loan status updated.'
      else
        render :edit, status: :unprocessable_entity
      end
    end
  end

  private

  def set_loan
    @loan = Loan.find(params[:id])
  end

  def set_parent_entities
    @client = Client.find(params[:client_id]) if params[:client_id].present?
    @lender = Lender.find(params[:lender_id]) if params[:lender_id].present?
  end

  def filter_loan_candidates
    if @client
      # Handle clients without credit scores
      credit = @client.credit_score || 0
      @eligible_lenders = Lender.where(
        "minimum_credit_score IS NULL OR minimum_credit_score <= ?", 
        credit
      )
    elsif @lender
      # Handle lenders without minimum credit score requirements
      if @lender.minimum_credit_score
        @eligible_clients = Client.where(
          "credit_score IS NOT NULL AND credit_score >= ?", 
          @lender.minimum_credit_score
        )
      else
        @eligible_clients = Client.all
      end
    else
      @eligible_clients = Client.all
      @eligible_lenders = Lender.all
    end
  end

  def loan_params
    params.require(:loan).permit(:client_id, :lender_id, :amount, :status)
  end
end