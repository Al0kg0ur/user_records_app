class DailyRecordsController < ApplicationController
  def index
    @daily_records = DailyRecord.all.map do |dr|
      {
        "date" => dr.date,
        "male_count" => dr.male_count,
        "female_count" => dr.female_count,
        "male_avg_age" => dr.male_avg_age,
        "female_avg_age" => dr.female_avg_age
      }
    end

    render_liquid('daily_records/index', daily_records: @daily_records)
  end
end
