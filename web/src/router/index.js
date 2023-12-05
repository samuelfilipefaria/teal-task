import { createRouter, createWebHistory } from "vue-router";

const router = createRouter({
  history: createWebHistory(),
  routes: [
    {
      path: "/",
      name: "Home",
      component: () => import("../components/HomePage.vue"),
    },
    {
      path: "/calendar",
      name: "Calendar",
      component: () => import("../components/CalendarPage.vue"),
    },
    {
      path: "/kanban",
      name: "Kanban",
      component: () => import("../components/KanbanPage.vue"),
    },
    {
      path: "/tags",
      name: "Tags",
      component: () => import("../components/TagsPage.vue"),
    },
    {
      path: "/pomodoro",
      name: "Pomodoro",
      component: () => import("../components/PomodoroPage.vue"),
    },
  ],
});

export default router;
