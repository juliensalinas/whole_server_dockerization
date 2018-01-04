# Redirect all traffic from 127.0.0.1:5432 to 172.20.0.1:5432
# so any connection to Postgresql keeps working without any other modification.
# Requires the --privileged flag when creating container:
sysctl -w net.ipv4.conf.all.route_localnet=1
iptables -t nat -A OUTPUT -p tcp -s 127.0.0.1 --dport 5432 -j DNAT --to-destination 172.20.0.1:5432
iptables -t nat -A POSTROUTING -j MASQUERADE

# Start RabbitMQ.
rabbitmq-server -detached

# Start Nginx.
service nginx start

# Start Scrapyd
/root/.virtualenvs/my_project_2/bin/python /root/.virtualenvs/my_project_2/bin/scrapyd >> /var/log/scrapyd/scrapyd.log 2>&1 &

# Use Python virtualenvwrapper
source /root/.profile

# Start virtualenv and start Django/Gunicorn
workon my_project_1
cd /home/my_project_1
export DJANGO_SETTINGS_MODULE='my_project_1.settings.prod'
gunicorn -c my_project_1/gunicorn.py -p /tmp/gunicorn.pid my_project_1.wsgi &

# Start Celery
export C_FORCE_ROOT=True
celery -A my_project_1 beat &
celery -A my_project_1 worker -l info -Q queue1,queue2 -P gevent -c 1000 &

# Little hack to keep the container running in foreground
tail -f /dev/null
