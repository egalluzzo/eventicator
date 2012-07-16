class ComparisonValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    other_value = record[options[:on_or_after]]
    unless value.nil? || other_value.nil? || value >= other_value
      record.errors[attribute] << (options[:message] || "must be on or after #{other_value}" )
    end
  end
end

class Event < ActiveRecord::Base
  attr_accessible :name, :location, :start_date, :end_date

  validates :name,       presence: true, length: { maximum: 100 }
  validates :location,   presence: true, length: { maximum: 250 }
  validates :start_date, presence: true
  validates :end_date,   presence: true, comparison: { on_or_after: :start_date }
end

