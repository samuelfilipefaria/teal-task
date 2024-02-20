<template lang="pug">
h1(style="text-align: center;") Calendar
el-calendar(ref="mycal" v-model="selectedDate")
h1 {{ dialogTitle }}:
ul
  li(v-for="task in tasksForTheDay" :key="task.id") {{ task.title }} | Estado atual: {{ getColumnName(task.kanban_column_id) }}
</template>

<script>
import axios from "axios";

export default {
  name: "CalendarPage",
  data() {
    return {
      selectedDate: new Date(),
      dialogVisible: false,
      tasksForTheDay: [],
      isLoading: true,
      columns: [],
    };
  },
  computed: {
    dialogTitle() {
      return `Tarefas com vencimento em ${this.formattedSelectedDate}`;
    },
    formattedSelectedDate() {
      return `${this.selectedDate.getDate()}/
      ${this.selectedDate.getMonth() + 1}/${this.selectedDate.getFullYear()}`;
    },
  },
  watch: {
    selectedDate() {
      this.loadTasksForTheDay();
    },
  },
  methods: {
    getColumnName(columnId) {
      return this.columns.find((column) => column.id == columnId).title;
    },
    areTheSameDate(due_date) {
      let selectedDateDay = this.selectedDate.getDate();
      let selectedDateMonth = this.selectedDate.getMonth() + 1;
      let selectedDateYear = this.selectedDate.getFullYear();

      let dueDateDay = due_date.split("-")[2];
      let dueDateMonth = due_date.split("-")[1];
      let dueDateYear = due_date.split("-")[0];

      if (
        selectedDateDay == parseInt(dueDateDay) &&
        selectedDateMonth == parseInt(dueDateMonth) &&
        selectedDateYear == parseInt(dueDateYear)
      ) {
        return true;
      }

      return false;
    },
    showTasks() {
      this.dialogVisible = true;
    },
    async loadTasksForTheDay() {
      try {
        this.isLoading = true;
        this.tasksForTheDay = [];
        const response = await axios.get("http://127.0.0.1:3000/kanban_cards");
        this.tasksForTheDay = response.data.filter((card) =>
          this.areTheSameDate(card.due_date)
        );
        this.isLoading = false;
      } catch (error) {
        console.error(error);
      }
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
  },
  mounted() {
    this.loadColumns();
    this.loadTasksForTheDay();
  },
};
</script>
