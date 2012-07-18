class Notifier < ActionMailer::Base  
  default from: "info.la2etlak@gmail.com"
  default_url_options[:host] = IP

end  
