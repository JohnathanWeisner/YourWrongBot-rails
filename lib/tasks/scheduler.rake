
desc "This task is called by the Heroku scheduler add-on"
task :scrape_comments => :environment do
  hour = Time.now.hour
  if hour == 10 || hour == 18 || hour == 24
    puts "Grabbing comments."
    YourWrongBot.run
    YourWrongBot.reply
    puts "Finished"
  end
end
