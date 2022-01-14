import { v4 as new_uuid } from 'uuid';
import { createStore } from "vuex";
import auth from "./auth";

// Global store for all globally-required information.
export default createStore({
  state: () => ({
    api_host: "http://localhost:8010",
    global_notifications: [],
  }),
  modules: {
    auth,
  },
  mutations: {
    // The default method for adding a notification to be 
    // displayed to the global pop-up.
    addNotification(state, notification) {
      state.global_notifications.push({
        uuid: new_uuid(),
        ...notification
      });
    },
    removeNotification(state, notification_uuid) {
      console.warn("Removing notification:", notification_uuid);
      const notification = state.global_notifications.find(notif => notif.uuid === notification_uuid);

      if(notification) {
        state.global_notifications.splice(state.global_notifications.indexOf(notification), 1);
      }

    }
  },
  getters: {
    api_host(state) {
      return state.api_host;
    },
    notifications(state) {
      return state.global_notifications;
    },
  },
  actions: {
    async post({ state, dispatch, getters }, { path, body }) {
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
            errors.forEach((error) => dispatch("showError", error));
          }

          return data;
        });
    },
    async get({ state, dispatch, getters }, { path, query }) {
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
            errors.forEach((error) => dispatch("showError", error));
          }

          return data;
        });
    },
    showError({ commit }, error) {
      // Prepend an instance ID so we can close the error.
      error['type'] = 'error';
      commit("addNotification", error);
    },
    showSuccess({ commit }, message) {
      commit("addNotification", {
        type: "success",
        message,
        disappear: 1300
      });
    },
    removeNotification({ commit }, notification_uuid) {
      commit("removeNotification", notification_uuid);
    }
  },
});
