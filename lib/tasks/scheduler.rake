
desc "This task is called by the Heroku scheduler add-on"
task :scrape_comments => :environment do
  hour = Time.now.hour
  if hour == 14 || hour == 22 || hour == 5 || hour == 15
    puts "Grabbing comments."
    YourWrongBot.run
    YourWrongBot.reply
    puts "Finished"
  end
end
