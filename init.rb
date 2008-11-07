ActiveRecord::Base.send(:extend, Dreamer3::RangedFind::ClassMethods)

class << ActiveRecord::Base 
  
  alias find_without_when find
  
  def find(*args)
    find_with_when(*args)
  end
  
end