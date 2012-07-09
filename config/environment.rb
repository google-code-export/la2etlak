# Load the rails application
#::ActiveSupport::Deprecation.silenced = true
require File.expand_path('../application', __FILE__)
require 'rails_extensions'
require 'paperclip'
include ActionView::Helpers::DateHelper
IP = 'http://la2etlak-beta.herokuapp.com/'
# Initialize the rails application
NokiaRuby::Application.initialize!

