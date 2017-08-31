module Service
  #Base class use to map QuickBook record with Ruby instance
  #QuickBook API documentation https://developer.intuit.com/v2/apiexplorer?apiname=V3QBO
  class Record
    @@quickbook_gateway
    
    class << self
      attr_accessor :entity_name
    end
    
    extend Service::Finder
    include Service::Persistence
    include Errors
    
    attr_reader :attributes 
      
    attr_accessor  :is_new_record

    #Set instance of Gateway::QuickBook
    def self.quickbook_gateway=(gateway)
      @@quickbook_gateway = gateway
    end
    
    def self.quickbook_gateway
      return @@quickbook_gateway
    end
    
    def quickbook_gateway
      return @@quickbook_gateway
    end
    
    def initialize(attributes = {})
      self.is_new_record = true
      self.attributes = attributes
    end
    
    def attributes=(values)
      @attributes = Hash.new
      values.keys.each{|key|
        self[key] = values[key]
      }
    end
    
    private 
    def self.entity
      self.entity_name = self.entity_name || self.name.split("::").last
      return self.entity_name
    end
    
    def self.set_entity_name(name)
      self.entity_name  = name
    end
    
    def entity
      return self.class.entity
    end
    
    public
    def [](key)
      return self.attributes[key.to_s]
    end

    def []=(key, value)
      self.attributes[key.to_s] = value
    end
    
    def method_missing(method_sym, *args, &block)
      attribute = method_sym.to_s
      if (args.length == 1 and method_sym.to_s[-1, 1] == "=")
        self[attribute[(0..method_sym.length - 2)].to_s] = args[0]
      elsif (self.attributes.keys.index(attribute))
        return self[attribute]
      else
        super
      end
    end
  end
end
