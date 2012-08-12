require 'spec_helper'

describe Talk do

  let(:event) { FactoryGirl.create(:event) }
  before do
    @talk = event.talks.build(title:       "Title",
                              speaker:     "Speaker",
                              description: "Description",
                              room:        "Room",
                              start_at:    event.start_date.to_datetime.change({
                                             hour: 9, minute: 0
                                           }),
                              end_at:      event.start_date.to_datetime.change({
                                             hour: 10, minute: 0
                                           }))
  end

  subject { @talk }

  it { should respond_to(:title) }
  it { should respond_to(:speaker) }
  it { should respond_to(:description) }
  it { should respond_to(:room) }
  it { should respond_to(:start_at) }
  it { should respond_to(:end_at) }
  it { should respond_to(:event_id) }
  it { should respond_to(:event) }
  its(:event) { should == event }

  it { should be_valid }

  describe "accessible attributes" do
    it "should not allow access to event_id" do
      expect do
        Talk.new(event_id: event.id)
      end.should raise_error(ActiveModel::MassAssignmentSecurity::Error)
    end
  end

  describe "when title is not present" do
    before { @talk.title = nil }
    it { should_not be_valid }
  end

  describe "when title is too long" do
    before { @talk.title = "a"*101 }
    it { should_not be_valid }
  end

  describe "when speaker is not present" do
    before { @talk.speaker = nil }
    it { should_not be_valid }
  end

  describe "when speaker is too long" do
    before { @talk.speaker = "a"*51 }
    it { should_not be_valid }
  end

  describe "when room is not present" do
    before { @talk.room = nil }
    it { should be_valid }
  end

  describe "when room is too long" do
    before { @talk.room = "a"*51 }
    it { should_not be_valid }
  end

  describe "when description is not present" do
    before { @talk.description = nil }
    it { should be_valid }
  end

  describe "when description is too long" do
    before { @talk.description = "a"*2001 }
    it { should_not be_valid }
  end

  describe "when start_at is not present" do
    before { @talk.start_at = nil }
    it { should_not be_valid }
  end

  # FIXME: Make this pass
#  describe "when start_at is before the start of the event" do
#    before { @talk.start_at = event.start_date.yesterday.to_datetime.change({ hour: 23 }) }
#    it { should_not be_valid }
#  end

  describe "when end_at is not present" do
    before { @talk.end_at = nil }
    it { should_not be_valid }
  end

  describe "when end_at is before start_at" do
    before { @talk.end_at = @talk.start_at.change({ hour: 5 }) }
    it { should_not be_valid }
  end

  # FIXME: Make this pass
#  describe "when end_at is after the end of the event" do
#    before { @talk.end_at = event.end_date.tomorrow.to_datetime.midnight }
#    it { should_not be_valid }
#  end
end
