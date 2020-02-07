require 'json'

module Gateway
  class Result
    
    include Errors
    
    def handle_query_result(response)
      if(response.status.to_i == 200)
        result = JSON.parse(response.body)
        
        if result["Fault"]
          error_message = ""
          result["Fault"]["Error"].each{|error|
            error_message = "#{error["Message"]}. #{error["Detail"]}" 
          }
          
          raise GatewayError, error_message
        end
        
        return result["QueryResponse"] if result["QueryResponse"]
        
        return result
      else
        raise GatewayError, response.body
      end
    end
  end
end