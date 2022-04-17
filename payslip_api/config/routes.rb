Rails.application.routes.draw do
  get '/payslips/view', to:'payslips#index'
  post '/payslip/generate', to:'payslips#generate_monthly_payslip'

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
