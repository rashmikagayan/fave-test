class PayslipsController < ApplicationController
  before_action :set_payslip, only: %i[ show update destroy ]

  # GET /payslips
  def index
    payslip_data = { "salary_computations" => Payslip.all.as_json(:except => :id) }
    render json:  payslip_data.to_json
  end

  # POST /payslip/generate
  def generate_monthly_payslip
    @tb = [
      [0,20000,0],
      [20000,40000,10],
      [40000,80000,20],
      [80000,180000,30],
      [180000,-1,40]
    ]
    emp_name = request['employee_name']
    annual_salary = request['annual_salary'].to_f
    # Input validation
    if !is_name_valid? emp_name
      render json: { "Error": "Entered name is not a valid!" }, status: :bad_request and return
    end
    if annual_salary.negative?
      render json: { "Error": "Salary value should be a positive value!" }, status: :bad_request and return
    end
    
    gross_monthly_income = annual_salary / 12
    monthly_income_tax = calc_income_tax(annual_salary) / 12
    net_monthly_income = gross_monthly_income - monthly_income_tax

    create(DateTime.current, emp_name, "$#{sprintf('%.2f', annual_salary)}", "$#{sprintf('%.2f', monthly_income_tax)}")    

    render json: {
      "employee_name": emp_name,
      "gross_monthly_income": "$#{sprintf('%.2f', gross_monthly_income)}",
      "monthly_income_tax": "$#{sprintf('%.2f', monthly_income_tax)}",
      "net_monthly_income": "$#{sprintf('%.2f', net_monthly_income)}"
    }
  end
  # Checks if name contains only letters and spaces
  def is_name_valid?(str)
    str.count("a-zA-Z ") == str.size && str.length > 0
  end

  def calc_income_tax (annual_salary)
    total_taxes = 0
    # Iterate in each tax bracket and calculate each level tax
    for level in @tb do
      # Check for the upper limit
      if(annual_salary < level[1] || level[1]==-1)
        total_taxes += (annual_salary - level[0]) * level[2] / 100
        break
      else
        total_taxes += (level[1] - level[0]) * level[2] / 100
      end
    end      
    return total_taxes
  end

  #Insert into database 
  def create(timestamp, emp_name, annual_salary, monthly_income_tax)
    payslip = Payslip.create(time_stamp: timestamp, employee_name: emp_name, annual_salary: annual_salary, monthly_income_tax: monthly_income_tax)
  end

  private
    # Only allow a trusted parameter "white list" through.
    def payslip_params
      params.require(:payslip).permit(:generator)
    end
end
