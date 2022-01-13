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
  mutations: {
    addError(state, error) {
      state.global_errors.push(error);
    },
  },
  getters: {
    api_host(state) {
      return state.api_host;
    },
  },
  actions: {
    async post({ state, commit, getters }, { path, body }) {
      return fetch(`${state.api_host}${path}`, {
        method: "POST",
        headers: {
          "Content-Type": "application/json",
          Authorization: `Bearer ${getters["auth/token"]}`,
        },
        body: JSON.stringify(body),
      })
        .then((resp) => resp.json())
        .then((data) => {
          const { errors } = data;

          if (errors) {
            errors.forEach((error) => commit("addError", error));
          }

          return data;
        });
    },
    async get({ state, commit, getters }, { path, query }) {
      const queryString = query ? `?${new URLSearchParams(query)}` : "";

      return fetch(`${state.api_host}${path}${queryString}`, {
        method: "GET",
        headers: {
          "Content-Type": "application/json",
          Authorization: `Bearer ${getters["auth/token"]}`,
        },
      })
        .then((resp) => resp.json())
        .then((data) => {
          const { errors } = data;

          if (errors) {
            errors.forEach((error) => commit("addError", error));
          }

          return data;
        });
    },
  },
});
