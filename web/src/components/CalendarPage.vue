<template lang="pug">
el-calendar(ref="mycal" v-model="selectedDate")
</template>

<script>
export default {
  name: "CalendarPage",
  data() {
    return {
      selectedDate: new Date(),
    };
  },
  wacth: {
    selectedDate() {
      console.log(`mudou`);
    },
  },
  mounted() {
    console.log(this.$refs.mycal.value);
  },
};
</script>
