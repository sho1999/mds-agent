class Agents::SessionsController < Devise::SessionsController
 
  def create
    self.resource = warden.authenticate!(auth_options)
    if resource.first_login?
      resource.update(first_login: false)
      sign_in(resource_name, resource)
      redirect_to onboarding_agent_path(self.resource) 
    else
      super 
    end
  end
end
