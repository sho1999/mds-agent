require 'rails_admin/config/actions'
require 'rails_admin/config/actions/base'

module RailsAdmin
  module Config
    module Actions
      class ResetPassword < RailsAdmin::Config::Actions::Base
        RailsAdmin::Config::Actions.register(self)

        register_instance_option :member do
          true
        end

        register_instance_option :http_methods do
          [:get]
        end

        register_instance_option :controller do
          Proc.new do
            # ここでパスワードリセットトークンを生成します
            token = @object.set_reset_password_token
            # 生成したトークンを利用してリセットURLを構築
            @reset_password_url = edit_password_url(@object, reset_password_token: token)

            render action: :show
          end
        end

        register_instance_option :link_icon do
          'icon-lock'
        end
      end
    end
  end
end
