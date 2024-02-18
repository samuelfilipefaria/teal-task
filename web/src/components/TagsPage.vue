<template lang="pug">
h1(style="text-align: center;") Tags
div(style="text-align: center;")
  el-form(:inline="true" :model="tagForm" label-width="120px")
    el-form-item
      el-input(v-model="tagForm.label" placeholder="Text")
    el-form-item
      el-select(v-model="tagForm.color" placeholder="Color")
        el-option.bolder(label="Teal" value="" style="color: #008080;")
        el-option.bolder(label="Green" value="success" style="color: #67C23A;")
        el-option.bolder(label="Gray" value="info" style="color: #909399;")
        el-option.bolder(label="Orange" value="warning" style="color: #E6A23C;")
        el-option.bolder(label="Red" value="danger" style="color: #F56C6C;")
    el-form-item
      el-button.custom-button(@click="createTag" size="large")
        box-icon(v-if="textBeforeEdition != undefined" name="edit-alt" color="white")
        box-icon(v-else name="plus" color="white")


  table(v-if="!isLoading")
    tr(v-for="tag in tags" :key="tag.label")
      td
        el-tag.custom-tag(:type='tag.color' effect="dark" size="large") {{ tag.label }}
      td
        box-icon.tag-action-icon(name='edit' type="solid" color="teal" @click="editTag(tag)")
        box-icon.tag-action-icon(name='trash' type="solid" color="red" @click="removeTag(tag)")

el-dialog(v-model='invalidDataWarningDialog' title='Dados inválidos!' width='500')
  p Etiquetas não podem ter nomes vazios ou repetidos!
</template>

<script>
import axios from "axios";

export default {
  name: "TagsPage",
  data() {
    return {
      tagForm: {
        label: "",
        color: "",
      },
      tags: [],
      textBeforeEdition: undefined,
      isLoading: true,
      invalidDataWarningDialog: false,
    };
  },
  methods: {
    createTag() {
      this.upperTagLabel();
      this.removeAditionalSpaces();
      if (this.isTagInvalid()) {
        this.invalidDataWarningDialog = true;
        return;
      }

      if (this.textBeforeEdition != undefined) {
        const editedTagId = this.tags.find(
          (tag) => tag.label == this.textBeforeEdition
        ).id;

        axios
          .put("http://127.0.0.1:3000/tags/" + editedTagId, {
            label: this.tagForm.label,
            color: this.tagForm.color,
          })
          .then(function (response) {
            console.log(response);
          })
          .catch(function (error) {
            console.log(error);
          });

        this.textBeforeEdition = undefined;
      } else {
        axios
          .post("http://127.0.0.1:3000/tags", {
            label: this.tagForm.label,
            color: this.tagForm.color,
          })
          .then(function (response) {
            console.log(response);
          })
          .catch(function (error) {
            console.log(error);
          });
      }

      // retirar esse reload aqui depois
      window.location.reload();
      this.cleanTagForm();
    },
    upperTagLabel() {
      this.tagForm.label = this.tagForm.label.toUpperCase();
    },
    removeAditionalSpaces() {
      this.tagForm.label = this.tagForm.label.trim();
    },
    isTagInvalid() {
      if (this.isTagEmpty() || this.isTagRepeated()) return true;
      return false;
    },
    isTagEmpty() {
      return this.tagForm.label == "" ? true : false;
    },
    isTagRepeated() {
      if (this.tags.length == 0) return false;
      if (this.textBeforeEdition == this.tagForm.label) return false;

      const tagLabels = this.tags.map((tag) => tag.label);
      const currentTagLabel = this.tagForm.label;
      const findCurrentLabel = (text) => text == currentTagLabel;

      if (tagLabels.findIndex(findCurrentLabel) != -1) {
        return true;
      } else {
        return false;
      }
    },
    cleanTagForm() {
      this.tagForm.label = this.tagForm.color = "";
    },
    removeTag(tag) {
      axios
        .delete("http://127.0.0.1:3000/tags/" + tag.id)
        .then(function (response) {
          console.log(response);
        })
        .catch(function (error) {
          console.log(error);
        });

      // retirar esse reload aqui depois
      window.location.reload();
    },
    editTag(tag) {
      this.textBeforeEdition = tag.label;
      this.putTagDataOnForm(tag);
    },
    putTagDataOnForm(tag) {
      this.tagForm = {
        label: tag.label,
        color: tag.color,
      };
    },
    async loadTags() {
      try {
        this.isLoading = true;
        this.tags = [];
        const response = await axios.get("http://127.0.0.1:3000/tags");
        this.tags = response.data;
        this.isLoading = false;
      } catch (error) {
        console.error(error);
      }
    },
  },
  mounted() {
    this.loadTags();
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
