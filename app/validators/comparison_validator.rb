class ComparisonValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    other_value = record[options[:on_or_after]]
    unless value.nil? || other_value.nil? || value >= other_value
      record.errors[attribute] << (options[:message] || "must be on or after #{other_value}")
    end

    other_value = record[options[:after]]
    unless value.nil? || other_value.nil? || value > other_value
      record.errors[attribute] << (options[:message] || "must be after #{other_value}")
    end
  end
end

