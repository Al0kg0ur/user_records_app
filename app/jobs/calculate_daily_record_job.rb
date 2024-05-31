class CalculateDailyRecordJob < ApplicationJob
  queue_as :default

  def perform(*args)
    male_count, female_count = fetch_gender_counts
    daily_record = create_daily_record(male_count, female_count)
    update_avg_ages(daily_record)
  end

  private

  def fetch_gender_counts
    redis = Redis.new(url: ENV["REDIS_URL"] || "redis://localhost:6379/0")
    male_count = redis.get('male_count').to_i
    female_count = redis.get('female_count').to_i
    [male_count, female_count]

  end

  def create_daily_record(male_count, female_count)
    DailyRecord.create(
      date: Date.today,
      male_count: male_count,
      female_count: female_count
    )
  end

  def update_avg_ages(daily_record)
    daily_record.update(male_avg_age: average_age('male'), female_avg_age: average_age('female'))
  end

  def average_age(gender)
    User.where(gender: gender).average(:age).to_f.round(2)
  end
end
