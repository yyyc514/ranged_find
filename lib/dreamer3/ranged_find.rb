module Dreamer3 # :nodoc:
  module RangedFind # :nodoc:
   
   module ClassMethods
     
     def count(*args)
       options=begin
         if args.is_a? Array
           if args[0].is_a? Hash
             args[0]
           elsif args[1].is_a? Hash
             args[1]
           end
         elsif args.is_a? Hash
           args
         end
       end
       options ||= {}
       if (range=options.delete(:when))
         options[:when_field] ||= :created_at
         when_field=options.delete(:when_field)
         with_dated_scope(when_field, range) { super(*args) }
       else
         super(*args)
       end
     end
     
     def find_with_when(*args)
       options=begin
         if args.is_a? Array
           if args[0].is_a? Hash
             args[0]
           elsif args[1].is_a? Hash
             args[1]
           end
         elsif args.is_a? Hash
           args
         end
       end
       options ||= {}
       if (range=options[:when])
         options.delete(:when)
         options[:when_field] ||= :created_at
         when_field=options.delete(:when_field)
         with_dated_scope(when_field, range) { find_without_when(*args) }
       else
         find_without_when(*args)
       end
     end

     # scopes a class to a given time range on a specific date field
     #
     # with_dated_scope :books, :created_at, :this_year
     # with_dated_scope :books, :updated_at, :this_month
     #
     def with_dated_scope(date_field, time_range)
       if date_field.to_s.include? "."
         field = date_field
       else
         field = "#{table_name}.#{date_field}"
       end
       with_scope(:find => {:conditions => date_range_conditions(field, time_range) } ) do 
         yield
       end
     end

     # returns a conditions array to scope a specific field to a certain time range
     def date_range_conditions(field, time_range)
       conditions = ["? <= #{field} and #{field} < ?"]
       if time_range.is_a?(Range)
         conditions << time_range.begin
         conditions << time_range.end
       else
         case time_range
         when :today
           conditions << Time.zone.now.midnight
           conditions << Time.zone.now.tomorrow.midnight
         when :yesterday
           conditions << Time.zone.now.yesterday.midnight
           conditions << Time.zone.now.midnight
         when :last_year
           conditions << Time.zone.now.last_year.beginning_of_year
           conditions << Time.zone.now.beginning_of_year
         when :this_year
           conditions << Time.zone.now.beginning_of_year
           conditions << Time.zone.now.next_year.beginning_of_year
         when :this_month
           conditions << Time.zone.now.beginning_of_month
           conditions << Time.zone.now.next_month.beginning_of_month
         when :last_month
           conditions << Time.zone.now.last_month.beginning_of_month
           conditions << Time.zone.now.beginning_of_month
         # calcuates the count of last month, but only as far as we are in the current month
         # so if we're half way thru April, then this will only show the stats as of half way thru March
         when :last_month_to_date
           end_of_this_month=(Time.zone.now.next_month.beginning_of_month-1.day).mday
           end_of_last_month=(Time.zone.now.beginning_of_month-1.day).mday
           ratio=Time.zone.now.mday.to_f/end_of_this_month
           end_date=Time.zone.now.last_month.beginning_of_month.midnight+(ratio*end_of_last_month).days

           conditions << Time.zone.now.last_month.beginning_of_month
           conditions << end_date
         end
       end
       conditions
     end
    
    end
  end
end