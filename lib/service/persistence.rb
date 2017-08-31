module Service
  module Persistence
    
    def self.included(base)
      base.send :include, Callback
    end
    
    private
    def qb_entity
      return case entity
      when 'TaxRate' then 'taxservice'
      else entity.downcase
      end
    end
    
    public
    #Create or Update current instance to QuickBook
    def save!
      new_record = self.is_new_record
      
      before_save
      before_create if new_record
      before_update unless new_record
      
      params = {}
      params[:operation] = :update unless(self.is_new_record)
      
      self.attributes = quickbook_gateway.post(qb_entity, params , self.attributes.to_json())[entity]
      
      after_update unless new_record
      after_create if new_record
      after_save
    end
    
    #Delete QuickBook record, require Id attribute
    #This will delete or make record Inactive based on object class.
    #For Invoice it will delete record from server else make record Active false.
    def destroy
      before_destroy
      
      entities_for_delete = ["INVOICE", "PAYMENT", "SALESRECEIPT", "REFUNDRECEIPT"]
      
      raise RecordDeleteError, "Can't delete record without ID" if self["Id"].to_i == 0
      if(entities_for_delete.index(qb_entity.upcase))
        raise RecordDeleteError, "Can't delete new record" if self.is_new_record 
        quickbook_gateway.post(qb_entity.downcase, {:operation => :delete} , {"Id" => self["Id"], "SyncToken" => self["SyncToken"]}.to_json())
        self.attributes = {}
        self.is_new_record = true
      else
        self.Active = "false"
        self.save!
      end
      
      after_destroy
    end
  end
end