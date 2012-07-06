# Load the rails application
#::ActiveSupport::Deprecation.silenced = true
require File.expand_path('../application', __FILE__)
require 'rails_extensions'
include ActionView::Helpers::DateHelper
# Initialize the rails application
NokiaRuby::Application.initialize!


