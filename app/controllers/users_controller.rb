class UsersController < ApplicationController
  def index
    if params[:search].present?
      @users = User.where("name->>'first' ILIKE ? OR name->>'last' ILIKE ?", "%#{params[:search]}%", "%#{params[:search]}%")
    else
      @users = User.all
    end

    @users = @users.map do |user|
      {
        "id" => user.id,
        "name" => "#{user.name['first']} #{user.name['last']}"&.titleize,
        "age" => user.age,
        "gender" => user.gender&.titleize,
        "created_at" => "#{user.created_at&.strftime("%d %B %Y at %H:%M %p")}"
      }
    end
    render_liquid("users/index", users: @users)
  end

  def destroy
    @user = User.find(params[:id])
    decrement_gender_count(@user.gender)
    @user.destroy

    redirect_to users_path
  end

  private

  def decrement_gender_count(gender)
    daily_record = DailyRecord.find_by(date: Date.today)
    return unless daily_record

    case gender
    when 'male'
      daily_record.male_count -= 1
    when 'female'
      daily_record.female_count -= 1
    end

    daily_record.save
  end
end
