<template lang="pug">
h1(style="text-align: center;") Kanban
kanban-board(
  :stages="stages"
  :blocks="blocks"
  @openNewCardForm="openNewCardForm()"
  @openNewColumnForm="openNewColumnForm()"
  @update-block="updateBlock"
)
el-dialog(v-model='dialogCardFormVisible' title='Novo cartão' width='500')
  form
    el-form-item
      el-input(v-model="cardFormData.title" placeholder="Título")
    el-form-item
      el-input(type="textarea" v-model="cardFormData.description" placeholder="Descrição")
    el-form-item
      el-select(v-model='cardFormData.state' placeholder='Coluna')
        el-option(v-for='stage in stages' :key='stage' :label='stage' :value='stage')
    el-form-item
      el-date-picker(v-model='cardFormData.dueDate' type='date' placeholder='Data de entrega')

el-dialog(v-model='dialogColumnFormVisible' title='Nova coluna' width='500')
  form
    el-form-item
      el-input(v-model="columnFormData.title" placeholder="Título")
    el-form-item
      el-select(v-model="columnFormData.color" placeholder="Cor")
        el-option.bolder(label="Teal" value="#008080" style="color: #008080;")
        el-option.bolder(label="Green" value="#67C23A" style="color: #67C23A;")
        el-option.bolder(label="Gray" value="#909399" style="color: #909399;")
        el-option.bolder(label="Orange" value="#E6A23C" style="color: #E6A23C;")
        el-option.bolder(label="Red" value="#F56C6C" style="color: #F56C6C;")
</template>

<script>
export default {
  name: "KanbanPage",
  data() {
    return {
      stages: [
        {
          title: "coluna 1",
          color: "red",
        },
        {
          title: "coluna 2",
          color: "green",
        },
        {
          title: "coluna 3",
          color: "red",
        },
        {
          title: "coluna 4",
          color: "red",
        },
        {
          title: "coluna 5",
          color: "red",
        },
        {
          title: "coluna 6",
          color: "blue",
        },
      ],
      blocks: [
        {
          id: 1,
          status: "coluna 1",
          title: "Cartão 1",
        },
        {
          id: 2,
          status: "coluna 1",
          title: "Cartão 2",
        },
      ],
      dialogCardFormVisible: false,
      dialogColumnFormVisible: false,
      cardFormData: {
        title: "",
        description: "",
        state: "",
        dueDate: new Date(),
      },
      columnFormData: {
        title: "",
        color: "",
      },
    };
  },
  methods: {
    updateBlock(id, status) {
      console.log("mudou!");
      this.blocks.find((b) => b.id === Number(id)).status = status;
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
  },
};
</script>

<style lang="scss">
@import "../assets/css/kanban.scss";
</style>
