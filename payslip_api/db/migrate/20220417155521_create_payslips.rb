class CreatePayslips < ActiveRecord::Migration[7.0]
  def change
    create_table :payslips do |t|
      t.datetime :time_stamp
      t.string :employee_name
      t.string :annual_salary
      t.string :monthly_income_tax
    end
  end
end
