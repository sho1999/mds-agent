class AutomationController < ApplicationController
    def index
    end

    def add_project_500
        # スプレッドシートからデータを読み込む
        data = SpreadsheetService.read_output_spreadsheet

        if data
            WebsiteAutomator.add_project_500(data)
        else
            redirect_to root_path, alert: 'スプシのどこかに空白があります'
            return
        end
        redirect_to root_path, notice: 'Automation completed successfully.'
    end

    def change_interview_date
        link = params[:link] # フォームから受け取ったリンク
        date = params[:date]
        
        if link #が有効だったら
            ChangeInterviewDate.main(link, date)
        else
            redirect_to root_path, alert: 'Nothing link'
            return
        end
        redirect_to root_path, notice: 'Automation completed successfully.'
    end
end
