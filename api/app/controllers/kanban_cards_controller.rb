class KanbanCardsController < ApplicationController
  def index
    cards = KanbanCard.all
    tags = KanbanCard.all.map {|card| card.tags}

    require 'json'
    cards = JSON.parse(cards.to_json)
    cards.each_with_index {|card, index| card["tags"] = JSON.parse(tags.to_json)[index]}

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
      position: last_position_in_the_same_column(params[:kanban_column_id]) + 1,
      due_date: params[:due_date],
      tags: Tag.find(params[:tags_ids]),
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
      if card.kanban_column_id == params[:kanban_column_id]

        if params[:position] > card.position
          decrease_cards_in_the_range(card.position, params[:position], card.kanban_column_id)
        end
        if params[:position] < card.position
          increase_cards_in_the_range(card.position, params[:position], card.kanban_column_id)
        end

      else
        decrease_position_on_the_posterior_cards(card)
        increase_position_on_the_posterior_cards_in_the_new_column(params[:position], params[:kanban_column_id])
      end

      card.update(
        kanban_column: KanbanColumn.find(params[:kanban_column_id]),
        title: card.title,
        description: card.description,
        position: params[:position],
        due_date: card.due_date,
        tags: card.tags,
      )
    else
      card.update(
        kanban_column: KanbanColumn.find(params[:kanban_column_id]),
        title: params[:title],
        description: params[:description],
        position: card.position,
        due_date: params[:due_date],
        tags: params[:tags_ids].length > 0 ? Tag.find(params[:tags_ids]) : card.tags,
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

  def decrease_cards_in_the_range(current_position, new_position, column_id)
    cards_in_the_range = KanbanCard.all.select {|comparing_card| comparing_card.kanban_column_id == column_id && comparing_card.position <= new_position && comparing_card.position > current_position}
    cards_in_the_range.each {|comparing_card| comparing_card.update(position: comparing_card.position - 1)}
  end

  def increase_cards_in_the_range(current_position, new_position, column_id)
    cards_in_the_range = KanbanCard.all.select {|comparing_card| comparing_card.kanban_column_id == column_id && comparing_card.position >= new_position && comparing_card.position < current_position}
    cards_in_the_range.each {|comparing_card| comparing_card.update(position: comparing_card.position + 1)}
  end

  def decrease_position_on_the_posterior_cards(card)
    cards_with_larger_position = KanbanCard.all.select {|comparing_card| comparing_card.kanban_column_id == card.kanban_column_id && comparing_card.position > card.position}
    cards_with_larger_position.each {|comparing_card| comparing_card.update(position: comparing_card.position - 1)}
  end

  def increase_position_on_the_posterior_cards_in_the_new_column(new_position, new_column_id)
    cards_with_larger_position = KanbanCard.all.select {|comparing_card| comparing_card.kanban_column_id == new_column_id && comparing_card.position >= new_position}
    cards_with_larger_position.each {|comparing_card| comparing_card.update(position: comparing_card.position + 1)}
  end

  def last_position_in_the_same_column(kanban_column_id)
    cards_positions = KanbanCard.all.select {|comparing_card| comparing_card.kanban_column_id == kanban_column_id}.map {|card| card.position}
    cards_positions.max || 0
  end
end
