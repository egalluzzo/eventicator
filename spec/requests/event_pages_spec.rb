require 'spec_helper'

describe "Event pages" do

  subject { page }

  describe "event page" do
    let(:event) { FactoryGirl.create(:event) }
    before { visit event_path(event) }

    it { should have_selector('h1',    text: event.name) }
    it { should have_selector('title', text: "#{event.name}") }
  end

  describe "creating a new event" do
    before { visit new_event_path }

    it { should have_selector('h1',    text: 'Create Event') }
    it { should have_selector('title', text: 'Create Event') }

    describe "with invalid information" do
      it "should not create an event" do
        expect { click_button 'Create' }.not_to change(Event, :count)
      end

      describe "after submission" do
        before { click_button 'Create' }

        it { should have_selector('title', text: 'Create Event') }
        it { should have_content("can't be") }
      end
    end

    describe "with valid information" do
      before do
        fill_in "Name",        with: "My Fabulous Event"
        fill_in "Location",    with: "Duke Energy Convention Center\n525 Elm Street\nCincinnati, OH 45202"
        fill_in "Description", with: "A description for my fabulous event"
        fill_in "Start date",  with: "2012-08-23"
        fill_in "End date",    with: "2012-08-24"
      end

      it "should create an event" do
        expect { click_button 'Create' }.to change(Event, :count).by(1)
      end

      describe "after creating an event" do
        before { click_button 'Create' }
        let(:event) { Event.find_by_name('My Fabulous Event') }

        # We should end up on the "show event" page.
        it { should have_selector('title',                   text: event.name) }
        it { should have_selector('div.alert.alert-success', text: "Created event #{event.name}") }
      end
    end
  end
end

