require 'watir'
require 'selenium-webdriver'
require 'date'

class ChangeInterviewDate 
    def self.main(link, date)
        options = Selenium::WebDriver::Chrome::Options.new
        options.add_argument('--headless') # ヘッドレスモードでの実行
        options.add_argument('--no-sandbox') # セキュリティサンドボックスを無効化
        options.add_argument('--disable-dev-shm-usage') # /dev/shmの使用を回避
        options.add_argument('--disable-gpu') # GPUハードウェアアクセラレーションを無効化（オプショナル）
        options.add_argument('--remote-debugging-port=9222') # リモートデバッグポートを指定

        driver = Selenium::WebDriver.for :chrome, options: options


        # ログイン
        driver.get("https://mds-fund.herokuapp.com/affiliaters/login")
        driver.find_element(:name, 'login_id').send_keys('mds')
        driver.find_element(:name, 'login_pass').send_keys('YEMS4QECADMIN5434')
        driver.find_element(:name, 'commit').click   

        #指定ページへ遷移
        driver.get(link)
        
        # 目的の形に変換
        date_object = Date.parse(date)
        formatted_date = date_object.strftime("%Y/%m/%d")

        loop do            
            link_selector = "tbody tr:nth-child(#{1}) td div a"
            element = nil
            begin
                # 要素を検索
                element = driver.find_element(css: link_selector)
            rescue Selenium::WebDriver::Error::NoSuchElementError
                # 要素が見つからない場合はループを抜ける
                break
            end


            # 要素が見つかった場合の処理
            element.click
            form = driver.find_element(class: 'edit_affiliater')
            
            date_input = form.find_element(css: 'input.field.datepicker')
            
            # date_inputの現在の値を取得
            current_date = date_input.attribute("value")
            
            # 現在の日付がformatted_dateと一致するかチェック
            if current_date == formatted_date
                # 一致する場合はループを抜ける
                break
            else
                # 一致しない場合は日付を更新
                date_input.clear
                date_input.send_keys(formatted_date)
                
                # ページをスクロールダウン
                driver.execute_script("window.scrollTo(0, document.body.scrollHeight);")
                
                # 更新ボタンをクリック
                update_button = driver.find_element(css: 'input[type="submit"][value="更新する"]')
                update_button.click

                sleep 1
                # 一覧ページに戻る
                driver.get(link)
            end
        end
        driver.quit()
    end
end