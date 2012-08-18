require 'spec_helper'

describe "Event pages" do

  subject { page }

  describe "index" do

    before(:all) { 31.times { FactoryGirl.create(:event) } }
    after(:all)  { Event.delete_all }

    before(:each) do
      visit events_path
    end

    it { should have_selector('title', text: 'All events') }
    it { should have_selector('h1',    text: 'All events') }

    describe "pagination" do

      it { should have_selector('div.pagination') }

      it "should list each event" do
        Event.page(1).order('name ASC').each do |event|
          page.should have_selector('li', text: event.name)
        end
      end
    end

    describe "buttons and links" do

      it { should have_link('Calendar') }
      it { should_not have_link('New Event') }
      it { should_not have_link('Edit') }
      it { should_not have_link('Delete') }

      describe "clicking Calendar" do
        before { click_link "Calendar" }
        it { should have_selector('title', text: "Event Calendar") }
      end

      describe "as an admin user" do
        let(:admin) { FactoryGirl.create(:admin) }
        before do
          sign_in admin
          visit events_path
        end

        it { should have_link('Calendar') }
        it { should have_link('New Event') }
        it { should have_link('Edit',   href: edit_event_path(Event.first)) }
        it { should have_link('Delete', href: event_path(Event.first)) }
        it "should be able to delete an event" do
          expect { click_link("delete-event-#{Event.first.id}") }.to change(Event, :count).by(-1)
        end

        describe "clicking New Event" do
          before { click_link "New Event" }
          it { should have_selector('title', text: "New Event") }
        end

        describe "editing an event" do
          before { click_link "edit-event-#{Event.first.id}" }
          it { should have_selector('title', text: "Edit #{Event.first.name}") }
        end
      end
    end
  end

  describe "event page" do
    let(:event) { FactoryGirl.create(:event) }
    let!(:talk1) do
      FactoryGirl.create(:talk,
                         event:   event,
                         title:   "Really Great Talk",
                         speaker: "Stephen Hawking")
    end
    let!(:talk2) do
      FactoryGirl.create(:talk,
                         event:   event,
                         title:   "Some Other Talk",
                         speaker: "Forrest Gump")
    end

    describe "without signing in" do
      before { visit event_path(event) }

      it { should have_selector('h1',    text: event.name) }
      it { should have_selector('title', text: "#{event.name}") }
      it { should_not have_link('Edit Event') }
      it { should_not have_link('Delete Event') }
      it { should_not have_link('Add Talk') }

      describe "showing talks" do
        it { should have_content(talk1.start_at.strftime("%H:%M")) }
        it { should have_content(talk1.title) }
        it { should have_content(talk1.speaker) }
        it { should have_content(talk2.start_at.strftime("%H:%M")) }
        it { should have_content(talk2.title) }
        it { should have_content(talk2.speaker) }
      end
    end

    describe "after signing in as an admin" do
      let(:admin) { FactoryGirl.create(:admin) }
      before do
        sign_in admin
        visit event_path(event)
      end

      it { should have_selector('h1',    text: event.name) }
      it { should have_selector('title', text: "#{event.name}") }
      it { should have_link('Edit Event',   href: edit_event_path(event)) }
      it { should have_link('Delete Event', href: event_path(event)) }
      it { should have_link('Add Talk',     href: "#{new_talk_path}?event_id=#{event.id}") }

      describe "clicking Edit Event goes to the Edit page" do
        before { click_link "Edit Event" }

        it { should have_selector('h1', text: "Edit #{event.name}") }
      end

      it "should delete the event when clicking Delete Event" do
        expect { click_link "Delete Event" }.to change(Event, :count).by(-1)
      end
    end
  end

  describe "creating a new event" do
    let(:admin) { FactoryGirl.create(:admin) }
    before do
      sign_in admin
      visit new_event_path
    end

    it { should have_selector('h1',    text: 'New Event') }
    it { should have_selector('title', text: 'New Event') }

    describe "with invalid information" do
      it "should not create an event" do
        expect { click_button 'Create' }.not_to change(Event, :count)
      end

      describe "after submission" do
        before { click_button 'Create' }

        it { should have_selector('title', text: 'New Event') }
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

  describe "edit" do
    let(:event) { FactoryGirl.create(:event) }
    let(:admin) { FactoryGirl.create(:admin) }
    before do
      sign_in admin
      visit edit_event_path(event)
    end

    describe "page" do
      it { should have_selector('h1',    text: "Edit #{event.name}") }
      it { should have_selector('title', text: "Edit #{event.name}") }
      it { should have_button('Save') }
    end

    describe "with invalid information" do
      before do
        fill_in "Name", with: ""
        click_button "Save"
      end

      it { should have_content('error') }
    end

    describe "with valid information" do
      let(:new_name)        { "New Name" }
      let(:new_description) { "New Description" }
      let(:new_location)    { "New Location" }
      let(:new_start_date)  { Date.civil(2011, 01, 01) }
      let(:new_end_date)    { Date.civil(2011, 01, 04) }
      before do
        fill_in "Name",         with: new_name
        fill_in "Description",  with: new_description
        fill_in "Location",     with: new_location
        fill_in "Start date",   with: new_start_date.strftime("%Y-%m-%d")
        fill_in "End date",     with: new_end_date.strftime("%Y-%m-%d")

        click_button "Save"
      end

      it { should have_selector('h1',    text: new_name) }
      it { should have_selector('title', text: new_name) }
      it { should have_selector('div.alert.alert-success') }
      specify { event.reload.name.should        == new_name }
      specify { event.reload.description.should == new_description }
      specify { event.reload.location.should    == new_location }
      specify { event.reload.start_date.should  == new_start_date }
      specify { event.reload.end_date.should    == new_end_date }
    end
  end
end

