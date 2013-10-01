class Array
  def sum
    self.inject { |sum, n| sum + n }  
  end
end