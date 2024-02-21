class AutomationController < ApplicationController
    def index
    end

    def add_project_500
        # スプレッドシートからデータを読み込む
        data = SpreadsheetService.read_spreadsheet
        # ウェブ自動操作を実行
        WebsiteAutomator.perform_operations(data)
        redirect_to root_path, notice: 'Automation completed successfully.'
    end
end
