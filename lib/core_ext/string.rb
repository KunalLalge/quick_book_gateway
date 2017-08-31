class String
  BLANK_REGEX	=	/\A[[:space:]]*\z/
  
  def blank?
    return BLANK_REGEX === self
  end
end