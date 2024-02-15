<template lang="pug">
h1(style="text-align: center;") Kanban
kanban-board(
  :stages="orderedColumns()"
  :blocks="cards"
  @openCard="openCard"
  @openNewCardForm="openNewCardForm()"
  @openNewColumnForm="openNewColumnForm()"
  @update-block="updateBlock"
  @editColumn="editColumn"
  @deleteColumn="showDeleteColumnConfirmationDialog"
)
el-dialog(v-model='dialogCardFormVisible' :title="dialogCardFormTitle" width='500' fullscreen)
  el-form
    el-form-item
      el-input(v-model="cardFormData.title" placeholder="Título")
    el-form-item
      el-input(type="textarea" v-model="cardFormData.description" placeholder="Descrição")
    el-form-item
      el-select(v-model='cardFormData.status' placeholder='Coluna')
        el-option(v-for='column in columns' :key='column.title' :label='column.title' :value='column.title')
    el-form-item
      el-date-picker(v-model='cardFormData.dueDate' type='date' placeholder='Data de entrega')
    el-form-item
      el-button.custom-button(v-if="isEditingCard" @click="saveCardEdition" size="large")
        box-icon(name="edit" color="white")
      el-button.custom-button(v-else @click="createCard" size="large")
        box-icon(name="plus" color="white")

el-dialog(v-model='dialogColumnFormVisible' title='Nova coluna' width='500' fullscreen)
  el-form
    el-form-item
      el-input(v-model="columnFormData.title" placeholder="Título")
    el-form-item
      el-select(v-model='columnFormData.position' placeholder='Posição')
        el-option(v-for='position in columnsPositions' :key='position' :label='position' :value='position')
    el-form-item
      el-select(v-model="columnFormData.color" placeholder="Cor")
        el-option.bolder(label="Teal" value="#008080" style="color: #008080;")
        el-option.bolder(label="Green" value="#67C23A" style="color: #67C23A;")
        el-option.bolder(label="Gray" value="#909399" style="color: #909399;")
        el-option.bolder(label="Orange" value="#E6A23C" style="color: #E6A23C;")
        el-option.bolder(label="Red" value="#F56C6C" style="color: #F56C6C;")
    el-form-item
      el-button.custom-button(v-if="isEditingColumn" @click="saveColumnEdition" size="large")
        box-icon(name="edit" color="white")
      el-button.custom-button(v-else @click="createColumn" size="large")
        box-icon(name="plus" color="white")

