class AutomationController < ApplicationController
    def index
    end

    def add_project_500
        # スプレッドシートからデータを読み込む
        data = SpreadsheetService.read_output_spreadsheet
        # ウェブ自動操作を実行
        if data
            WebsiteAutomator.perform_operations(data)
        else
            redirect_to root_path, alert: 'スプシのどこかに空白があります'
            return
        end
        redirect_to root_path, notice: 'Automation completed successfully.'
    end
end
