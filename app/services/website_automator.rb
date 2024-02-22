require 'watir'
require 'selenium-webdriver'
require 'date'

class WebsiteAutomator
    def self.perform_operations(data)
        options = Selenium::WebDriver::Chrome::Options.new
        options.add_argument('--headless') # ヘッドレスモードでの実行
        options.add_argument('--no-sandbox') # セキュリティサンドボックスを無効化
        options.add_argument('--disable-dev-shm-usage') # /dev/shmの使用を回避
        options.add_argument('--disable-gpu') # GPUハードウェアアクセラレーションを無効化（オプショナル）
        options.add_argument('--remote-debugging-port=9222') # リモートデバッグポートを指定

        driver = Selenium::WebDriver.for :chrome, options: options

        driver.get("https://mds-fund.herokuapp.com/affiliaters/login")

        # ログイン情報の入力
        driver.find_element(:name, 'login_id').send_keys('mds')
        driver.find_element(:name, 'login_pass').send_keys('YEMS4QECADMIN5434')

        # ログインボタンをクリック
        driver.find_element(:name, 'commit').click

        data.each do |row|
            # 代理店IDを入力
            driver.get("https://mds-fund.herokuapp.com/affiliaters/edit_business_case")


            driver.find_element(:id, 'business_case_original_id').send_keys(row[0])
        
            # ページ上の最初のドロップダウン(案件担当)を開き、ドロップダウンメニューの選択肢を取得し、「代理店案件」にする
            first_dropdown_trigger = driver.find_elements(:css, 'input.select-dropdown.dropdown-trigger').first
            first_dropdown_trigger.click()
            sleep(1)
            first_dropdown_menu = driver.find_elements(:css, 'ul.dropdown-content.select-dropdown').first
            manager_options = first_dropdown_menu.find_elements(:tag_name, 'span')
            manager_options.each do |option|
                if option.text == "代理店案件"
                    option.click()
                    break
                end
            end

            # ページ上の2番目のドロップダウン(ステータス)を開き、ドロップダウンメニューの選択肢を取得し、「成約済み」にする
            second_dropdown_trigger = driver.find_elements(:css, 'input.select-dropdown.dropdown-trigger')[1]
            second_dropdown_trigger.click()
            sleep(0.3) 
            second_dropdown_menu = driver.find_elements(:css, 'ul.dropdown-content.select-dropdown')[1]
            status_options = second_dropdown_menu.find_elements(:tag_name, 'span')
            status_options.each do |option|
                if option.text == "成約済み"
                    option.click
                    break
                end
            end
        
            # クライアント名を入力
            driver.find_element(:id, 'business_case_company').send_keys(row[1])

        
            # ページ上の3番目のドロップダウン(営業担当者)を開き、指定された値に設定
            third_dropdown_trigger = driver.find_elements(:css, 'input.select-dropdown.dropdown-trigger')[2]
            third_dropdown_trigger.click
            sleep(0.3)
            third_dropdown_menu = driver.find_elements(:css, 'ul.dropdown-content.select-dropdown')[2]
            salesperson_options = third_dropdown_menu.find_elements(:tag_name, 'span')
            salesperson_options.each do |option|
                if option.text == row[2] # 営業担当者の名前で選択
                    option.click
                    break
                end
            end

            # JavaScriptを使用してドロップダウンを閉じる
            driver.execute_script('arguments[0].style.display = "none";', third_dropdown_menu)

            # 電話番号を入力
            driver.find_element(:id, 'business_case_tel').send_keys('08012345678')

            # メールアドレスを入力
            driver.find_element(:id, 'business_case_email').send_keys('1@1')

            # ページをスクロール
            driver.execute_script("window.scrollBy(0, 250);")

            # 見込みサービスを入力
            checkbox = driver.find_element(:css, 'input[type="checkbox"][value="appointment"]')
            driver.execute_script("arguments[0].click();", checkbox)
                
            # 今日の日付を取得
            today = Date.today
            year = today.year.to_s
            month = today.month.to_s
            day = today.day.to_s

            # 日付を入力するドロップダウンのトリガーをクリック
            date_dropdown_trigger = driver.find_elements(:css, 'input.select-dropdown.dropdown-trigger')[3]
            date_dropdown_trigger.click
            sleep(0.3)

            # ドロップダウンメニューを取得
            date_dropdown_menu = driver.find_elements(:css, 'ul.dropdown-content.select-dropdown')[3]
            date_options = date_dropdown_menu.find_elements(:tag_name, 'span')

            # 年を選択
            date_options.each do |option|
                if option.text == year
                    option.click
                    break
                end
            end
        
            # 月を入力
            date_dropdown_trigger = driver.find_elements(:css, 'input.select-dropdown.dropdown-trigger')[4]
            date_dropdown_trigger.click
            sleep(0.3)
            date_dropdown_menu = driver.find_elements(:css, 'ul.dropdown-content.select-dropdown')[4]
            date_dropdown_menu.find_elements(:tag_name, 'span').each do |option|
                if option.text == month
                    option.click
                    break
                end
            end

            # 日を入力
            date_dropdown_trigger = driver.find_elements(:css, 'input.select-dropdown.dropdown-trigger')[5]
            date_dropdown_trigger.click
            sleep(0.3)
            date_dropdown_menu = driver.find_elements(:css, 'ul.dropdown-content.select-dropdown')[5]
            date_dropdown_menu.find_elements(:tag_name, 'span').each do |option|
                if option.text == day
                    option.click
                    break
                end
            end
        
            # 報酬金を入力
            driver.find_element(:id, 'business_case_reward').send_keys('500')

            # 情報を更新
            submit_button = driver.find_element(:id, 'check')
            submit_button.click
            
        end
        
        driver.quit()
    end
end