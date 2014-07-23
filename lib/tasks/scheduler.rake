
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
task :send_replies => :environment do
  puts "Sending replies."
  3.times { YourWrongBot.reply }
  puts "Finished"
end