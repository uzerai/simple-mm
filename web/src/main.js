import { createApp } from "vue";
import { createRouter, createWebHistory } from "vue-router";

// Non-vendor includes
import routes from "./routes";
import store from "./store";
import "./styles/app.css";
import Main from "./Main.vue";

// Vue app instantiation, binding Main as the main entrypoint component of the application.
const app = createApp(Main);

// The store is initialized from vuex in `./store/index.js`
// Instantiate this first so that routes can read from store
app.use(store);

// Router creation and initialization.
// update routes in the accompanying routes.js
const router = createRouter({
  history: createWebHistory(),
  routes,
});
router.beforeEach((to, from, next) => {
  if(!["Home", "Login"].includes(to.name) && !store.getters['auth/isAuthenticated']) next({ name: "Login" })
  else next()
})
app.use(router);


app.mount("#app");
