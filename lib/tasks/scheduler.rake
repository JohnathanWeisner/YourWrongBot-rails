
desc "This task is called by the Heroku scheduler add-on"
task :scrape_comments => :environment do
  hour = Time.now.hour
  if hour == 14 || hour == 22 || hour == 5 || hour == 20
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
