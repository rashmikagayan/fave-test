require 'test_helper'

class PayslipsControllerTest < ActionDispatch::IntegrationTest
  test "should fail when provided empty or invalid employee name" do
    post '/monthly_payslip', params: {
      employee_name: "",
      annual_salary: 60000
    }, as: :json

    assert_response :bad_request
  end

  test "should fail when provided non numarical positive value" do
    post '/monthly_payslip', params: {
      employee_name: "Ren",
      annual_salary: -1
    }, as: :json

    assert_response :bad_request
  end  

  test "should generate monthly payslip" do
    post '/monthly_payslip', params: {
      employee_name: "Ren",
      annual_salary: 60000
    }, as: :json
    body = JSON.parse(response.body)

    assert_response :ok
    assert_equal "Ren", body["employee_name"]
    assert_equal "$5000.00", body["gross_monthly_income"]
    assert_equal "$500.00", body["monthly_income_tax"]
    assert_equal "$4500.00", body["net_monthly_income"]
  end

end
