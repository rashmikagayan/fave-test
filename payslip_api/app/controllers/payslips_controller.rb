class PayslipsController < ApplicationController
  before_action :set_payslip, only: [:show, :update, :destroy]

  # GET /payslips
  def index
    @payslips = Payslip.all

    render json: @payslips
  end

  # GET /payslips/1
  def show
    render json: @payslip
  end

  # POST /payslips
  def create
    @payslip = Payslip.new(payslip_params)

    if @payslip.save
      render json: @payslip, status: :created, location: @payslip
    else
      render json: @payslip.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /payslips/1
  def update
    if @payslip.update(payslip_params)
      render json: @payslip
    else
      render json: @payslip.errors, status: :unprocessable_entity
    end
  end

  # DELETE /payslips/1
  def destroy
    @payslip.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_payslip
      @payslip = Payslip.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def payslip_params
      params.fetch(:payslip, {})
    end
end
