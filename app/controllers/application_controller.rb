class ApplicationController < ActionController::Base
    before_action :authenticate_agent!
    # before_action :authenticate

    # private

    # def authenticate
    #     if request.path.starts_with?('/admin')
    #         authenticate_or_request_with_http_basic do |username, password|
    #             username == 'admin_username' &&
    #             password == 'admin_password'
    #         end
    #     end
    # end
    before_action :basic_auth

    private
    
    def basic_auth
      authenticate_or_request_with_http_basic do |username, password|
        username == 'basic' && password == '123456'
      end
    end
end
