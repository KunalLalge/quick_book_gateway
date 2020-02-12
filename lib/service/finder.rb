module Service
  module Finder
    def self.extended(base)
      base.send :extend, Query
    end
  
    private
    def query_data(options, total_records, records)
      qb_data = quickbook_gateway.query_data(create_query(options))
      
      if qb_data[entity]
        qb_data[entity].each{|qb_record|
          model = self.new(qb_record)
          model.is_new_record = false
        
          records << model
        } 
        
        if total_records > records.length
          options[:start] = records.length + 1
          query_data(options, total_records, records)
        end
      end
    end
    
    #Find All records related to options provided
    #Options are as below
    #   :conditions => where clause. Default is NOTHING
    #               For example, if you want to fetch customer with DisplayName 'Kunal' then :conditions => ["DisplayName = ?", "Kunal"]
    #
    #   :select => Needed column list. Default is ALL
    #           For ex. if you want Id, DisplayName of all customers then :select => "Id, DisplayName"
    public
    def find_all(options = {}, top = nil)
      raise QuickBookgatewayInvalid unless quickbook_gateway
      
      top = options.delete(:top) unless top
      
      records = Array.new
      
      unless options.keys.index(:conditions)
        conditions = [""]
        options.keys.each{|column|
          conditions[0] += "AND #{column}=?"
          conditions << options.delete(column)
        }
      
        conditions[0] = conditions[0][4..conditions[0].length].to_s
        
        options[:conditions] = conditions
      end
      
      if top
        options[:top] = top 
        total_records = top
      else
        total_records = quickbook_gateway.query_data(create_query(options.merge({:select => "COUNT(*)"})))["totalCount"].to_i
      end
      
      if total_records > 0
        query_data(options, total_records, records)
      end
      
      return records
    end
    
    #Only fetch first record as per options provided
    #Options are as below
    #   Same as Find All
    #     Or you can directly provide Id of record.
    #     For ex. if you want to fetch customer with Id 1, then Customer.find(1)
    def find(options = {})
      if(options.class == Integer)
        model = self.new(quickbook_gateway.get("#{entity.downcase}/#{options}")[entity]) 
        model.is_new_record = false
        return model
      end
      
      return self.find_all(options, 1)[0]
    end
    
    #Try to find record on QuickBook Online as per options provided else create instance of new
    #Options should be an Hash contains columns and values to find record.
    #   For ex. if you want to update customer(Kunal) country to India if exist or create new:
    #       kunal = Customer.find_or_initialize({"DisplayName" => "Kunal"})
    #       kunal.Country = "India"
    #       kunal.save!
    def find_or_initialize(options)
      return new() if(options.keys.length == 0)
      
      qb_record = find(options.dup)
      
      options.delete(:conditions)
      qb_record = new(options) unless qb_record
      
      return qb_record
    end
  end
end