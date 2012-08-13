class Talk < ActiveRecord::Base
  attr_accessible :description, :end_at, :room, :speaker, :start_at, :title
  belongs_to :event

  validates :title,       presence: true, length: { maximum: 100 }
  validates :speaker,     presence: true, length: { maximum: 50 }
  validates :room,        length: { maximum: 50 }
  validates :description, length: { maximum: 2000 }
  validates :start_at,    presence: true
  validates :end_at,      presence: true, comparison: { on_or_after: :start_at }
  validates :event_id,    presence: true

  validate :must_start_on_or_after_event_start, :must_end_on_or_before_event_end

  default_scope order: 'talks.start_at ASC'

  def must_start_on_or_after_event_start
    if !start_at.nil? && start_at < event.start_date.to_datetime.midnight
      errors.add(:start_at, "can't be before the start of the event")
    end
  end

  def must_end_on_or_before_event_end
    if !end_at.nil? && end_at >= event.end_date.to_datetime.tomorrow.midnight
      errors.add(:end_at, "can't be after the end of the event")
    end
  end
end

