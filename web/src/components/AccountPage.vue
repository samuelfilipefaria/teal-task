<template lang="pug">
h1(style="text-align: center;") Conta
el-tabs(type='border-card')
  el-tab-pane(label='Cadastro')
    h4 Cadastro
    el-form
      el-form-item(required)
        el-input(v-model="user.name" placeholder="Nome")
      el-form-item(required)
        el-input(v-model="user.email" placeholder="E-mail")
      el-form-item(required)
        el-input(v-model="user.password" placeholder="Senha")
      el-form-item
        el-button.custom-button(@click="createAccount" size="large") Criar conta
  el-tab-pane(label='Login')
    h4 Login
    el-form
      el-form-item(required)
        el-input(v-model="user.email" placeholder="E-mail")
      el-form-item(required)
        el-input(v-model="user.password" placeholder="Senha")
      el-form-item
        el-button.custom-button(@click="loginAccount" size="large") Entrar na conta
</template>

<script>
export default {
  name: "AccountPage",
  data() {
    return {
      user: {
        name: "",
        email: "",
        password: "",
      },
    };
  },
};
</script>

<style scoped></style>
