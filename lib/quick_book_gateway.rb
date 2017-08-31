require 'errors'

require 'core_ext/string'
require 'core_ext/nil'
require 'core_ext/hash'

require 'gateway/result'
require 'gateway/quickbook'

require 'service/query'
require 'service/finder'
require 'service/callback'
require 'service/persistence'
require 'service/record'

Dir.glob("quick_book_lib/*.rb") do|library|
  require "./#{library}"
end if(File.exists?("quick_book_lib"))

service_failed = []
Dir.glob("app/services/*.rb") do|service|
  begin
    service_failed << service unless require "./#{service}"
  rescue
    service_failed << service 
  end
end

service_failed.each{|service| require "./#{service}"}  

Gateway::Quickbook.connect(Gateway::Quickbook::ENVIRONMENT::SANDBOX) if File.exist?("./config/quickbook.yml")
