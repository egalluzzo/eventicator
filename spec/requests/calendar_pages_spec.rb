require 'spec_helper'

describe "Calendar" do

  subject { page }

  describe "showing an event" do
    let(:event) { FactoryGirl.create(:event) }
    before do
      visit "/calendar/#{event.start_date.year}/#{event.start_date.month}"
    end

    it { should have_content(event.start_date.year.to_s) }
    it { should have_content(event.name) }
    (1..28).each do |n|
      it { should have_content(n.to_s) }
    end
  end
end
