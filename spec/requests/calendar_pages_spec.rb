require 'spec_helper'

describe "Calendar" do

  subject { page }

  describe "January 2013" do
    before { visit "/calendar/2013/01" }
    it { should have_content( "January 2013" ) }
    it { should have_link( "December" ) }
    it { should have_link( "February" ) }
    # FIXME: Test the presence of an event.
  end
end
