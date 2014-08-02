
desc "This task is called by the Heroku scheduler add-on"
task :scrape_comments, [:start_now] => :environment do |t, args|
  start_now = args[:start_now] || false
  hour = Time.now.hour

  if hour == 14 || hour == 23 || hour == 5 || hour == 19 || start_now
    puts "Grabbing comments."
    YourWrongBot.run
    puts "Finished"
  end
end

desc "This task is called by the Heroku scheduler add-on"
task :send_reply => :environment do
  puts "Sending reply"
  YourWrongBot.reply
  puts "Finished"
end

desc "This task is called by the Heroku scheduler add-on"
task :consolidate_comments => :environment do
  puts "Consolidating comments..."
  ConsolidateComments.run
  puts "Finished"
end
