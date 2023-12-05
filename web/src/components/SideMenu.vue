<template lang="pug">
h1.app-title Teal Task
el-menu(class="menu")
  router-link(to="/")
    el-menu-item(index="1")
      box-icon(class="menu-icon" name='home' type="solid" size="25px")
      template(#title) Home
  router-link(to="calendar")
    el-menu-item(index="2")
      box-icon(class="menu-icon" name='calendar' type="solid" size="25px")
      template(#title) Calendar
  router-link(to="kanban")
    el-menu-item(index="3")
      box-icon(class="menu-icon" name='dashboard' type="solid" size="25px")
      template(#title) Kanban
  router-link(to="tags")
    el-menu-item(index="4")
      box-icon(class="menu-icon" name='purchase-tag' type="solid" size="25px")
      template(#title) Tags
  router-link(to="pomodoro")
    el-menu-item(index="5")
      box-icon(class="menu-icon" name='timer' type="solid" size="25px")
      template(#title) Pomodoro
</template>

<script>
export default {
  name: "SideMenu",
};
</script>

<style scoped>
a:link {
  text-decoration: none;
}

.app-title {
  font-family: Edu Tas Beginner;
  color: #008080;
  font-size: 50px;
}

.menu {
  font-weight: bold;
}

.menu-icon {
  height: 40px;
  margin-bottom: 5px;
  margin-right: 10px;
  overflow: hidden;
}
</style>
