<template lang="pug">
h1(style="text-align: center;") Kanban
div
  div(style="display: inline-block;")
    kanban-board(
      v-if="columns.length > 0"
      :stages="orderedColumns()"
      :blocks="cards"
      @openCard="openCard"
      @openNewCardForm="openNewCardForm()"
      @update-block="updateBlock"
      @editColumn="editColumn"
      @deleteColumn="showDeleteColumnConfirmationDialog"
    )
  div(style="display: inline-block;")
    el-button.custom-button(@click="openNewColumnForm()" size='large')
      box-icon(name='list-plus' color='white')

el-dialog(v-model='dialogCardFormVisible' :title="dialogCardFormTitle" width='500' fullscreen)
  el-form
    el-form-item
      el-input(v-model="cardFormData.title" placeholder="Título")
    el-form-item
      el-input(type="textarea" v-model="cardFormData.description" placeholder="Descrição")
    el-form-item
      el-select(v-model='cardFormData.status' placeholder='Coluna')
        el-option(v-for='column in columns' :key='column.id' :label='column.title' :value='column.title')
    el-form-item
      el-date-picker(v-model='cardFormData.due_date' type='date' placeholder='Data de entrega')
    el-form-item
      el-select(v-model='tagsIdsOnCard' multiple placeholder='Tags' style='width: 240px')
        el-option(v-for='tag in tags' :key='tag.id' :label='tag.label' :value='tag.id')
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
      span(style="margin-left: 5px;") Atenção: a posição de uma coluna afeta todas as outras
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
  p {{ cardColumnTitle(currentCard) }}

  h2 Data de entrega
  p {{ dateInBrazilianFormat }}

  h2 Tags
  tr(v-for="tag in currentCard.tags" :key="tag.id")
    td
      el-tag.custom-tag(:type='tag.color' effect="dark" size="large" style="font-weight: bold;") {{ tag.label }}

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
import axios from "axios";

export default {
  name: "KanbanPage",
  data() {
    return {
      tagsIdsOnCard: [],
      currentCard: {},
      currentColumn: {},
      oldColumn: {},
      columns: [],
      cards: [],
      tags: [],
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
        due_date: new Date(),
      },
      columnFormData: {
        title: "",
        color: "",
        position: "",
      },
      isEditingColumn: false,
      isEditingCard: false,
      isLoading: true,
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
          due_date: new Date(),
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
      const date = new Date(this.currentCard.due_date);

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
    cardColumnTitle(card) {
      return this.columns.find((column) => column.id == card.kanban_column_id)
        .title;
    },
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

      axios
        .delete("http://127.0.0.1:3000/kanban_columns/" + this.currentColumn.id)
        .then(function (response) {
          console.log(response);
        })
        .catch(function (error) {
          console.log(error);
        });

      window.location.reload();
    },
    editCard() {
      this.isEditingCard = true;
      this.cardFormData = this.currentCard;
      this.dialogCardFormVisible = true;
    },
    deleteCard() {
      this.confirmationDeletionCardDialog = false;
      this.dialogShowCard = false;

      axios
        .delete("http://127.0.0.1:3000/kanban_cards/" + this.currentCard.id)
        .then(function (response) {
          console.log(response);
        })
        .catch(function (error) {
          console.log(error);
        });

      window.location.reload();
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
      axios
        .put("http://127.0.0.1:3000/kanban_cards/" + blockId, {
          kanban_column_id: this.columns.find(
            (column) => column.title == newState
          ).id,
          position: index + 1,
        })
        .then(function (response) {
          console.log(response);
        })
        .catch(function (error) {
          console.log(error);
        });
    },
    openNewCardForm() {
      this.dialogCardFormVisible = true;
    },
    openNewColumnForm() {
      this.dialogColumnFormVisible = true;
    },
    createColumn() {
      axios
        .post("http://127.0.0.1:3000/kanban_columns", {
          title: this.columnFormData.title,
          color: this.columnFormData.color,
          position: this.columnFormData.position,
        })
        .then(function (response) {
          console.log(response);
        })
        .catch(function (error) {
          console.log(error);
        });

      window.location.reload();
    },
    saveColumnEdition() {
      axios
        .put("http://127.0.0.1:3000/kanban_columns/" + this.columnFormData.id, {
          title: this.columnFormData.title,
          color: this.columnFormData.color,
          position: this.columnFormData.position,
        })
        .then(function (response) {
          console.log(response);
        })
        .catch(function (error) {
          console.log(error);
        });

      window.location.reload();
    },
    saveCardEdition() {
      axios
        .put("http://127.0.0.1:3000/kanban_cards/" + this.currentCard.id, {
          kanban_column_id: this.columns.find(
            (column) => column.title == this.cardFormData.status
          ).id,
          title: this.cardFormData.title,
          description: this.cardFormData.description,
          due_date: this.cardFormData.due_date,
          tags_ids: this.tagsIdsOnCard,
        })
        .then(function (response) {
          console.log(response);
        })
        .catch(function (error) {
          console.log(error);
        });

      window.location.reload();
    },
    createCard() {
      axios
        .post("http://127.0.0.1:3000/kanban_cards/", {
          kanban_column_id: this.columns.find(
            (column) => column.title == this.cardFormData.status
          ).id,
          title: this.cardFormData.title,
          description: this.cardFormData.description,
          due_date: this.cardFormData.due_date,
          tags_ids: this.tagsIdsOnCard,
        })
        .then(function (response) {
          console.log(response);
        })
        .catch(function (error) {
          console.log(error);
        });

      window.location.reload();
    },
    saveCard() {
      const cards_ids = this.cards.map((card) => card.id);

      let newCard = {
        id: null,
        title: this.cardFormData.title,
        description: this.cardFormData.description,
        status: this.cardFormData.status,
        position: 0,
        due_date: this.cardFormData.due_date,
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
      this.cardFormData.due_date = new Date();
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
        due_date: new Date(),
      };
      this.columnFormData = {
        title: "",
        color: "",
        position: "",
      };
      this.isEditingColumn = false;
      this.isEditingCard = false;
    },
    async loadColumns() {
      try {
        this.isLoading = true;
        this.columns = [];
        const response = await axios.get(
          "http://127.0.0.1:3000/kanban_columns"
        );
        this.columns = response.data;
        this.isLoading = false;
      } catch (error) {
        console.error(error);
      }
    },
    async loadCards() {
      try {
        this.isLoading = true;
        this.cards = [];
        const response = await axios.get("http://127.0.0.1:3000/kanban_cards");
        this.cards = response.data;
        console.log(this.cards);
        this.isLoading = false;
      } catch (error) {
        console.error(error);
      }
    },
    async loadTags() {
      try {
        this.isLoading = true;
        this.tags = [];
        const response = await axios.get("http://127.0.0.1:3000/tags");
        this.tags = response.data;
        this.isLoading = false;
      } catch (error) {
        console.error(error);
      }
    },
  },
  mounted() {
    this.loadColumns();
    this.loadCards();
    this.loadTags();
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
