class ClientsController < ApplicationController
  before_action :set_client, only: %i[show edit update destroy]
  def index
    @clients = Client.all.order(:name)
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

  private
  def set_client
    @client = Client.find(params[:id])
  end

  def client_params
    params.require(:client).permit(:email, :name, :phone, :credit_score)
  end
end
