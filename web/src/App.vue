<template lang="pug">
el-row
  el-col.grid-content(:span='4')
    side-menu
  el-col.grid-content(:span='20')
    router-view
</template>

<script>
import SideMenu from "./components/SideMenu.vue";

export default {
  name: "App",
  components: {
    SideMenu,
  },
};
</script>

<style scoped>
.menu {
  font-weight: bold;
  width: 200px;
  height: 100%;
}

.menu-icon {
  margin-bottom: 15px;
  margin-right: 10px;
}
</style>
