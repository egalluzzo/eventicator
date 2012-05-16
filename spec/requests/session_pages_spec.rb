require 'spec_helper'

describe "Session pages" do

  subject { page }

  describe "login page" do
    before { visit login_path }

    it { should have_selector('h1',    text: "Log in") }
    it { should have_selector('title', text: "Log in") }
  end

  describe "login process" do
    before { visit login_path }

    let(:submit) { "Log in" }

    describe "with blank data" do
      before { click_button submit }

      it { should have_selector('title', text: "Log in") }
      it { should have_selector('.alert-error') }

      describe "after visiting another page" do
        before { click_link "Home" }
        it { should_not have_selector('div.alert.alert-error') }
      end
    end

    describe "with valid email and password" do
      let(:user) { FactoryGirl.create(:user) }
      before do
        visit login_path
        fill_in "Email",    with: user.email
        fill_in "Password", with: user.password
        click_button submit
      end

      it { should have_selector('title', text: "Profile | #{user.name}") }

      it { should have_link('Users',    href: users_path) }
      it { should have_link('Profile',  href: user_path(user)) }
      it { should have_link('Settings', href: edit_user_path(user)) }
      it { should have_link('Log out',  href: logout_path) }

      it { should_not have_link('Log in', href: login_path) }

      describe "followed by logout" do
        before { click_link "Logout" }
        it { should have_link('Log in') }
      end
    end
  end
end
