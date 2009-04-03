ActiveRecord::Base.send(:extend, Dreamer3::RangedFind::ClassMethods)

class << ActiveRecord::Base
  
  alias_method_chain :count, :when
  alias_method_chain :find, :when
  
end
