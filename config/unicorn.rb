# アプリケーションコードのディレクトリを変数に設定
app_path = File.expand_path('../../', __FILE__)

# ワーカープロセスの数を設定
worker_processes 4  # 例えば、4 に設定


# アプリケーションの設置されているディレクトリを指定
working_directory app_path

# UnicornのPIDファイルの場所を指定
pid "#{app_path}/tmp/pids/unicorn.pid"

# リスンするポート番号を指定
listen 3000

# エラーログと標準出力のログの場所を指定
stderr_path "#{app_path}/log/unicorn.stderr.log"
stdout_path "#{app_path}/log/unicorn.stdout.log"

# タイムアウトの設定（秒）
timeout 240

# プリロード設定（Railsアプリケーションをワーカー起動前にロード）
preload_app true

# フォーク前の動作
before_fork do |server, worker|
  defined?(ActiveRecord::Base) && ActiveRecord::Base.connection.disconnect!
end

# フォーク後の動作
after_fork do |server, worker|
  defined?(ActiveRecord::Base) && ActiveRecord::Base.establish_connection
end
