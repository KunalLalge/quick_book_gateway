class Hash
  def to_uri_query
    return self.map{|key, value| "#{key}=#{URI.encode_www_form_component(value)}" if value}.select{|value| value if value}.join("&")
  end
end