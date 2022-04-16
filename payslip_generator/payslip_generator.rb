class PayslipGenerator
    
    def initialize      
      @tb = [
        [0,20000,0],
        [20000,40000,10],
        [40000,80000,20],
        [80000,180000,30],
        [180000,-1,40]
      ]
    end

    def generate_monthly_payslip (emp_name, annual_salary)
        # Input validation
        if !is_name_valid? emp_name
          puts "Entered name is not a valid!"
          exit
        end
        if annual_salary.negative?
          puts "Salary value should be a positive value!"
          exit
        end

        gross_monthly_income = annual_salary / 12
        monthly_income_tax = calc_income_tax(annual_salary) / 12
        net_monthly_income = gross_monthly_income - monthly_income_tax
    
        puts "Monthly Payslip for: \"#{emp_name}\""
        puts "Gross Monthly Income: $#{sprintf('%.2f', gross_monthly_income)}"
        puts "Monthly Income Tax: $#{sprintf('%.2f', monthly_income_tax)}"
        puts "Net Monthly Income: $#{sprintf('%.2f', net_monthly_income)}"
    end


    # Checks if name contains only letters and spaces
    def is_name_valid?(str)
      str.count("a-zA-Z ") == str.size
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
end
