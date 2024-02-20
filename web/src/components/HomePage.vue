<template lang="pug">
h1(style="text-align: center;") Home page
h2 Olá usuário(a)!
ul
  li Data atual: {{ formattedSelectedDate }}
  li Quantidade de tags cadastradas: {{ numberOfTags }}
  li Quantidade de tarefas pendentes: 5
</template>

<script>
export default {
  name: "HomePage",
  computed: {
    numberOfTags() {
      return (JSON.parse(window.localStorage.getItem("tags")) || []).length;
    },
    formattedSelectedDate() {
      const currentDate = new Date();
      return `${currentDate.getDate()}/${currentDate.getMonth()}/${currentDate.getFullYear()}`;
    },
  },
  mounted() {
    if (!localStorage.getItem("loggedUserId")) {
      alert(
        "É preciso estar logado em uma conta para usar esta funcionalidade!"
      );
      window.location.href = "/account";
    }
  },
};
</script>
