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
end

