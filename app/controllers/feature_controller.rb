class FeatureController < ApplicationController

  def new
  end

  def show
    @feature = params[:id]

    @percentage = redis_connection.get("feature:#{@feature}:percentage")
    @users = redis_connection.smembers("feature:#{@feature}:users")
  end

  def create
    redis_connection.set("feature:#{params[:feature]}:percentage", params[:percentage])
    redis_connection.sadd("feature:#{params[:feature]}:users", params[:users]) if params[:users]

    redirect_to controller: :dashboard, action: :index
  end

  def destroy
    redis_connection.del("feature:#{params[:id]}:percentage")
    redis_connection.del("feature:#{params[:id]}:users")

    render json: { feature: params[:id] }, status: 200
  end

  def add_user
    redis_connection.sadd("feature:#{params[:id]}:users", params[:user])
    render json: {user: params[:user]}, status: 200
  end

  def delete_user
    redis_connection.srem("feature:#{params[:id]}:users", params[:user])
    render :nothing, status: 200
  end

  def update_percentage
    redis_connection.set("feature:#{params[:id]}:percentage", params[:range])
  end

end
