class AutomationController < ApplicationController
    def index
    end

    def add_project_500
        # スプレッドシートからデータを読み込む
        data = SpreadsheetService.read_output_spreadsheet

        if data
            WebsiteAutomator.add_project_500(data)
        else
            redirect_to automation_index_path, alert: 'スプシのどこかに空白があります'
            return
        end
        redirect_to automation_index_path, notice: '🥳イェーイ！完了！'
    end

    def change_interview_date
        link = params[:link] # フォームから受け取ったリンク
        date = params[:date]
        
        if link #が有効だったら
            ChangeInterviewDate.main(link, date)
        else
            redirect_to automation_index_path, alert: 'Nothing link'
            return
        end
        redirect_to automation_index_path, notice: '🥳イェーイ！完了！'
    end


    def check_uru_task
        begin
          UruTaskCheck.check
          redirect_to automation_index_path, notice: '🥳イェーイ！完了！'
        rescue => e
          # Handle the error here
          logger.error "Error during UruTaskCheck: #{e.message}"
          redirect_to automation_index_path, alert: 'エラーが出ました。処理を止めます。'
        end
    end
      

end
