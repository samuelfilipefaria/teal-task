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
      el-button.custom-button(@click="createTag")
        box-icon(name="check" color="white")

  ul
    li(v-for="tag in tags" :key="tag.text" :class="{ 'red-text': !textColor(tag), 'blue-text': textColor(tag) }") 
      hr
      | {{ tag.text }}
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
      this.tags.push(this.tagForm);
      window.localStorage.setItem("tags", JSON.stringify(this.tags));
    },
    textColor(tag) {
      return tag.color == "blue" ? true : false;
    },
  },
};
</script>

<style scoped>
li {
  list-style: none;
}

.red-text {
  color: red;
  font-weight: bold;
  font-size: 20px;
  margin-bottom: 10px;
}

.blue-text {
  color: blue;
  font-weight: bold;
  font-size: 20px;
  margin-bottom: 10px;
}
</style>
