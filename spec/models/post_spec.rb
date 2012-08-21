require 'spec_helper'

describe Post do
  let(:post) { FactoryGirl.create(:post) }

  subject { post }

  it { should respond_to :title }
  it { should respond_to :content }
  it { should respond_to :user_id }
  it { should respond_to :user }

  it { should be_valid }

  describe "accessible attributes" do
    it "should not allow access to user_id" do
      expect do
        Post.new(user_id: 1)
      end.should raise_error(ActiveModel::MassAssignmentSecurity::Error)
    end    
  end

  describe "when title is nil" do
    before { post.title = nil }
    it { should_not be_valid }
  end

  describe "when title is blank" do
    before { post.title = ' ' }
    it { should_not be_valid }
  end

  describe "when title is too long" do
    before { post.title = 'a'*101 }
    it { should_not be_valid }
  end

  describe "when content is nil" do
    before { post.content = nil }
    it { should_not be_valid }
  end

  describe "when content is blank" do
    before { post.content = ' ' }
    it { should_not be_valid }
  end

  describe "when content is too long" do
    before { post.content = 'a'*2001 }
    it { should_not be_valid }
  end

  describe "when user is nil" do
    before { post.user = nil }
    it { should_not be_valid }
  end
end
