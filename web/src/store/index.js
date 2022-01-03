import { createStore } from "vuex";
import auth from "./auth";

// Global store for all globally-required information.
export default createStore({
  state: () => ({
    api_host: "http://localhost:8010",
    global_errors: [],
  }),
  modules: {
    auth,
  },
  getters: {
    api_host(state) {
      return state.api_host;
    },
  },
});
