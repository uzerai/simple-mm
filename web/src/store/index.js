import { v4 as new_uuid } from "uuid";
import { createStore } from "vuex";
import auth from "./auth";
import matchmaking from "./matchmaking";
import ready_check from "./ready_check";
import websockets from "./websockets";

// Global store for all globally-required information.
export default createStore({
  state: () => ({
    api_host: "http://localhost:8010",
    global_notifications: [],
  }),
  modules: {
    auth,
    websockets,
    matchmaking,
    ready_check,
  },
  mutations: {
    // The default method for adding a notification to be 
    // displayed to the global pop-up.
    addNotification(state, notification) {
      state.global_notifications.push({
        uuid: new_uuid(),
        lock: false,
        ...notification
      });
    },
    removeNotification(state, notification_uuid) {
      console.warn("Removing notification:", notification_uuid);
      const notification = state.global_notifications.find(notif => notif.uuid === notification_uuid && notif.lock !== true);

      if(notification) {
        state.global_notifications.splice(state.global_notifications.indexOf(notification), 1);
      }
    },
    lockNotification(state, notification_uuid) {
      console.info("Locking notification:", notification_uuid);
      const notification = state.global_notifications.find(notif => notif.uuid === notification_uuid);

      if(notification) {
        // Set the lock of notification to true
        state.global_notifications[state.global_notifications.indexOf(notification)].lock = true;
      }
    },
    unlockNotification(state, notification_uuid) {
      console.info("Unlocking notification:", notification_uuid);
      const notification = state.global_notifications.find(notif => notif.uuid === notification_uuid);

      if(notification) {
        // Set the lock of notification to false
        state.global_notifications[state.global_notifications.indexOf(notification)].lock = false;
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
    async post({ state, dispatch, getters }, { path, body, notifyOnError }) {
      return fetch(`${state.api_host}${path}`, {
        method: "POST",
        headers: {
          "Content-Type": "application/json",
          Accept: "application/json",
          Authorization: `Bearer ${getters["auth/token"]}`,
        },
        body: JSON.stringify(body),
      })
        .then((resp) => resp.json())
        .then((data) => {
          const { errors } = data;
          console.info(errors?.length);

          if ((errors?.length != 0) && notifyOnError) {
            errors.forEach((error) => dispatch("showError", error.message));
          }

          return data;
        });
    },
    async get({ state, dispatch, getters }, { path, query, notifyOnError }) {
      const queryString = query ? `?${new URLSearchParams(query)}` : "";

      return fetch(`${state.api_host}${path}${queryString}`, {
        method: "GET",
        headers: {
          "Content-Type": "application/json",
          Accept: "application/json",
          Authorization: `Bearer ${getters["auth/token"]}`,
        },
      })
        .then((resp) => resp.json())
        .then((data) => {
          const { errors } = data;

          if ((errors?.length != 0) && notifyOnError) {
            errors.forEach((error) => dispatch("showError", error.message));
          }

          return data;
        });
    },
    showError({ commit }, message) {
      // Prepend an instance ID so we can close the error.
      commit("addNotification", {
        type: "error",
        message,
        disappear: 5000
      });
    },
    showSuccess({ commit }, message) {
      commit("addNotification", {
        type: "success",
        message,
        disappear: 2400
      });
    },
    removeNotification({ commit }, notification_uuid) {
      commit("removeNotification", notification_uuid);
    },
    lockNotification({ commit }, notification_uuid) {
      commit("lockNotification", notification_uuid);
    },
    unlockNotification({ commit }, notification_uuid) {
      commit("unlockNotification", notification_uuid);
    }
  },
});
