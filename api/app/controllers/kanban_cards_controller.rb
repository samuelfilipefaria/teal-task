class KanbanCardsController < ApplicationController
  def index
    cards = KanbanCard.all
    render json: cards, status: 200
  end

  def show
    card = KanbanCard.find(params[:id])

    if card
      render json: card, status: 200
    else
      render json: {error: "Cartão não encontrado!"}
    end
  end

  def create
    new_card = KanbanCard.new(
      kanban_column: KanbanColumn.find(params[:kanban_column_id]),
      title: params[:title],
      description: params[:description],
      position: cards_last_position + 1,
      due_date: params[:due_date],
    )

    if new_card.save
      render json: new_card, status: 200
    else
      render json: {error: "Erro ao criar cartão!"}
    end
  end

  def update
    card = KanbanCard.find(params[:id])

    unless card
      render json: {error: "Cartão não encontrado!"}
      return
    end

    if params[:position]
      card.update(
        kanban_column: card.kanban_column,
        title: card.title,
        description: card.description,
        position: params[:position],
        due_date: card.due_date,
      )
    else
      card.update(
        kanban_column: KanbanColumn.find(params[:kanban_column_id]),
        title: params[:title],
        description: params[:description],
        position: card.position,
        due_date: params[:due_date],
      )
    end
  end

  def destroy
    card = KanbanCard.find(params[:id])

    unless card
      render json: {error: "Cartão não encontrado!"}
      return
    end

    decrease_position_on_the_posterior_cards(card)
    card.destroy
  end

  def decrease_position_on_the_posterior_cards(card)
    cards_with_larger_position = KanbanCard.all.select {|comparing_card| comparing_card.position > card.position}
    cards_with_larger_position.each {|comparing_card| comparing_card.update(position: comparing_card.position - 1)}
  end

  def cards_last_position
    cards_positions = KanbanCard.all.map {|card| card.position}
    cards_positions.max || 0
  end
end
