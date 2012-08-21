class Post < ActiveRecord::Base
  attr_accessible :content, :title

  belongs_to :user

  validates :title,   presence: true, length: { maximum: 100 }
  validates :content, presence: true, length: { maximum: 2000 }
  validates :user_id, presence: true

  default_scope order: 'created_at DESC'
end
