class TagsController < ApplicationController
  def index
    tags = Tag.all
    render json: tags, status: 200
  end

  def show
    tag = Tag.find(params[:id])

    if tag
      render json: tag, status: 200
    else
      render json: {error: "Etiqueta não encontrada!"}
    end
  end

  def create
    new_tag = Tag.new(
      label: params[:label],
      color: params[:color],
      user: User.find(params[:user_id])
    )

    if new_tag.save
      render json: new_tag, status: 200
    else
      render json: {error: "Erro ao criar etiqueta!"}
    end
  end

  def update
    tag = Tag.find(params[:id])

    unless tag
      render json: {error: "Etiqueta não encontrada!"}
      return
    end

    tag.update(
      label: params[:label],
      color: params[:color]
    )
  end

  def destroy
    tag = Tag.find(params[:id])

    unless tag
      render json: {error: "Etiqueta não encontrada!"}
      return
    end

    tag.destroy
  end
end
