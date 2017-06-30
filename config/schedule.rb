# Use this file to easily define all of your cron jobs.
#
# Learn more: http://github.com/javan/whenever
set :bundle_command, "/home/deploy/.rbenv/shims/"
set :output, "log/whenever.log"

every 1.day, at: '00:01 am' do
  runner "DailyDigestJob.perform_now"
end

every 60.minutes do
  rake "ts:index"
end
