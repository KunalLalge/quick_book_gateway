module Errors
  class GatewayError < StandardError
    def initialize(msg = "Gateway error.")
      super(msg)
    end
  end
  
  class QuickBookgatewayInvalid < GatewayError
    def initialize(msg = "Quickbook gateway is invalid.")
      super(msg)
    end
  end
  
  class RecordDeleteError < GatewayError
    def initialize(msg = "Can't delete quickbook record.")
      super(msg)
    end
  end
end