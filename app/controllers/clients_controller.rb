class ClientsController < ApplicationController
  before_action :set_client, only: %i[show edit update destroy create_best_loan]

  def index
    clients = Client.order(:name)
    
    if params[:search].present?
      search_term = "%#{params[:search].strip}%"
      clients = clients.where(
        "LOWER(name) LIKE LOWER(?) OR LOWER(email) LIKE LOWER(?)",
        search_term, 
        search_term
      )
    end
    
    @clients_count = clients.count
    @pagy, @clients = pagy(clients, items: 20)
  end

  def show
    @loans = @client.loans.includes(:lender).order(created_at: :desc)
  end

  def new
    @client = Client.new
  end

  def create 
    @client = Client.new(client_params)
    if @client.save
      redirect_to @client, notice: 'Client created.'
    else 
      render :new, status: :unprocessable_entity
    end
  end

  def edit; end

  def update 
    if @client.update(client_params)
      redirect_to @client, notice: 'Client updated.'
    else 
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @client.destroy
    redirect_to clients_path, notice: 'Client deleted.'
  end

  # POST /clients/:id/create_best_loan
  def create_best_loan
    # Validate amount parameter
    return redirect_to @client, alert: "Amount is required" if params[:amount].blank?
    
    amount = params[:amount].to_f
    return redirect_to @client, alert: "Amount must be greater than 0" if amount <= 0
    
    result = Clients::BestLoanCreator.new(client: @client, amount: amount).call

    return redirect_to @client, notice: "Best loan created!" if result[:success]

    redirect_to @client, alert: result[:error] || "Unable to create loan."
  end

  private

  def set_client
    @client = Client.find(params[:id])
  end

  def client_params
    params.require(:client).permit(:credit_score, :email, :name, :phone)
  end
end