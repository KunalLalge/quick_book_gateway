require 'oauth'

module Gateway
  class Quickbook < Result
  
    attr_reader :api 
    attr_accessor :consumer, :access_token, :company_id
    
    module HTTP
      JSON = "application/json"
    end
    
    module ENVIRONMENT
      SANDBOX     = "sandbox"
      PRODUCTION  = "production"
    end
    
    module API
      VERSION = "v3"
      COMPANY = "company/?" #replace ? with company ID
      
      QUERY = "query" 
    end
    
    private
    def api=(value)
      @api = value
    end
    
    public
    #Connect to QuickBook online API gateway
    #Options are as follow
    #   String: Environment ENVIRONMENT::SANDBOX or ENVIRONMENT::PRODUCTION. AutoLoad QuickBook key, secret, access token, access secret, company ID from config/quickbook.yml corresponding to environment given.
    #   Hash: 
    #     :qb_key       =>   QuickBook Key,
    #     :qb_secret    =>   QuickBook Secret,
    #     :token        =>   Access Token,
    #     :secret       =>   Access Sceret,
    #     :company_id   =>   QuickBook Company ID,
    #     :environment  =>   ENVIRONMENT::SANDBOX or ENVIRONMENT::PRODUCTION
    def self.connect(options)   
      if(options.class == String)
        configuration = YAML.load_file("config/quickbook.yml")
        environment = options
        options = Hash.new
        options[:qb_key] = configuration[environment]["key"]
        options[:qb_secret] =   configuration[environment]["secret"]
        options[:token] =   configuration[environment]["access_token"]
        options[:secret] =   configuration[environment]["access_secret"]
        options[:company_id] =   configuration[environment]["company_id"]
        options[:environment] = environment
      end
      
      gateway = new
      gateway.consumer = OAuth::Consumer.new(options[:qb_key], options[:qb_secret], {
          :site                 => "https://oauth.intuit.com",
          :request_token_path   => "/oauth/v1/get_request_token",
          :authorize_url        => "https://appcenter.intuit.com/Connect/Begin",
          :access_token_path    => "/oauth/v1/get_access_token"
        })
      
      gateway.access_token = OAuth::AccessToken.new(gateway.consumer, options[:token], options[:secret])
      
      gateway.company_id = options[:company_id]
      
      case options[:environment]
      when ENVIRONMENT::PRODUCTION
        gateway.send("api=", "https://quickbooks.api.intuit.com")
      else
        gateway.send("api=", "https://sandbox-quickbooks.api.intuit.com")
      end   
      
      Service::Record.quickbook_gateway = gateway
    end
    
    private
    def url(path, params = {})
      url = File.join(self.api, API::VERSION, API::COMPANY.gsub("?", self.company_id.to_s), path)
      return "#{url}?minorversion=4&#{params.to_uri_query}"
    end
    
    public
    def get(path, parameters = {})
      return handle_query_result(self.access_token.get(url(path, parameters), {"Accept" => HTTP::JSON}))
    end
    
    def query_data(query)
      return get(API::QUERY, {:query => query})
    end
    
    def post(path, parameters, body)
      return handle_query_result(self.access_token.post(url(path, parameters), body,  {"Content-Type" => HTTP::JSON, "Accept" => HTTP::JSON}))
    end
  end
end