require 'spec_helper'

describe DateRange do
  describe "to_s" do
    it "should not consolidate anything when no fields match" do
      date_range = DateRange.new(Date.civil(2010, 1, 5), Date.civil(2012, 1, 3))
      date_range.to_s.should == 'January 5, 2010 - January 3, 2012'
    end

    it "should consolidate years when they match" do
      date_range = DateRange.new(Date.civil(2010, 1, 5), Date.civil(2010, 5, 5))
      date_range.to_s.should == 'January 5 - May 5, 2010'
    end

    it "should consolidate months when they match" do
      date_range = DateRange.new(Date.civil(2010, 1, 5), Date.civil(2010, 1, 6))
      date_range.to_s.should == 'January 5 - 6, 2010'
    end

    it "should consolidate to a single date when the start and end match" do
      date_range = DateRange.new(Date.civil(2010, 1, 5), Date.civil(2010, 1, 5))
      date_range.to_s.should == 'January 5, 2010'
    end
  end
end

