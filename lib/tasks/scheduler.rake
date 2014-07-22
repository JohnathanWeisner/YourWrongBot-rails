desc "This task is called by the Heroku scheduler add-on"
task :update_feed => :environment do
  puts "Grabbing comments."
  YourWrongBot.run
  YourWrongBot.reply
  puts "Finished"
end
