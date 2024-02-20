class UsersController < ApplicationController
  def index
    users = User.all
    render json: users, status: 200
  end

  def show
    user = User.find(params[:id])

    if user
      render json: user, status: 200
    else
      render json: {error: "Usuário não encontrado!"}
    end
  end

  def create
    new_user = User.new(
      name: params[:name],
      email: params[:email],
      password: params[:password]
    )

    if new_user.save
      render json: new_user, status: 200
    else
      render json: {error: "Erro ao criar usuário!"}
    end
  end

  def update
    user = User.find(params[:id])

    unless user
      render json: {error: "Usuário não encontrado!"}
      return
    end

    user.update(
      name: params[:name],
      email: params[:email],
      password: params[:password]
    )
  end

  def destroy
    user = User.find(params[:id])

    unless user
      render json: {error: "Usuário não encontrado!"}
      return
    end

    user.destroy
  end
end
