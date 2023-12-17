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
      el-button.custom-button(@click="createTag" size="large")
        box-icon(v-if="isEditing" name="edit-alt" color="white")
        box-icon(v-else name="plus" color="white")

  table
    tr(v-for="tag in tags" :key="tag.text")
      td
        el-tag.custom-tag(:type='tag.color' effect="dark" size="large") {{ tag.text }}
      td
        box-icon.tag-action-icon(name='edit' type="solid" color="teal" @click="editTag(tag)")
        box-icon.tag-action-icon(name='trash' type="solid" color="red" @click="removeTag(tag)")
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
      isEditing: false,
    };
  },
  computed: {
    saveButtonIcon() {
      return this.isEditing ? "edit-alt" : "plus";
    },
  },
  methods: {
    createTag() {
      this.upperTagText();
      this.removeAditionalSpaces();
      if (this.isTagInvalid()) return;

      if (this.isEditing) {
        const tag = { text: this.tagForm.text, color: this.tagForm.color };
        const tagTexts = this.tags.map((tag) => tag.text);
        const findCurrentText = (text) => text == tag.text;
        const tagIndex = tagTexts.findIndex(findCurrentText);

        this.tags.splice(tagIndex, 1, tag);
        window.localStorage.setItem("tags", JSON.stringify(this.tags));
        this.isEditing = false;
      } else {
        this.saveTag();
      }

      this.cleanTagForm();
    },
    upperTagText() {
      this.tagForm.text = this.tagForm.text.toUpperCase();
    },
    removeAditionalSpaces() {
      this.tagForm.text = this.tagForm.text.trim();
    },
    isTagInvalid() {
      if (this.isTagEmpty() || this.isTagRepeated()) return true;
      return false;
    },
    isTagEmpty() {
      return this.tagForm.text == "" ? true : false;
    },
    isTagRepeated() {
      const tagTexts = this.tags.map((tag) => tag.text);
      const currentTagText = this.tagForm.text;
      const findCurrentText = (text) => text == currentTagText;

      if (tagTexts.findIndex(findCurrentText) != -1) {
        return true;
      } else {
        return false;
      }
    },
    saveTag() {
      this.tags.push({
        text: this.tagForm.text,
        color: this.tagForm.color,
      });
      window.localStorage.setItem("tags", JSON.stringify(this.tags));
    },
    cleanTagForm() {
      this.tagForm.text = this.tagForm.color = "";
    },
    removeTag(tag) {
      const tagTexts = this.tags.map((tag) => tag.text);
      const findCurrentText = (text) => text == tag.text;
      const tagIndex = tagTexts.findIndex(findCurrentText);

      this.tags.splice(tagIndex, 1);
      window.localStorage.setItem("tags", JSON.stringify(this.tags));
    },
    editTag(tag) {
      this.isEditing = true;
      this.putTagDataOnForm(tag);
    },
    putTagDataOnForm(tag) {
      this.tagForm = {
        text: tag.text,
        color: tag.color,
      };
    },
  },
};
</script>

<style scoped>
table {
  margin: 0 auto;
}

.custom-tag {
  min-width: 100px;
  font-size: 20px;
  margin-bottom: 10px;
  margin-top: 5px;
}

.tag-action-icon {
  margin-left: 10px;
  margin-top: 2px;
  cursor: pointer;
}
</style>
