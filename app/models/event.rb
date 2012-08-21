class Event < ActiveRecord::Base
  attr_accessible :name, :location, :description, :start_date, :end_date

  has_many :talks,                dependent:  :destroy
  has_many :invitations,          dependent:  :destroy
  has_many :accepted_invitations, class_name: "Invitation",
                                  conditions: { accepted: true }
  has_many :accepted_users,       through:    :accepted_invitations,
                                  source:     :invited_user,
                                  uniq:       true

  has_event_calendar start_at_field: 'start_date', end_at_field: 'end_date'

  validates :name,        presence: true, length: { maximum: 100 }
  validates :location,    presence: true, length: { maximum: 250 }
  validates :description, length: { maximum: 2000 }
  validates :start_date,  presence: true
  validates :end_date,    presence: true, comparison: { on_or_after: :start_date }

  def self.first_n(n)
    Event.where('end_date >= ?', Date.today).order('start_date ASC').limit(n)
  end

  def date_range
    DateRange.new(start_date, end_date)
  end
end
