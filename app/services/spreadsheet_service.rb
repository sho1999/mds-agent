require "google_drive"

class SpreadsheetService
    def self.read_output_spreadsheet
        session = GoogleDrive::Session.from_service_account_key(Rails.root.join('mds-agent-management-bcc43f1a58ee.json').to_s)
        # スプレッドシートをキーで開く
        spreadsheet = session.spreadsheet_by_key("1R5_3hbo0pvgSytMcdSqUlaOKgbX89qRJulItVt0_HFw")
        worksheet = spreadsheet.worksheets[0] # または `worksheet_by_title` などを使う

        max_rows = worksheet.num_rows
        data = []
        (3..max_rows).each do |row|
            row_data = (2..4).map { |col| worksheet[row, col] } # 2=B列, 4=D列
            # 空欄が含まれている場合はループを終了し、dataにnilを設定
            if row_data.include?('')
                data = nil
                break
            else
                data << row_data
            end
        end
        if data
            write_to_spreadsheet(data)
        end
        data
    end

    def self.write_to_spreadsheet(data)
        session = GoogleDrive::Session.from_service_account_key(Rails.root.join('mds-agent-management-bcc43f1a58ee.json').to_s)
        spreadsheet = session.spreadsheet_by_key("1R5_3hbo0pvgSytMcdSqUlaOKgbX89qRJulItVt0_HFw")
        worksheet = spreadsheet.worksheets[0] # 最初のワークシートを選択
      
        # H, I, J列の最終行を検出
        last_row = worksheet.num_rows + 1
      
        # データをH, I, J列に書き込む
        data.each do |row_data|
          worksheet[last_row, 8] = row_data[0] # H列
          worksheet[last_row, 9] = row_data[1] # I列
          worksheet[last_row, 10] = row_data[2] # J列
          last_row += 1
        end

        max_rows = worksheet.num_rows
        b_column_last_row = 2 # B列の開始行番号
        (2..max_rows).each do |row|
            # 空白でない場合、行番号を更新
            b_column_last_row = row unless worksheet[row, 2].nil? || worksheet[row, 2].strip.empty?
        end

        (3..b_column_last_row).each do |row|
            worksheet[row, 2] = '' # B列
            worksheet[row, 3] = '' # C列
            worksheet[row, 4] = '' # D列
        end
      
        worksheet.save
      end
      
  end