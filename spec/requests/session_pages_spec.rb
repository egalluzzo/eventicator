require 'spec_helper'

describe "Session pages" do

  subject { page }

  describe "signin page" do
    before { visit signin_path }

    it { should have_selector('h1',    text: "Sign in") }
    it { should have_selector('title', text: "Sign in") }
  end

  describe "signin process" do
    before { visit signin_path }

    let(:submit) { "Sign in" }

    describe "with blank data" do
      before { click_button submit }

      it { should have_selector('title', text: "Sign in") }
      it { should have_selector('.alert-error') }

      describe "after visiting another page" do
        before { click_link "Home" }
        it { should_not have_selector('div.alert.alert-error') }
      end
    end

    describe "with valid email and password" do
      let(:user) { FactoryGirl.create(:user) }
      before do
        visit signin_path
        fill_in "Email",    with: user.email
        fill_in "Password", with: user.password
        click_button submit
      end

      it { should have_selector('title', text: "Profile | #{user.name}") }

      # it { should have_link('Users',    href: users_path) }
      it { should have_link('Profile',  href: user_path(user)) }
      it { should have_link('Settings', href: edit_user_path(user)) }
      it { should have_link('Sign out', href: signout_path) }

      it { should_not have_link('Sign in', href: signin_path) }

      describe "followed by sign out" do
        before { click_link "Sign out" }
        it { should have_link('Sign in') }
      end
    end
  end
end
