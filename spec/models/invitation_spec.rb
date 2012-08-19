require 'spec_helper'

describe Invitation do
  let(:event) { FactoryGirl.create(:event) }
  let(:inviting_user) { FactoryGirl.create(:user) }
  let(:invited_user) { FactoryGirl.create(:user) }

  let(:user_invitation) do
    event.invitations.build(inviting_user_id: inviting_user.id,
                            invited_user_id: invited_user.id)
  end

  let(:email_invitation) do
    event.invitations.build(inviting_user_id: inviting_user.id,
                            invited_email: "someone@example.com")
  end

  subject { user_invitation }

  it { should respond_to(:event) }
  it { should respond_to(:event_id) }
  it { should respond_to(:inviting_user) }
  it { should respond_to(:inviting_user_id) }
  it { should respond_to(:invited_user) }
  it { should respond_to(:invited_user_id) }
  it { should respond_to(:invited_email) }
  it { should respond_to(:accepted) }
  it { should respond_to(:attended) }

  it { should be_valid }

  describe "default values" do
    it { should_not be_accepted }
    it { should_not be_attended }
  end

  describe "when event is nil" do
    before { user_invitation.event = nil }
    it { should_not be_valid }
  end

  describe "when invited_user and invited_email are both nil" do
    before { user_invitation.invited_user = nil }
    it { should_not be_valid }
  end

  describe "when only invited_user is set" do
    specify { user_invitation.should be_valid }
  end

  describe "when only invited_email is set" do
    specify { email_invitation.should be_valid }
  end

  describe "when invited_user and invited_email are both set" do
    before { user_invitation.invited_email = "foo@bar.com" }
    it { should_not be_valid }
  end

  describe "when invited_email is invalid" do
    before { email_invitation.invited_email = "a@b" }
    specify { email_invitation.should_not be_valid }
  end

  describe "when invited_email is valid" do
    before { email_invitation.invited_email = "a@b.c.com" }
    specify { email_invitation.should be_valid }
  end

  describe "invited_user" do

    describe "for invitations for existing users" do
      before { user_invitation.save }
      its(:invited_user) { should == invited_user }
      its(:invited_email) { should be_nil }
    end

    describe "for invitations for existing users' emails" do
      before do
        user_invitation.invited_user_id = nil
        user_invitation.invited_email = invited_user.email
        user_invitation.save
      end
      its(:invited_user) { should == invited_user }
      its(:invited_email) { should be_nil }
    end

    describe "for invitations for nonexistent emails" do
      before { email_invitation.save }
      subject { email_invitation }
      its(:invited_user) { should be_nil }
      its(:invited_email) { should == "someone@example.com" }
    end
  end

  describe "invited_email should be saved and queried as lowercase" do

    describe "for user invitations" do
      before do
        user_invitation.invited_email = invited_user.email.upcase
        user_invitation.invited_user = nil
        user_invitation.save
      end
      let(:found_user) { Invitation.find_by_id(user_invitation.id).invited_user}
      specify { found_user.should == invited_user }
    end

    describe "for email invitations" do
      before do
        email_invitation.invited_email = "Foo@Bar.COM"
        email_invitation.save
      end
      let(:found_email) { Invitation.find_by_id(email_invitation.id).invited_email }
      specify { found_email.should == "foo@bar.com" }
    end
  end

  describe "token" do
    before { user_invitation.save }
    its(:token) { should_not be_blank }
  end
end
