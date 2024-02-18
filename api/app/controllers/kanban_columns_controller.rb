class KanbanColumnsController < ApplicationController
  def index
    columns = KanbanColumn.all
    render json: columns, status: 200
  end

  def show
    column = KanbanColumn.find(params[:id])

    if column
      render json: column, status: 200
    else
      render json: {error: "Coluna não encontrada!"}
    end
  end

  def create
    new_column = KanbanColumn.new(
      title: params[:title],
      color: params[:color],
      position: params[:position]
    )

    if new_column.save
      render json: new_column, status: 200
    else
      render json: {error: "Erro ao criar coluna!"}
    end
  end

  def update
    column = KanbanColumn.find(params[:id])

    unless column
      render json: {error: "Coluna não encontrada!"}
      return
    end

    column.update(
      title: params[:title],
      color: params[:color],
      position: params[:position]
    )
  end

  def destroy
    column = KanbanColumn.find(params[:id])

    unless column
      render json: {error: "Coluna não encontrada!"}
      return
    end

    column.destroy
  end
end
