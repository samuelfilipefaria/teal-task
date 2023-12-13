<template lang="pug">
h1(style="text-align: center;") Calendar
el-calendar(ref="mycal" v-model="selectedDate" @click="showTasks")
el-dialog(
  v-model="dialogVisible"
  :title="dialogTitle"
  width="30%"
)
  ul
    li Terminar trabalho faculdade
    li Limpar quarto
    li Fazer exercícios
    li Pegar carro no mecânico
</template>

<script>
export default {
  name: "CalendarPage",
  data() {
    return {
      selectedDate: new Date(),
      dialogVisible: false,
    };
  },
  computed: {
    dialogTitle() {
      return `Tarefas agendadas para ${this.formattedSelectedDate}`;
    },
    formattedSelectedDate() {
      return `${this.selectedDate.getDate()}/${this.selectedDate.getMonth()}/${this.selectedDate.getFullYear()}`;
    },
  },
  methods: {
    showTasks() {
      this.dialogVisible = true;
    },
  },
};
</script>
