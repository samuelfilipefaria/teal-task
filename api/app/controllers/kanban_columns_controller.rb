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
      position: params[:position],
      user: User.find(params[:user_id])
    )

    increase_position_on_the_posterior_columns(new_column)

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

    if column.position < params[:position]
      decrease_the_position_of_the_range_columns(column.position, params[:position])
    elsif column.position > params[:position]
      increase_the_position_of_the_range_columns(column.position, params[:position])
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

    decrease_position_on_the_posterior_columns(column)
    column.destroy
  end

  def decrease_the_position_of_the_range_columns(oldPosition, newPosition)
    range_columns = KanbanColumn.all.select {|comparing_column| comparing_column.position <= newPosition && comparing_column.position > oldPosition}
    range_columns.each {|comparing_column| comparing_column.update(position: comparing_column.position - 1)}
  end

  def increase_the_position_of_the_range_columns(oldPosition, newPosition)
    range_columns = KanbanColumn.all.select {|comparing_column| comparing_column.position >= newPosition && comparing_column.position < oldPosition}
    range_columns.each {|comparing_column| comparing_column.update(position: comparing_column.position + 1)}
  end

  def increase_position_on_the_posterior_columns(column)
    columns_with_larger_or_equal_position = KanbanColumn.all.select {|comparing_column| comparing_column.position >= column.position}
    columns_with_larger_or_equal_position.each {|comparing_column| comparing_column.update(position: comparing_column.position + 1)}
  end

  def decrease_position_on_the_posterior_columns(column)
    columns_with_larger_position = KanbanColumn.all.select {|comparing_column| comparing_column.position > column.position}
    columns_with_larger_position.each {|comparing_column| comparing_column.update(position: comparing_column.position - 1)}
  end

  def delete_cards(column)
    # delete cards here
  end
end
