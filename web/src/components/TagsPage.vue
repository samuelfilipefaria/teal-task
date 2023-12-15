<template lang="pug">
h1(style="text-align: center;") Tags
div(style="text-align: center;")
  el-form(:inline="true" :model="tagForm" label-width="120px")
    el-form-item
      el-input(v-model="tagForm.text" placeholder="Text")
    el-form-item
      el-select(v-model="tagForm.color" placeholder="Color")
        el-option.bolder(label="Teal" value="" style="color: #008080;")
        el-option.bolder(label="Green" value="success" style="color: #67C23A;")
        el-option.bolder(label="Gray" value="info" style="color: #909399;")
        el-option.bolder(label="Orange" value="warning" style="color: #E6A23C;")
        el-option.bolder(label="Red" value="danger" style="color: #F56C6C;")
    el-form-item
      el-button.custom-button(@click="createTag")
        box-icon(name="check" color="white")

  div(v-for="tag in tags" :key="tag.text")
    el-tag(:type='tag.color' effect="dark" size="large" style="margin-bottom: 10px; font-size: 20px; width: 200px;") {{ tag.text }}
    br
</template>

<script>
export default {
  name: "TagsPage",
  data() {
    return {
      tagForm: {
        text: "",
        color: "",
      },
      tags: JSON.parse(window.localStorage.getItem("tags")) || [],
    };
  },
  methods: {
    createTag() {
      this.tags.push({
        text: this.tagForm.text,
        color: this.tagForm.color,
      });
      window.localStorage.setItem("tags", JSON.stringify(this.tags));
      this.cleanTagForm();
    },
    cleanTagForm() {
      this.tagForm.text = this.tagForm.color = "";
    },
  },
};
</script>
