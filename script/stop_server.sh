#変数定義
RAILS_ROOT_DIR="/rails/emotter"

#本体処理
cd ${RAILS_ROOT_DIR}

systemctl stop nginx
kill -QUIT `cat tmp/pids/unicorn.pid`

#状態確認
sleep 1
if [ -e /rails/emotter/tmp/pids/unicorn.pid ]; then
  echo "unicorn起動中"
else
  echo "unicorn停止成功"
fi

echo "nginx起動状態を確認します"
systemctl status nginx | grep Active
