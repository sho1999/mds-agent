class Agents::RegistrationsController < Devise::RegistrationsController
  protected

  # 新規登録後のリダイレクト先をカスタマイズ
  def after_sign_up_path_for(resource)
    resource.update(first_login: false)
    onboarding_agent_path(resource) # オンボーディングページへリダイレクト
  end

  def update_resource(resource, params)
    resource.update_without_password(params.except("current_password", "password", "password_confirmation"))
  end
end
