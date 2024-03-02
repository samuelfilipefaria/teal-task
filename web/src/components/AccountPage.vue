<template lang="pug">
h1(style="text-align: center;") Conta
div(v-if="areUserLogged && !isEditing" style="text-align: center;")
  h1(class="animate__animated animate__fadeInDown") Saudações {{ loggedUserName }} 👋️
  el-button.custom-button(class="animate__animated animate__bounceIn" @click="loadAccountEdition()" size="large") Editar conta
  el-button.custom-button(class="animate__animated animate__bounceIn" @click="deleteAccountConfirmationDialog = true" size="large") Deletar conta
  el-button.custom-button(class="animate__animated animate__bounceIn" @click="logoutAccount()" size="large") Sair da conta
el-tabs(v-if="areUserLogged && isEditing" type='border-card')
  el-tab-pane(label='Editar conta')
    h4 Editar conta
    el-form
      el-form-item(required)
        el-input(v-model="user.name" placeholder="Nome")
      el-form-item(required)
        el-input(v-model="user.email" placeholder="E-mail")
      el-form-item(required)
        el-input(v-model="user.password" type="password" placeholder="Senha")
      el-form-item
        el-button.custom-button(@click="editAccount()" size="large") Salvar edição

el-tabs(v-if="!areUserLogged && !isEditing" type='border-card')
  el-tab-pane(label='Cadastro')
    h4 Cadastro
    el-form
      el-form-item(required)
        el-input(v-model="user.name" placeholder="Nome")
      el-form-item(required)
        el-input(v-model="user.email" placeholder="E-mail")
      el-form-item(required)
        el-input(v-model="user.password" type="password" placeholder="Senha")
      el-form-item
        el-button.custom-button(@click="createAccount()" size="large") Criar conta
  el-tab-pane(label='Login')
    h4 Login
    el-form
      el-form-item(required)
        el-input(v-model="user.email" placeholder="E-mail")
      el-form-item(required)
        el-input(v-model="user.password" type="password" placeholder="Senha")
      el-form-item
        el-button.custom-button(@click="loginAccount()" size="large") Entrar na conta
el-dialog(v-model='invalidDataWarningDialog' title='Dados inválidos!' width='500')
  p Verifique os dados e tente novamente
el-dialog(v-model='deleteAccountConfirmationDialog' title='Confirmação' width='500')
  p Tem certeza que deseja deletar sua conta? TODOS os seus dados serão perdidos, essa ação não pode ser desfeita
  el-button(@click="deleteAccount()") Sim, quero deletar
</template>

<script>
import axios from "axios";

export default {
  name: "AccountPage",
  data() {
    return {
      user: {
        name: "",
        email: "",
        password: "",
      },
      invalidDataWarningDialog: false,
      deleteAccountConfirmationDialog: false,
      isEditing: false,
      loggedUserName: "",
    };
  },
  computed: {
    areUserLogged() {
      if (localStorage.getItem("loggedUserId")) return true;
      return false;
    },
  },
  methods: {
    async loadAccountEdition() {
      this.isEditing = true;

      try {
        const response = await axios.get(
          "http://127.0.0.1:3000/users/" + localStorage.getItem("loggedUserId")
        );
        this.user = response.data;
      } catch (error) {
        console.error(error);
        alert("Usuário não encontrado!");
      }
    },
    editAccount() {
      if (this.user.name == undefined || this.user.name.trim() == "") {
        this.invalidDataWarningDialog = true;
        return;
      }

      if (this.user.email == undefined || this.user.email.trim() == "") {
        this.invalidDataWarningDialog = true;
        return;
      }

      if (this.user.password == undefined || this.user.password.trim() == "") {
        this.invalidDataWarningDialog = true;
        return;
      }

      axios
        .put(
          "http://127.0.0.1:3000/users/" + localStorage.getItem("loggedUserId"),
          {
            name: this.user.name,
            email: this.user.email,
            password: this.user.password,
          }
        )
        .then(function (response) {
          console.log(response);
        })
        .catch(function (error) {
          console.log(error);
        });

      window.location.reload();
    },
    loginAccount() {
      if (this.user.email == undefined || this.user.email.trim() == "") {
        this.invalidDataWarningDialog = true;
        return;
      }

      if (this.user.password == undefined || this.user.password.trim() == "") {
        this.invalidDataWarningDialog = true;
        return;
      }

      axios
        .post("http://127.0.0.1:3000/users/login", {
          email: this.user.email,
          password: this.user.password,
        })
        .then(function (response) {
          console.log(response);
          localStorage.setItem("loggedUserId", response.data.id.toString());
          window.location.reload();
        })
        .catch(function (error) {
          console.log(error);
          alert("Usuário não encontrado!");
        });
    },
    createAccount() {
      if (this.user.name == undefined || this.user.name.trim() == "") {
        this.invalidDataWarningDialog = true;
        return;
      }

      if (this.user.email == undefined || this.user.email.trim() == "") {
        this.invalidDataWarningDialog = true;
        return;
      }

      if (this.user.password == undefined || this.user.password.trim() == "") {
        this.invalidDataWarningDialog = true;
        return;
      }

      axios
        .post("http://127.0.0.1:3000/users", {
          name: this.user.name,
          email: this.user.email,
          password: this.user.password,
        })
        .then(function (response) {
          console.log(response);
        })
        .catch(function (error) {
          console.log(error);
        });

      window.location.reload();
    },
    deleteAccount() {
      axios
        .delete(
          "http://127.0.0.1:3000/users/" + localStorage.getItem("loggedUserId")
        )
        .then(function (response) {
          console.log(response);
        })
        .catch(function (error) {
          console.log(error);
        });

      localStorage.clear();
      window.location.reload();
    },
    logoutAccount() {
      localStorage.clear();
      window.location.reload();
    },
    async loadLoggedUserName() {
      try {
        const response = await axios.get(
          "http://127.0.0.1:3000/users/" + localStorage.getItem("loggedUserId")
        );
        this.loggedUserName = response.data.name;
      } catch (error) {
        // console.error(error);
      }
    },
  },
  mounted() {
    this.loadLoggedUserName();
  },
};
</script>

<style scoped></style>
