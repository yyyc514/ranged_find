class RangedFindRailtie < Rails::Railtie
  
  initializer "ranged_find_init" do |app|
    ActiveSupport.on_load :active_record do
      require 'dreamer3/ranged_find'
      ActiveRecord::Base.send(:extend, Dreamer3::RangedFind::ClassMethods)
    end
  end
  
end