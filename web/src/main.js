import { createApp } from "vue";
import { createRouter, createWebHistory } from "vue-router";
import Main from "./Main.vue";
// Non-vendor includes
import routes from "./routes";
import store from "./store";
import "./styles/app.css";

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

router.beforeEach(async (to, from, next) => {
  // Load methods should be idempotent (cause no change on multiple retries if already attempted)
  await store.dispatch("auth/loadAuth");

  // Loads any websockets the current user was a part of on previous disconnect.
  await store.dispatch("websockets/loadWebsockets");
  
  // Loads the queues which the player might've been in when leaving the website
  // does not reconcile past events if the player was gone, but should instigate the player to
  // rejoin the game if they lost connection during ready check.
  await store.dispatch("websockets/loadQueues");
  
  if (!to.meta.public && !store.getters["auth/isAuthenticated"]) {
    console.log("Meta public?", to.meta.public);
    console.log("Not authenticated. Redirecting to /login");
    next({ name: "login", query: { redirect: to.fullPath } });
  } else next();
});

router.afterEach((to) => {
  // Replace : prefixed variables in the title field with the matching parameters from the same route.
  // this allows interpolation of strings like ":slug" to be replaced with the route parameter values.
  const title = to.meta?.title.replace(/:[a-z-_]+/, (match) => {
    // Parameter name without the :
    const param_name = match.replace(":", "");

    // Parameters that may be in the title which should be titleized.
    if(["slug"].includes(param_name)) {
      return to.params[param_name]
        ?.split("-")
        .map((str) => {
          // words which should not be capitalized.
          if(["of"].includes(str)) {
            return str;
          }

          // otherwise capitalize the first letter of the word
          return str.charAt(0).toUpperCase() + str.slice(1);
        }).join(" ");
    }

    // if the parameter doesn't need to be titleized
    return to.params[param_name];
  });

  document.title =  "Simple-MM | " + title;
});

app.use(router);

app.mount("#app");
