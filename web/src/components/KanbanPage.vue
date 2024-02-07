<template lang="pug">
h1(style="text-align: center;") Kanban
kanban-board(
  :stages="columns"
  :blocks="cards"
  @openNewCardForm="openNewCardForm()"
  @openNewColumnForm="openNewColumnForm()"
  @update-block="updateBlock"
)
el-dialog(v-model='dialogCardFormVisible' title='Novo cartão' width='500')
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
      el-button.custom-button(@click="createCard" size="large")
        box-icon(name="plus" color="white")

el-dialog(v-model='dialogColumnFormVisible' title='Nova coluna' width='500')
  el-form
    el-form-item
      el-input(v-model="columnFormData.title" placeholder="Título")
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
</template>

<script>
export default {
  name: "KanbanPage",
  data() {
    return {
      columns: JSON.parse(window.localStorage.getItem("columns")) || [],
      cards: JSON.parse(window.localStorage.getItem("cards")) || [],
      dialogCardFormVisible: false,
      dialogColumnFormVisible: false,
      cardFormData: {
        title: "",
        description: "",
        status: "",
        dueDate: new Date(),
      },
      columnFormData: {
        title: "",
        color: "",
      },
    };
  },
  methods: {
    updateBlock(blockId, newState) {
      const foundCard = this.cards.find((card) => card.id == blockId);
      foundCard.status = newState;
      window.localStorage.setItem("cards", JSON.stringify(this.cards));
    },
    card_click() {
      console.log("clicou!");
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
      });
      window.localStorage.setItem("columns", JSON.stringify(this.columns));
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
        dueDate: this.cardFormData.dueDate,
      };

      if (cards_ids.length == 0) {
        newCard.id = 1;
      } else {
        const greatest_card_id = Math.max(...cards_ids);
        newCard.id = greatest_card_id + 1;
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
  },
};
</script>

<style lang="scss">
@import "../assets/css/kanban.scss";
</style>
