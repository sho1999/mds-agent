require 'watir'
require 'selenium-webdriver'
require 'date'

class UruTaskCheck
    def self.check
        options = Selenium::WebDriver::Chrome::Options.new
        options.add_argument('--headless')
        options.add_argument('--disable-gpu')
        options.add_argument('--no-sandbox')
        options.add_argument('--disable-dev-shm-usage')

        driver = Selenium::WebDriver.for :chrome, options: options
        # タイムアウト設定を追加
        driver.manage.timeouts.implicit_wait = 30  # 30秒
        driver.manage.timeouts.page_load = 60  # 60秒
        driver.manage.timeouts.script_timeout = 60  # 60秒

        # ログイン
        driver.get("https://lim-administration.herokuapp.com/affiliaters/login")
        driver.find_element(:name, 'login_id').send_keys('limconsulting')
        driver.find_element(:name, 'login_pass').send_keys('YEMS4QECADMIN5434')
        driver.find_element(:name, 'commit').click     
        
        sleep(1)

        task_index = 1

        loop do
            driver.get("https://lim-administration.herokuapp.com/connects?utf8=%E2%9C%93&task_confirmation_pending_filter=確認依頼")
            sleep(1)

            # ページ内のaタグの数をカウント
            task_links = driver.find_elements(:css, 'a.tag_student_task')
            puts "タスク残数: #{task_links.size}"
            ActionCable.server.broadcast("log_channel", { message: "タスク残数: #{task_links.size}" })

            # チェックするタスクが存在しない場合は終了
            break if task_index > task_links.size

            task_links[task_index - 1].click
            sleep(1)
            current_url = driver.current_url

            # 名前のテキストを取得
            name_block = driver.find_element(:css, '.brand-logo').text
            name = name_block.gsub('さんの 課題状況', '')
            puts "--#{name}の課題チェックスタート--"
            # ActionCable.server.broadcast("log_channel", { message: "--#{name}の課題チェックスタート--" })

            # ページ全体のtr要素を取得
            rows = driver.find_elements(:css, 'tr')

            row_index = 0

            rows.each_with_index do |row, index|
                # tr内に「確認依頼」が含まれているかをチェック
                if row.text.include?('確認依頼')
                    # td要素を取得し、最初のtd要素の数値を取得
                    td_elements = row.find_elements(:css, 'td')
                    first_td_value = td_elements[0].text.to_i

                    if first_td_value >= 11
                        # ActionCable.server.broadcast("log_channel", { message: "idが11以降のタスクです" })
                        task_index += 1
                        break
                    else
                        # ActionCable.server.broadcast("log_channel", { message: "idが10以下のタスクなので実行します" })

                        row_index = index

                        # 次の処理をここに記述
                        pass_input = row.find_element(:css, 'input[name="pass"]')
                        driver.execute_script("arguments[0].value='true';", pass_input)

                        # 更新ボタンをクリック
                        update_button = row.find_element(:css, 'input[type="submit"][value="更新"]')
                        driver.execute_script("arguments[0].scrollIntoView(true);", update_button)
                        sleep(1)
                        update_button.click if update_button.displayed? && update_button.enabled?
                        sleep(1) # ページの更新が反映されるのを待つ
                        puts "合格しました"
                        # ActionCable.server.broadcast("log_channel", { message: "合格にしました" })

                        


                        rows = driver.find_elements(:css, 'tr')
                        next_row = rows[row_index + 1] if row_index + 1 < rows.size

                        # 課題解放にチェック
                        release_input = next_row.find_element(:css, 'input[name="release"]')
                        driver.execute_script("arguments[0].value='true';", release_input)
                        puts "課題を開放しました"
                        # ActionCable.server.broadcast("log_channel", { message: "課題を開放しました" })


                        # 更新ボタンをクリック
                        update_button = next_row.find_element(:css, 'input[type="submit"][value="更新"]')
                        driver.execute_script("arguments[0].scrollIntoView(true);", update_button)
                        sleep(1)
                        update_button.click if update_button.displayed? && update_button.enabled?
                        sleep(3) # ページの更新が反映されるのを待つ

                        # 現在のvalueを取得し、そこに5を追加
                        score_input = driver.find_element(:css, 'input[name="connect[task_total_score]"]')
                        current_value = score_input.attribute('value').to_i
                        new_value = current_value + 5
                        driver.execute_script("arguments[0].value='#{new_value}';", score_input)

                        # 「更新する」ボタンをクリック
                        update_button = driver.find_element(:css, 'input[name="commit"][value="更新する"]')
                        driver.execute_script("arguments[0].scrollIntoView(true);", update_button)
                        sleep(1)
                        update_button.click if update_button.displayed? && update_button.enabled?
                        puts "5単位追加しました"
                        # ActionCable.server.broadcast("log_channel", { message: "5単位追加しました" })


                        sleep(1)  # スクロール後に少し待機

                        break
                    end
                end
            end
        end

        driver.quit()
    end
end

