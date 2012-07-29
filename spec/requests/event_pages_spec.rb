require 'spec_helper'

describe "Event pages" do

  subject { page }

  describe "event page" do
    let(:event) { FactoryGirl.create(:event) }
    before { visit event_path(event) }

    it { should have_selector('h1',    text: event.name) }
    it { should have_selector('title', text: "Event | #{event.name}") }
  end
end

