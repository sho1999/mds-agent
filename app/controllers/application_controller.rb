class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?

  protected
  
  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:latest_contract_date, :total_contracts, :agent_id,
    :rank, :role, :name, :monthly_dm_target, :monthly_appointment_target, :monthly_contract_target, :first_login])
    devise_parameter_sanitizer.permit(:account_update, keys: [:password, :latest_contract_date, :total_contracts, :agent_id,
    :rank, :role, :name, :monthly_dm_target, :monthly_appointment_target, :monthly_contract_target, :first_login])
  end
end
