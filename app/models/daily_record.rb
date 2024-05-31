class DailyRecord < ApplicationRecord
  include ActiveModel::Dirty
  before_save :update_average_ages

  private

  def update_average_ages
    if male_count_changed? 
      self.male_avg_age = User.where(gender: 'male').average(:age).to_f.round(2)
    elsif female_count_changed?
      self.female_avg_age = User.where(gender: 'female').average(:age).to_f.round(2)
    end
  end
end
  