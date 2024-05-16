require "google_drive"

class SpreadsheetService
    def self.read_output_spreadsheet
        session = GoogleDrive::Session.from_service_account_key(Rails.root.join('mds-agent-management-bcc43f1a58ee.json').to_s)
        # スプレッドシートをキーで開く
        spreadsheet = session.spreadsheet_by_key("1R5_3hbo0pvgSytMcdSqUlaOKgbX89qRJulItVt0_HFw")
        worksheet = spreadsheet.worksheets[0] # または `worksheet_by_title` などを使う

        max_rows = 3
        (3..worksheet.num_rows).each do |row|
            value = worksheet[row, 2] # 2はB列
            break if value.nil? || value.strip.empty? # 空白セルが見つかったらループを抜ける
            max_rows += 1
        end
        
        data = []
        (3..max_rows).each do |row|
            row_data = (2..4).map { |col| worksheet[row, col] } # 2=B列, 4=D列
            if row_data.include?('')
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


    def self.get_my_appointments(agent_id)
        session = GoogleDrive::Session.from_service_account_key(Rails.root.join('mds-agent-management-bcc43f1a58ee.json').to_s)
        worksheet = session.spreadsheet_by_key("11Ps1iEYe9E9v_CIyWjZiF05-V9j_wvPV4fUuU12Kp2Q").worksheets[0]
    
        my_appointment_data = []
        (2..worksheet.num_rows).each do |row|
          if worksheet[row, 4].to_i == agent_id
            # 代理店 ID が一致した行から必要な列のデータのみを取得
            row_data = [
              worksheet[row, 1],  # 日時
              worksheet[row, 2],  # ステータス
              worksheet[row, 3],  # 名前
              worksheet[row, 5]  # インスタ
            ]
            my_appointment_data << row_data
          end
        end
        my_appointment_data
    end

    def update_all_sheets
        # Google Drive セッションを開始
        session = GoogleDrive::Session.from_service_account_key(Rails.root.join('mds-agent-management-bcc43f1a58ee.json'))
    
        # スプレッドシートを開く
        sakamaki = session.spreadsheet_by_url("https://docs.google.com/spreadsheets/d/1Ia3Um-uNeMRz-oDV_YhNawHjntMogXf2TXIvTX4HTr0/edit?usp=sharing").worksheets[0]
        sugi = session.spreadsheet_by_url("https://docs.google.com/spreadsheets/d/1Pig9JGn8UlnojFZKB41d4-wumu4Z2fPu6uLd_fJmMuQ/edit?usp=sharing").worksheets[0]
        shimotori = session.spreadsheet_by_url("https://docs.google.com/spreadsheets/d/1YVMsJdbqx0bXlfFp_WawQE0RPTx30Cb_UHeVMdEbTIk/edit?usp=sharing").worksheets[0]
        matsumaru = session.spreadsheet_by_url("https://docs.google.com/spreadsheets/d/1JUKpJ-DPhVWj1Jq23CpCod-naMUXjlkiQA-Tx5GsOik/edit?usp=sharing").worksheets[0]
        ukitake = session.spreadsheet_by_url("https://docs.google.com/spreadsheets/d/1mDlWYOlN83J_dnSTTng1t0oAdi0q637Hpwmvium_GLU/edit").worksheets[0]
        all_appt_sheet = session.spreadsheet_by_url("https://docs.google.com/spreadsheets/d/11Ps1iEYe9E9v_CIyWjZiF05-V9j_wvPV4fUuU12Kp2Q/edit").worksheets[0]
    
        # すべてのスプレッドシートからデータを取得して all_appt_sheet に追加
        [ 
        [sakamaki, [2, 4, 10, 19, 16, 7]],
        [sugi, [2, 4, 10, 18, 17, 7]],
        [shimotori, [2, 4, 10, 16, 17, 7]],
        [matsumaru, [2, 4, 10, 17, 16, 7]],
        [ukitake, [2, 4, 10, 18, 17, 7]]
        ].each_with_index do |(sheet, columns), index|
            start_row = get_last_nonempty_row(all_appt_sheet) + 1

            sheet.rows[1..-1].each do |row|                
                extracted_data = columns.map { |index| row[index - 1] }
                all_appt_sheet.insert_rows(start_row, [extracted_data])
                start_row += 1
            end
        end

        # すべてのデータ挿入後に変更を保存
        all_appt_sheet.save
    
        # クリア処理
        [sakamaki, sugi, shimotori, matsumaru, ukitake].each do |sheet|
            num_rows = sheet.num_rows  # シートの総行数を取得
            if num_rows > 1
              # 2行目から最後の行まで、1列目から最後の列までの範囲を指定してクリア
              # 'Z'は最後の列を表すと仮定
              sheet.update_cells(2, 1, Array.new(num_rows - 1) { Array.new(26, "") })  # 空文字列で全セルを更新
              sheet.save  # 変更を保存
            end
        end
      end
    
      private
    
      # 最後の非空白行を取得
      def get_last_nonempty_row(sheet)
        last_row = sheet.rows.find_index { |row| row.compact.empty? }
        last_row || sheet.num_rows
      end
  end