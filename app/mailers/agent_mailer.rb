class AgentMailer < ApplicationMailer
    default from: 'muramatsu@mds-fund.com'

    def reset_password_instructions(agent, token)
        @agent = agent
        @token = token
        mail(to: @agent.email, subject: 'Reset password instructions')
    end
end
