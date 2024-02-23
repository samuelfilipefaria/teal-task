<template lang="pug">
h1(style="text-align: center;") Home page
h3(style="margin: 100px;" class="animate__animated animate__zoomIn") "Teal é uma cor azul esverdeada profunda, nomeada em homenagem à área colorida ao redor do olho do pássaro azul-petróleo comum. Seu código hexadecimal é #008080. Teal combina as propriedades calmantes do azul com as qualidades renovadoras do verde. É uma cor revitalizante e rejuvenescedora que também representa comunicação aberta e clareza de pensamento. Para os monges tibetanos, o azul-petróleo simboliza o infinito do mar e do céu, enquanto para os egípcios é a cor da verdade e da fé."
h1(style="margin: 100px; text-align: center;" class="animate__animated animate__zoomIn") O sistema visa ajudar na organização pessoal dos usuários para ajudá-los a alcançar a clareza de pensamento.
</template>

<script>
export default {
  name: "HomePage",
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
