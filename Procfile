redis: redis-server
web: bundle exec rails s -p 3000
worker1: bundle exec "WORKER=band   rails s -p 3001 -P 42341"
worker2: bundle exec "WORKER=lyrics rails s -p 3002 -P 42342"
worker3: bundle exec "WORKER=albums rails s -p 3003 -P 42343"