el-dialog(v-model='dialogShowCard' :title='currentCard.title' width='500')
  h2 Descrição
  p(v-if="currentCard.description.trim() != ''") {{ currentCard.description }}
  p(v-else style="font-style: italic; font-weight: bold;") Sem descrição

  h2 Estado
  p {{ currentCard.status }}

  h2 Data de entrega
  p {{ dateInBrazilianFormat }}

  template(#footer)
    .dialog-footer
      box-icon.tag-action-icon(@click="editCard()" type="solid" name="edit" color="teal")
      box-icon.tag-action-icon(@click="confirmationDeletionCardDialog = true" type="solid" name="trash" color="red")

el-dialog(v-model='confirmationDeletionCardDialog' title='Confirmação' width='500')
  p Tem certeza que deseja deletar esse cartão? Essa ação não poderá ser desfeita.
  div(style="text-align: center;")
    el-button(@click="deleteCard()") Sim

el-dialog(v-model='confirmationDeletionColumnDialog' title='Confirmação' width='500')
  p Tem certeza que deseja deletar essa coluna? <b>TODOS</b> os cartões presentes nela serão também deletados. Essa ação não poderá ser desfeita.
  div(style="text-align: center;")
    el-button(@click="deleteColumn()") Sim
</template>

<script>
export default {
  name: "KanbanPage",
  data() {
    return {
      currentCard: {},
      currentColumn: {},
      oldColumn: {},
      columns: JSON.parse(window.localStorage.getItem("columns")) || [],
      cards: JSON.parse(window.localStorage.getItem("cards")) || [],
      dialogCardFormVisible: false,
      dialogColumnFormVisible: false,
      dialogShowCard: false,
      confirmationDeletionCardDialog: false,
      confirmationDeletionColumnDialog: false,
      cardFormData: {
        title: "",
        description: "",
        status: "",
        position: "",
        dueDate: new Date(),
      },
      columnFormData: {
        title: "",
        color: "",
        position: "",
      },
      isEditingColumn: false,
      isEditingCard: false,
    };
  },
  watch: {
    dialogCardFormVisible(visibility) {
      if (visibility == false && this.isEditingCard) {
        this.cardFormData = {
          title: "",
          description: "",
          status: "",
          position: "",
          dueDate: new Date(),
        };

        this.isEditingCard = false;
        this.cleanALLAuxiliaryVariables();
      }
    },
    dialogColumnFormVisible(visibility) {
      if (visibility == false && this.isEditingColumn) {
        this.columnFormData = {
          title: "",
          color: "",
          position: "",
        };

        this.oldColumn = {};
        this.isEditingColumn = false;
        this.cleanALLAuxiliaryVariables();
      }
    },
  },
  computed: {
    dialogCardFormTitle() {
      return this.isEditingCard ? "Editando cartão" : "Novo cartão";
    },
    dateInBrazilianFormat() {
      const date = new Date(this.currentCard.dueDate);

      const day = date.getDate();
      const month = date.getMonth() + 1;
      const year = date.getFullYear();

      return `${day}/${month}/${year}`;
    },
    columnsPositions() {
      const lastPosition = Math.max(
        ...this.columns.map((column) => column.position)
      );

      if (this.isEditingColumn) {
        return Array.from(
          { length: lastPosition },
          (value, index) => index + 1
        );
      } else {
        if (Number.isInteger(lastPosition)) {
          return Array.from(
            { length: lastPosition + 1 },
            (value, index) => index + 1
          );
        } else {
          return [1];
        }
      }
    },
  },
  methods: {
    showDeleteColumnConfirmationDialog(column) {
      this.currentColumn = column;
      this.confirmationDeletionColumnDialog = true;
    },
    editColumn(column) {
      this.oldColumn = { ...column };
      this.isEditingColumn = true;
      this.columnFormData = column;
      this.dialogColumnFormVisible = true;
    },
    deleteColumn() {
      this.confirmationDeletionColumnDialog = false;

      const deletedColumnIndex = this.columns.findIndex(
        (comparingColumn) => comparingColumn.id == this.currentColumn.id
      );

      const columnsWithAGreaterPosition = this.columns.filter(
        (column) => column.position > this.currentColumn.position
      );

      columnsWithAGreaterPosition.forEach(function decreaseOnePosition(column) {
        column.position--;
      });

      const cardsToDelete = this.cards.filter(
        (card) => card.status == this.currentColumn.title
      );

      for (let i = 0; i < cardsToDelete.length; i++) {
        let deletedCardIndex = this.cards.findIndex(
          (comparingCard) => comparingCard.id == cardsToDelete[i].id
        );

        this.cards.splice(deletedCardIndex, 1);
      }

      window.localStorage.setItem("cards", JSON.stringify(this.cards));

      this.columns.splice(deletedColumnIndex, 1);

      window.localStorage.setItem("columns", JSON.stringify(this.columns));
    },
    editCard() {
      this.isEditingCard = true;
      this.cardFormData = this.currentCard;
      this.dialogCardFormVisible = true;
    },
    deleteCard() {
      this.confirmationDeletionCardDialog = false;
      this.dialogShowCard = false;

      const deletedCardIndex = this.cards.findIndex(
        (card) => card.id == this.currentCard.id
      );

      const cardsWithAGreaterPosition = this.cards.filter(
        (card) => card.position > this.currentCard.position
      );

      cardsWithAGreaterPosition.forEach(function decreaseOnePosition(card) {
        card.position--;
      });

      this.cards.splice(deletedCardIndex, 1);

      window.localStorage.setItem("cards", JSON.stringify(this.cards));
    },
    orderedColumns() {
      return this.columns.sort(function (a, b) {
        if (a.position < b.position) {
          return -1;
        }

        if (a.position > b.position) {
          return 1;
        }
      });
    },
    updateBlock(blockId, newState, index) {
      const foundCard = this.cards.find((card) => card.id == blockId);

      if (newState == foundCard.status) {
        if (index < foundCard.position) {
          this.cards
            .filter((card) => card.status == foundCard.status)
            .forEach(function (card) {
              if (
                card.position < foundCard.position &&
                card.position >= index
              ) {
                card.position++;
              }
            });
        } else if (index > foundCard.position) {
          this.cards
            .filter((card) => card.status == foundCard.status)
            .forEach(function (card) {
              if (
                card.position > foundCard.position &&
                card.position <= index
              ) {
                card.position--;
              }
            });
        }
      } else {
        this.cards
          .filter((card) => card.status == foundCard.status)
          .forEach(function (card) {
            if (card.position > foundCard.position) {
              card.position--;
            }
          });
        this.cards
          .filter((card) => card.status == newState)
          .forEach(function (card) {
            if (card.position >= index) {
              card.position++;
            }
          });
      }

      foundCard.status = newState;
      foundCard.position = index;

      window.localStorage.setItem("cards", JSON.stringify(this.cards));
    },
    openNewCardForm() {
      this.dialogCardFormVisible = true;
    },
    openNewColumnForm() {
      this.dialogColumnFormVisible = true;
    },
    createColumn() {
      const columnsIds = this.columns.map((column) => column.id);

      let newColumn = {
        id: null,
        title: this.columnFormData.title,
        color: this.columnFormData.color,
        position: this.columnFormData.position,
      };

      const columnsWithAGreaterPosition = this.columns.filter(
        (column) => column.position >= newColumn.position
      );

      columnsWithAGreaterPosition.forEach(function increaseOnePosition(column) {
        column.position++;
      });

      if (columnsIds.length == 0) {
        newColumn.id = 1;
      } else {
        const greatestColumnId = Math.max(...columnsIds);
        newColumn.id = greatestColumnId + 1;
      }

      this.columns.push(newColumn);
      window.localStorage.setItem("columns", JSON.stringify(this.columns));
      this.cleanColumnForm();
      this.cleanALLAuxiliaryVariables();
    },
    saveColumnEdition() {
      const editedColumnIndex = this.columns.findIndex(
        (column) => column.id == this.columnFormData.id
      );

      const editedColumn = {
        id: this.columnFormData.id,
        title: this.columnFormData.title,
        color: this.columnFormData.color,
        position: this.columnFormData.position,
      };

      const oldTitle = this.oldColumn.title;
      const newTitle = editedColumn.title;

      if (oldTitle.trim() != newTitle.trim()) {
        const cardsToUpdate = this.cards.filter(
          (card) => card.status == oldTitle
        );

        cardsToUpdate.forEach(function changeColumnName(card) {
          card.status = newTitle.trim();
        });

        window.localStorage.setItem("cards", JSON.stringify(this.cards));
      }

      const oldPosition = this.oldColumn.position;
      const newPosition = editedColumn.position;

      if (oldPosition < newPosition) {
        const columnsToModify = this.columns.filter(
          (column) =>
            column.position <= newPosition && column.position > oldPosition
        );
        columnsToModify.forEach((column) => column.position--);
      }

      if (oldPosition > newPosition) {
        const columnsToModify = this.columns.filter(
          (column) =>
            column.position >= newPosition && column.position < oldPosition
        );
        columnsToModify.forEach((column) => column.position++);
      }

      this.columns.splice(editedColumnIndex, 1, editedColumn);

      window.localStorage.setItem("columns", JSON.stringify(this.columns));
      this.oldColumn = {};
      this.dialogColumnFormVisible = false;
      this.cleanColumnForm();
      this.cleanALLAuxiliaryVariables();
    },
    saveCardEdition() {
      const editedCardIndex = this.cards.findIndex(
        (card) => card.id == this.currentCard.id
      );

      const editedCard = {
        id: this.currentCard.id,
        title: this.cardFormData.title,
        description: this.cardFormData.description,
        status: this.cardFormData.status,
        position: this.cardFormData.position,
        dueDate: this.cardFormData.dueDate,
      };

      this.cards.splice(editedCardIndex, 1, editedCard);

      window.localStorage.setItem("cards", JSON.stringify(this.cards));
      this.dialogCardFormVisible = false;
      this.cleanALLAuxiliaryVariables();
    },
    createCard() {
      this.saveCard();
      this.cleanCardForm();
      this.cleanALLAuxiliaryVariables();
    },
    saveCard() {
      const cards_ids = this.cards.map((card) => card.id);

      let newCard = {
        id: null,
        title: this.cardFormData.title,
        description: this.cardFormData.description,
        status: this.cardFormData.status,
        position: 0,
        dueDate: this.cardFormData.dueDate,
      };

      if (cards_ids.length == 0) {
        newCard.id = 1;
      } else {
        const greatest_card_id = Math.max(...cards_ids);
        newCard.id = greatest_card_id + 1;
      }

      const lastPositionOnColumn = Math.max(
        ...this.cards
          .filter((card) => card.status == newCard.status)
          .map((card) => card.position)
      );

      if (Number.isInteger(lastPositionOnColumn)) {
        newCard.position = lastPositionOnColumn + 1;
      }

      this.cards.push(newCard);
      window.localStorage.setItem("cards", JSON.stringify(this.cards));
    },
    cleanCardForm() {
      this.cardFormData.title = "";
      this.cardFormData.description = "";
      this.cardFormData.status = "";
      this.cardFormData.dueDate = new Date();
    },
    cleanColumnForm() {
      this.columnFormData.title = "";
      this.columnFormData.position = "";
      this.columnFormData.color = "";
    },
    openCard(cardId) {
      this.currentCard = this.cards.find((card) => card.id == cardId);
      this.dialogShowCard = true;
    },
    cleanALLAuxiliaryVariables() {
      this.currentCard = {};
      this.currentColumn = {};
      this.oldColumn = {};
      this.cardFormData = {
        title: "",
        description: "",
        status: "",
        position: "",
        dueDate: new Date(),
      };
      this.columnFormData = {
        title: "",
        color: "",
        position: "",
      };
      this.isEditingColumn = false;
      this.isEditingCard = false;
    },
  },
};
</script>

<style lang="scss">
@import "../assets/css/kanban.scss";
</style>

<style scoped>
.tag-action-icon {
  margin-left: 10px;
  margin-top: 2px;
  cursor: pointer;
}
</style>
