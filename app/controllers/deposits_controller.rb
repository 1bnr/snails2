class DepositsController < ApplicationController
  before_action :set_deposit, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!
  before_filter :check_for_cancel, :only => [:create, :update]

    def check_for_cancel
      if params[:cancel]
        redirect_to deposits_url
      end
    end

  # GET /deposits
  # GET /deposits.json
  def index
  	puts(current_user.account.inspect)
    @deposits = current_user.account.deposits
    @total_deposits = current_user.account.formatted_total_deposits
  end

  # GET /deposits/1
  # GET /deposits/1.json
  def show
  end

  # GET /deposits/new
  def new
    @deposit = Deposit.new
  end

  # GET /deposits/1/edit
  def edit
  end

  # POST /deposits
  # POST /deposits.json
  def create
    account = {account_id: current_user.account.id}
    @deposit = Deposit.new(deposit_params.merge(account))

    respond_to do |format|
      if @deposit.save
        format.html { redirect_to deposits_path, notice: 'Deposit was successfully created.' }
        format.json { render :show, status: :created, location: deposits_path }
      else
        format.html { render :new }
        format.json { render json: @deposit.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /deposits/1
  # PATCH/PUT /deposits/1.json
  def update
    params.inspect
    respond_to do |format|
      if @deposit.update(deposit_params)
        format.html { redirect_to deposits_path, notice: 'Deposit was successfully updated.' }
        format.json { render :show, status: :ok, location: deposits_path }
      else
        format.html { render :edit }
        format.json { render json: @deposit.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /deposits/1
  # DELETE /deposits/1.json
  def destroy
    @deposit.destroy
    respond_to do |format|
      format.html { redirect_to deposits_url, notice: 'Deposit was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_deposit
      @deposit = Deposit.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def deposit_params
      params.require(:deposit).permit(:amount)
    end
end
