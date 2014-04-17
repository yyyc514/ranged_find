module Dreamer3 # :nodoc:
  module RangedFind # :nodoc:
    
    DATE_RANGES = lambda {{
          # daily
          :yesterday => [ Time.zone.now.yesterday.midnight, 1.day ],
          :today => [ Time.zone.now.midnight, 1.day ],
          :tomorrow => [ Time.zone.now.tomorrow.midnight, 1.day ],
          # yearly
          :last_year => [ Time.zone.now.prev_year.beginning_of_year, 1.year ],
          :this_year => [ Time.zone.now.beginning_of_year, 1.year ],
          :next_year => [ Time.zone.now.next_year.beginning_of_year, 1.year ],
          # monthly
          :last_month => [ Time.zone.now.prev_month.beginning_of_month, 1.month ],
          :this_month => [ Time.zone.now.beginning_of_month, 1.month ],
          :next_month => [ Time.zone.now.next_month.beginning_of_month, 1.month ],
        }}
   
   module ClassMethods

     def when(range, field = "created_at")
       return self if range.nil?
       field = "#{table_name}.#{field}" unless field.to_s.include?(".")
       self.where(date_range_conditions(field, range))
     end
          
     private
     
     # returns a conditions array to scope a specific field to a certain time range
     def date_range_conditions(field, time_range)
       sql = ["? <= #{field} and #{field} < ?"]
       actual_range = []
       if time_range.is_a?(Range)
         actual_range << time_range.begin
         actual_range << time_range.end
       elsif range=DATE_RANGES.call[time_range]
         actual_range << range.first
         actual_range << (range.last===Time ? range.last : range.first + range.last)
       else
         case time_range
         # calcuates the count of last month, but only as far as we are in the current month
         # so if we're half way thru April, then this will only show the stats as of half way thru March
         when :last_month_to_date
           end_of_this_month=(Time.zone.now.next_month.beginning_of_month-1.day).mday
           end_of_last_month=(Time.zone.now.beginning_of_month-1.day).mday
           ratio=Time.zone.now.mday.to_f/end_of_this_month
           end_date=Time.zone.now.prev_month.beginning_of_month.midnight+(ratio*end_of_last_month).days

           actual_range << Time.zone.now.prev_month.beginning_of_month
           actual_range << end_date
         else
           raise "invalid date range provided"
         end
       end
       # date
       if field =~ /_on$/
         actual_range = actual_range.map {|x| x.to_date}
       end
       sql + actual_range
     end
    
    end
  end
end