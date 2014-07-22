
desc "This task is called by the Heroku scheduler add-on"
task :scrape_comments => :environment do
  puts "Grabbing comments."
  YourWrongBot.run
  YourWrongBot.reply
  puts "Finished"
end
