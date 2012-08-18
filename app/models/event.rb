class Event < ActiveRecord::Base
  attr_accessible :name, :location, :description, :start_date, :end_date
  has_many :talks, dependent: :destroy

  has_event_calendar :start_at_field  => 'start_date', :end_at_field => 'end_date'

  validates :name,        presence: true, length: { maximum: 100 }
  validates :location,    presence: true, length: { maximum: 250 }
  validates :description, length: { maximum: 2000 }
  validates :start_date,  presence: true
  validates :end_date,    presence: true, comparison: { on_or_after: :start_date }

  def date_range
    DateRange.new(start_date, end_date)
  end
end

