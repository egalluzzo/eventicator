class StaticPagesController < ApplicationController
  def home
    if signed_in?
      @first_5_events = Event.first_n(5)
    end
  end

  def help
  end

  def about
  end
end
