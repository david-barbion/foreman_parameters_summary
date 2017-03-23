Rails.application.routes.draw do
  resources :parameters, :controller => :'foreman_parameters_summary/parameters', path: "parameters"
end
