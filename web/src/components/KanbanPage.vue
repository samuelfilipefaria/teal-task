<template lang="pug">
h1(style="text-align: center;") Kanban
kanban-board(
  :stages="orderedColumns()"
  :blocks="cards"
  @openCard="openCard"
  @openNewCardForm="openNewCardForm()"
  @openNewColumnForm="openNewColumnForm()"
  @update-block="updateBlock"
)
el-dialog(v-model='dialogCardFormVisible' :title="dialogCardFormTitle" width='500')
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

el-dialog(v-model='dialogColumnFormVisible' title='Nova coluna' width='500')
  el-form
    el-form-item
      el-input(v-model="columnFormData.title" placeholder="Título")
    el-form-item
      el-input(v-model="columnFormData.position" placeholder="Posição")
    el-form-item
      el-select(v-model="columnFormData.color" placeholder="Cor")
        el-option.bolder(label="Teal" value="#008080" style="color: #008080;")
        el-option.bolder(label="Green" value="#67C23A" style="color: #67C23A;")
        el-option.bolder(label="Gray" value="#909399" style="color: #909399;")
        el-option.bolder(label="Orange" value="#E6A23C" style="color: #E6A23C;")
        el-option.bolder(label="Red" value="#F56C6C" style="color: #F56C6C;")
    el-form-item
      el-button.custom-button(@click="createColumn" size="large")
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
</template>

<script>
export default {
  name: "KanbanPage",
  data() {
    return {
      currentCard: {},
      columns: JSON.parse(window.localStorage.getItem("columns")) || [],
      cards: JSON.parse(window.localStorage.getItem("cards")) || [],
      dialogCardFormVisible: false,
      dialogColumnFormVisible: false,
      dialogShowCard: false,
      confirmationDeletionCardDialog: false,
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
  },
  methods: {
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
      this.columns.push({
        title: this.columnFormData.title,
        color: this.columnFormData.color,
        position: this.columnFormData.position,
      });
      window.localStorage.setItem("columns", JSON.stringify(this.columns));
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
    },
    createCard() {
      this.saveCard();
      this.cleanCardForm();
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
    openCard(cardId) {
      this.currentCard = this.cards.find((card) => card.id == cardId);
      this.dialogShowCard = true;
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
