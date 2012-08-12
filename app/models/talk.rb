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
end

