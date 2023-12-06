<template lang="pug">
h1(style="text-align: center;") Tags
div(style="text-align: center;")
  el-form(:inline="true" :model="tagForm" label-width="120px")
    el-form-item
      el-input(v-model="tagForm.text" placeholder="Text")
    el-form-item
      el-select(v-model="tagForm.color" placeholder="Color")
        el-option(label="Blue" value="blue")
        el-option(label="Red" value="red")
    el-form-item
      el-button.custom-button(@click="")
        box-icon(name="check" color="white")
</template>

<script>
import { ref } from "vue";

export default {
  name: "TagsPage",
  data() {
    return {
      tagForm: {
        text: "",
        color: "",
      },
      dialogVisible: ref(false),
    };
  },
  methods: {
    createTag() {
      alert(this.tagForm.text);
      this.dialogVisible = false;
    },
  },
};
</script>
