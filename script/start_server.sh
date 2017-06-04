#変数定義
TWITTER_API_DIR="/var/rails/secret"
RAILS_ROOT_DIR="/rails/emotter"
export TWITTER_API_KEY=`cat ${TWITTER_API_DIR}/key.txt`
export TWITTER_API_SECRET=`cat ${TWITTER_API_DIR}/secret.txt`
export SECRET_KEY_BASE=`rake secret`

#本体処理
cd ${RAILS_ROOT_DIR}
bundle exec unicorn_rails -c config/unicorn.rb -D -E production

systemctl start nginx

#状態確認
sleep 1

if [ -e /rails/emotter/tmp/pids/unicorn.pid ]; then
  echo "unicorn起動成功"
else
  echo "unicorn起動失敗"
fi

echo "nginx起動状態を確認します"
systemctl status nginx | grep Active
