Gem::Specification.new do |s|
  s.name        = 'quick_book_gateway'
  s.version     = '0.0.4'
  s.date        = '2017-07-25'
  s.summary     = "QuickBook Online Gateway"
  s.description = "Connect to QuickBook Online and easily synchronize data. Please read README file to know how to use located at gems-directory/quick_book_gateway-0.0.2/README "
  s.authors     = ["Kunal Lalge"]
  s.email       = 'kunallalge@gmail.com'
  s.files       = [
    "lib/quick_book_gateway.rb",
    "lib/errors.rb",
    "lib/core_ext/string.rb",
    "lib/core_ext/hash.rb",
    "lib/core_ext/nil.rb",
    "lib/gateway/quickbook.rb",
    "lib/gateway/result.rb",
    "lib/service/query.rb",
    "lib/service/finder.rb",
    "lib/service/callback.rb",
    "lib/service/persistence.rb",
    "lib/service/record.rb",
    "README"
  ]
  s.homepage    = 'https://rubygems.org/gems/quick_book_gateway'

  s.add_dependency "oauth", '~>0'
end