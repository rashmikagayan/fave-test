Rails.application.routes.draw do
  resources :payslips
  post '/monthly_payslip', to:'payslips#generate_monthly_payslip'
end
