class LendersController < ApplicationController
  before_action :set_lender, only: %i[show edit update destroy]

  def index
    @pagy, @lenders = pagy(Lender.all.order(:name), items: 20)
  end

  def show
    @loans = @lender.loans.includes(:client).order(created_at: :desc)
  end

  def new
    @lender = Lender.new
  end

  def create
    @lender = Lender.new(lender_params)
    if @lender.save
      redirect_to @lender, notice: 'Lender created.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit; end

  def update
    if @lender.update(lender_params)
      redirect_to @lender, notice: 'Lender updated.'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @lender.destroy
    redirect_to lenders_path, notice: 'Lender deleted.'
  end

  private

  def set_lender
    @lender = Lender.find(params[:id])
  end

  def lender_params
    params.require(:lender).permit(
      :name,
      :minimum_loan_amount,
      :maximum_loan_amount,
      :interest_rate,
      :minimum_credit_score
    )
  end
end
