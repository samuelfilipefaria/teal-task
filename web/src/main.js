import { createApp } from "vue";
import App from "./App.vue";
import "boxicons";
import "animate.css";
import ElementPlus from "element-plus";
import "element-plus/dist/index.css";
import "./assets/css/global.css";
import router from "./router";
import vueKanban from "vue-kanban";

const app = createApp(App);
app.use(ElementPlus);
app.use(router);
app.use(vueKanban);
app.mount("#app");
