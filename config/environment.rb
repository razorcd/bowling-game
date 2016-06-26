# Load the Rails application.
require File.expand_path('../application', __FILE__)

Dir.mkdir("#{Rails.root}/tmp") unless Dir.exists?("#{Rails.root}/tmp") #used for default Rails caching
Dir.mkdir("#{Rails.root}/tmp/cache") unless Dir.exists?("#{Rails.root}/tmp/cache") #used for default Rails caching

# Initialize the Rails application.
Rails.application.initialize!

