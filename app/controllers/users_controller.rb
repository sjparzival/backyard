class UsersController < ApplicationController
  respond_to :json
  before_action :authenticate_user, except: :create

  def show
    json_response(User.find(params[:id]))
  end

  def update
    user = User.find(params[:id])

    if user.update(user_params)
      render json: user, status: 200
    else
      render json: { errors: user.errors }, status: 422
    end
  end

  def create
    user = User.new(user_params)
    if user.save
      render json: { email: user.email }, status: 201
    else
      render json: { errors: user.errors }, status: 422
    end
  end

  def destroy
    user = User.find(params[:id])
    user.destroy
    head 204
  end

  def reset
    current_user.blocks.destroy_all
    current_user.tags.destroy_all

    Block.create!(day: 1, status: 'pending', user_id: current_user.id, blockDate: (Time.parse(Time.now.strftime("%Y-%m-%d")).utc.to_i*1000), fire: 'None')
  end
  private

  def user_params
    params.permit(:email, :password, :password_confirmation, :first_name, :last_name)
  end
end
