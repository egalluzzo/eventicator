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

    describe "without signing in" do
      it { should have_link('Sign in', href: signin_path) }

      it { should_not have_link('Profile') }
      it { should_not have_link('Settings') }
      it { should_not have_link('Sign out', href: signout_path) }
      it { should_not have_link('Users',    href: users_path) }
    end

    describe "with valid email and password" do
      let(:user) { FactoryGirl.create(:user) }
      before do
        visit signin_path
        fill_in "Email",    with: user.email
        fill_in "Password", with: user.password
        click_button submit
      end

      it { should have_selector('h1', text: "News") }

      it { should have_link('Profile',  href: user_path(user)) }
      it { should have_link('Settings', href: edit_user_path(user)) }
      it { should have_link('Sign out', href: signout_path) }

      it { should_not have_link('Sign in', href: signin_path) }
      it { should_not have_link('Users',   href: users_path) }

      describe "followed by sign out" do
        before { click_link "Sign out" }
        it { should have_link('Sign in') }
      end
    end
  end

  describe "authorization" do

    describe "for non-signed-in users" do
      let(:user)  { FactoryGirl.create(:user) }
      let(:event) { FactoryGirl.create(:event) }

      describe "when attempting to visit a protected page" do
        before do
          visit edit_user_path(user)
          fill_in "Email",    with: user.email
          fill_in "Password", with: user.password
          click_button "Sign in"
        end

        describe "after signing in" do

          it "should render the desired protected page" do
            page.should have_selector('title', text: 'Edit Profile')
          end

          describe "when signing in again" do
            before do
              visit signin_path
              fill_in "Email",    with: user.email
              fill_in "Password", with: user.password
              click_button "Sign in"
            end

            it "should render the default (home) page" do
              page.should have_selector('h1', text: 'News') 
            end
          end
        end
      end

      describe "in the Users controller" do

        describe "visiting the edit page" do
          before { visit edit_user_path(user) }
          it { should have_selector('title', text: 'Sign in') }
        end

        describe "submitting to the update action" do
          before { put user_path(user) }
          specify { response.should redirect_to(signin_path) }
        end

        describe "visiting the user index" do
          before { visit users_path }
          it { should have_selector('title', text: 'Sign in') }
        end
      end

      describe "in the Events controller" do

        describe "visiting the edit page" do
          before { visit edit_event_path(event) }
          it { should have_selector('title', text: 'Sign in') }
        end

        describe "submitting a POST request to the Events#create action" do
          before { post events_path }
          specify { response.should redirect_to(signin_path) }
        end

        describe "submitting a PUT request to the Events#update action" do
          before { put event_path(event) }
          specify { response.should redirect_to(signin_path) }
        end

        describe "submitting a DELETE request to the Events#destroy action" do
          before { delete event_path(event) }
          specify { response.should redirect_to(signin_path) }
        end
      end
    end

    describe "as wrong user" do
      let(:user) { FactoryGirl.create(:user) }
      let(:wrong_user) { FactoryGirl.create(:user, email: "wrong@example.com") }
      before { sign_in user }

      describe "visiting Users#edit page" do
        before { visit edit_user_path(wrong_user) }
        it { should_not have_selector('title', text: full_title('Edit Profile')) }
      end

      describe "submitting a PUT request to the Users#update action" do
        before { put user_path(wrong_user) }
        specify { response.should redirect_to(root_path) }
      end
    end

    describe "as non-admin user" do
      let(:user) { FactoryGirl.create(:user) }
      let(:event) { FactoryGirl.create(:event) }
      let(:non_admin) { FactoryGirl.create(:user) }

      before { sign_in non_admin }

      describe "submitting a POST request to the Users#create action" do
        before { post users_path }
        specify { response.should redirect_to(root_path) }
      end

      describe "submitting a DELETE request to the Users#destroy action" do
        before { delete user_path(user) }
        specify { response.should redirect_to(root_path) }        
      end

      describe "submitting a POST request to the Events#create action" do
        before { post events_path }
        specify { response.should redirect_to(root_path) }
      end

      describe "submitting a PUT request to the Events#update action" do
        before { put event_path(event) }
        specify { response.should redirect_to(root_path) }
      end

      describe "submitting a DELETE request to the Events#destroy action" do
        before { delete event_path(event) }
        specify { response.should redirect_to(root_path) }        
      end
    end

    describe "as admin user" do
      let(:admin) { FactoryGirl.create(:admin) }

      before { sign_in admin }

      describe "submitting a DELETE request to the Users#destroy action for themselves" do
        before { delete user_path(admin) }
        specify { response.should redirect_to(root_path) }        
      end
    end
  end
end
