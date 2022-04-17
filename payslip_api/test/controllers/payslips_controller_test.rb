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

  test "should get salary computations" do
    get '/monthly_payslip', as: :json
    body = JSON.parse(response.body)

    assert_response :ok
    assert_equal 2, body["salary_computations"].length

    emp1_sal_computation = body["salary_computations"][1]
    assert_equal "2022-04-17T04:00:00.000Z", emp1_sal_computation["time_stamp"]
    assert_equal "Ren", emp1_sal_computation["employee_name"]
    assert_equal "$60000.00", emp1_sal_computation["annual_salary"]
    assert_equal "$500.00", emp1_sal_computation["monthly_income_tax"]

    emp2_sal_computation = body["salary_computations"][0]
    assert_equal "2022-04-17T05:00:00.000Z", emp2_sal_computation["time_stamp"]
    assert_equal "Rash", emp2_sal_computation["employee_name"]
    assert_equal "$80150.00", emp2_sal_computation["annual_salary"]
    assert_equal "$837.08", emp2_sal_computation["monthly_income_tax"]
  end

  test "should generate monthly payslip" do
    assert_difference('Payslip.count') do
      post '/monthly_payslip', params: {
        employee_name: "Ren",
        annual_salary: 60000
      }, as: :json
    end
    body = JSON.parse(response.body)

    assert_response :ok
    assert_equal "Ren", body["employee_name"]
    assert_equal "$5000.00", body["gross_monthly_income"]
    assert_equal "$500.00", body["monthly_income_tax"]
    assert_equal "$4500.00", body["net_monthly_income"]
  end

end
