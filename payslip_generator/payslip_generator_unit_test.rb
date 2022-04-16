require_relative "payslip_generator"
require 'minitest/autorun'

class PaySlipGeneratorTest < Minitest::Test
    def setup
        @payslipgen = PayslipGenerator.new
    end

    def test_generate_monthly_payslip
        assert_output("Monthly Payslip for: \"Ren\"\nGross Monthly Income: $5000.00\nMonthly Income Tax: $500.00\nNet Monthly Income: $4500.00\n") \
        { @payslipgen.generate_monthly_payslip "Ren", 60000}
    end

    def test_tax_bracket_level_1
        assert_equal(0, @payslipgen.calc_income_tax(15000))
    end

    def test_tax_bracket_level_2
        assert_equal(1000, @payslipgen.calc_income_tax(30000))
    end

    def test_tax_bracket_level_3
        assert_equal(6000, @payslipgen.calc_income_tax(60000))
    end

    def test_tax_bracket_level_4
        assert_equal(10045, @payslipgen.calc_income_tax(80150))
    end

    def test_tax_bracket_level_5
        assert_equal(48000, @payslipgen.calc_income_tax(200000))
    end
end