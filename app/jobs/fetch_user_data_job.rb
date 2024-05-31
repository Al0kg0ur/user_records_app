require 'net/http'
require 'json'

class FetchUserDataJob < ApplicationJob
  queue_as :default

  USER_API_URL = 'https://randomuser.me/api/?results=20'.freeze

  def perform(*args)
    users = fetch_users
    update_users(users)
    update_gender_counts
  end

  private

  def fetch_users
    uri = URI(USER_API_URL)
    response = Net::HTTP.get(uri)
    JSON.parse(response)['results']
  rescue JSON::ParserError => e
    Rails.logger.error("Failed to parse user data: #{e.message}")
    []
  end

  def update_users(users)
    users.each do |user_data|
      user = find_or_initialize_user(user_data['login']['uuid'])
      update_user_attributes(user, user_data)
    end
  end

  def find_or_initialize_user(uuid)
    User.find_or_initialize_by(uuid: uuid)
  end

  def update_user_attributes(user, user_data)
    user.update(
      gender: user_data['gender'],
      name: user_data['name'],
      location: user_data['location'],
      age: user_data['dob']['age']
    )
  rescue ActiveRecord::RecordInvalid => e
    Rails.logger.error("Failed to update user #{user.uuid}: #{e.message}")
  end

  def update_gender_counts
    male_count = User.where(gender: 'male').count
    female_count = User.where(gender: 'female').count

    # Replace Redis.current with your Redis connection
    redis = Redis.new(url: ENV["REDIS_URL"] || "redis://localhost:6379/0")
    redis.set('male_count', male_count)
    redis.set('female_count', female_count)
  end
end
