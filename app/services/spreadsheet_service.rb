require "google_drive"

class SpreadsheetService
    def self.read_spreadsheet
        session = GoogleDrive::Session.from_service_account_key(Rails.root.join('mds-agent-management-bcc43f1a58ee.json').to_s)
        # スプレッドシートをキーで開く
        spreadsheet = session.spreadsheet_by_key("1R5_3hbo0pvgSytMcdSqUlaOKgbX89qRJulItVt0_HFw")
        worksheet = spreadsheet.worksheets[0] # または `worksheet_by_title` などを使う

        max_rows = worksheet.num_rows
        data = []
        (3..max_rows).each do |row|
            row_data = (2..4).map { |col| worksheet[row, col] } # 2=B列, 5=E列
            data << row_data
        end

        data
    end
  end