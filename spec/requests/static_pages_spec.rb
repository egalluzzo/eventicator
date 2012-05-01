require 'spec_helper'

describe "Static pages" do

  let(:base_title) { "Eventicator" }

  subject { page }

  describe "home page" do

    before { visit "/static_pages/home" }

    it { should have_selector('h1', text: "Eventicator") }
    it { should have_selector('title', text: "#{base_title}") }
    #it { should_not have_selector('title', text: "| Home") }
  end

  describe "about page" do

    before { visit "/static_pages/about" }

    it { should have_selector('h1', text: "About Eventicator") }
    it { should have_selector('title', text: "#{base_title} | About") }
  end

  describe "help page" do

    before { visit "/static_pages/help" }

    it { should have_selector('h1', text: "Help") }
    it { should have_selector('title', text: "#{base_title} | Help") }
  end
end
