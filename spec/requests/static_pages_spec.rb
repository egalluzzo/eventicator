require 'spec_helper'

describe "Static pages" do

  let(:base_title) { "Eventicator" }

  subject { page }

  describe "home page" do

    before { visit root_path }

    it { should     have_selector('h1',    text: "Eventicator") }
    it { should     have_selector('title', text: "#{base_title}") }
    it { should_not have_selector('title', text: "| Home") }
    it { should     have_selector('a',     text: "Sign up") }

    it { should     have_link('Sign in',  href: signin_path) }
    it { should_not have_link('Sign out', href: signout_path) }
  end

  describe "about page" do

    before { visit about_path }

    it { should have_selector('h1', text: "About Eventicator") }
    it { should have_selector('title', text: "#{base_title} | About") }
  end

  describe "help page" do

    before { visit help_path }

    it { should have_selector('h1', text: "Help") }
    it { should have_selector('title', text: "#{base_title} | Help") }
  end
end
