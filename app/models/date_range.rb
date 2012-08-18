class DateRange
  def initialize(start_date, end_date)
    @start_date, @end_date = start_date, end_date
  end

  def to_s
    start_month = @start_date.strftime('%B')
    end_month = @end_date.strftime('%B')
    if @start_date.year == @end_date.year
      if @start_date.month == @end_date.month
        if @start_date.day == @end_date.day
          return "#{start_month} #{@start_date.day}, #{@start_date.year}"
        else
          return "#{start_month} #{@start_date.day} - #{@end_date.day}, #{@start_date.year}"
        end
      else
        return "#{start_month} #{@start_date.day} - #{end_month} #{@end_date.day}, #{@start_date.year}"
      end
    else
      return "#{start_month} #{@start_date.day}, #{@start_date.year} - #{end_month} #{@end_date.day}, #{@end_date.year}"
    end
  end
end

