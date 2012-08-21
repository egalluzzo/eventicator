require 'spec_helper'

describe Event do

  before do
    @event = Event.new(name:        "Google I/O 2012",
                       location:    "1600 Amphitheatre Parkway\nMountain View, CA 94043",
                       description: "Find out about everything Google is currently up to.",
                       start_date:  Date.civil(2012, 6, 27),
                       end_date:    Date.civil(2012, 6, 29))
  end

  subject { @event }

  it { should respond_to(:name) }
  it { should respond_to(:location) }
  it { should respond_to(:description) }
  it { should respond_to(:start_date) }
  it { should respond_to(:end_date) }
  it { should respond_to(:talks) }
  it { should respond_to(:invitations) }
  it { should respond_to(:accepted_invitations) }
  it { should respond_to(:accepted_users) }
  it { should respond_to(:date_range) }

  it { should be_valid }

  describe "when name is not present" do
    before { @event.name = nil }
    it { should_not be_valid }
  end

  describe "when name is blank" do
    before { @event.name = " " }
    it { should_not be_valid }
  end

  describe "when name is too long" do
    before { @event.name = "a" * 101 }
    it { should_not be_valid }
  end

  describe "when location is not present" do
    before { @event.location = nil }
    it { should_not be_valid }
  end

  describe "when location is blank" do
    before { @event.location = " " }
    it { should_not be_valid }
  end

  describe "when location is too long" do
    before { @event.location = "a" * 251 }
    it { should_not be_valid }
  end

  describe "when description is too long" do
    before { @event.description = "a" * 2001 }
    it { should_not be_valid }
  end

  describe "when start_date is not present" do
    before { @event.start_date = nil }
    it { should_not be_valid }
  end

  describe "when end_date is not present" do
    before { @event.end_date = nil }
    it { should_not be_valid }
  end

  describe "when start_date is after end_date" do
    before { @event.end_date = @event.start_date.yesterday }
    it { should_not be_valid }
  end

  describe "when start_date is the same as end_date" do
    before { @event.end_date = @event.start_date }
    it { should be_valid }
  end

  describe "talks" do
    before { @event.save }
    let!(:later_talk) do
      FactoryGirl.create(:talk,
                         event:    @event,
                         start_at: @event.start_date.to_datetime.change({hour: 11}),
                         end_at:   @event.start_date.to_datetime.change({hour: 12}))
    end
    let!(:earlier_talk) do
      FactoryGirl.create(:talk,
                         event:    @event,
                         start_at: @event.start_date.to_datetime.change({hour: 9}),
                         end_at:   @event.start_date.to_datetime.change({hour: 10}))
    end

    it "should have its talks in the right order" do
      talks = @event.talks
      talks.should == [earlier_talk, later_talk]
      @event.destroy
      talks.each do |talk|
        Talk.find_by_id(@talk.id).should be_nil
      end
    end
  end

  describe "accepted_invitations and accepted_users" do
    let(:event)             { FactoryGirl.create(:event) }
    let(:inviting_user)     { FactoryGirl.create(:user) }
    let(:accepted_user)     { FactoryGirl.create(:user) }
    let(:non_accepted_user) { FactoryGirl.create(:user) }
    let!(:accepted_invitation) do
      event.invitations.create(inviting_user_id: inviting_user.id,
                               invited_user_id:  accepted_user.id,
                               accepted:         true)
    end
    let!(:non_accepted_invitation) do
      event.invitations.create(inviting_user_id: inviting_user.id,
                               invited_user_id:  non_accepted_user.id)
    end

    it "should only have one accepted invitation" do
      event.accepted_invitations.should == [accepted_invitation]
    end

    it "should only have one accepted user" do
      event.accepted_users.should == [accepted_user]
    end
  end

  describe "first_n" do
    before(:all) do
      7.downto(1) do |n|
        FactoryGirl.create(:event,
                           start_date: Date.today.to_datetime.advance( months: n - 1, days: -1 ),
                           end_date:   Date.today.to_datetime.advance( months: n - 1 ))
      end
    end

    it "should return the next five events in the right order" do
      first_5_events = Event.first_n(5)
      first_5_events.count.should == 5
      first_5_events[0].end_date.should == Date.today
      first_5_events[1].end_date.should == Date.today.advance( months: 1 )
      first_5_events[4].end_date.should == Date.today.advance( months: 4 )
    end
  end
end
