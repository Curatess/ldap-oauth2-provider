# Use this file to easily define all of your cron jobs.

every '12 5,12 * * *' do
  rake "ssl:renew"
end

# Learn more: http://github.com/javan/whenever
