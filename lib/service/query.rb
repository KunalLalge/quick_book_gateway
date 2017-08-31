module Service
  module Query
    
    def sanitize_sql(ary)
      return ary if ary.class != Array
      
      statement, *values = ary
      
      return statement.gsub('?') do
        "'" + values[0].to_s.gsub("'", "\\\\'") +"'"
      end
    end
    
    def create_query(options = {})
      columns = "*"
      
      condition = "WHERE #{sanitize_sql(options[:conditions])}" unless(options[:conditions].to_s.blank?)
      columns = options[:select] unless(options[:select].to_s.blank?)      
      
      start = "STARTPOSITION #{options[:start]}" if(options[:start].to_i > 0)
      max_result = "MAXRESULTS #{options[:top]}" if(options[:top].to_i > 0)
        
      return "SELECT #{columns} FROM #{entity} #{condition} #{start} #{max_result}"
    end
  end
end