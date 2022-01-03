export default {
  namespaced: true,
  state() {
    return {
      user: undefined,
      token: undefined,
      permissions: [],
    };
  },
  mutations: {
    setAuth(state, { user, token, permissions }) {
      state.user = user;
      state.token = token;
      state.permissions = permissions;
    },
    clearAuth(state) {
      state.user = undefined;
      state.token = undefined;
      state.permissions = [];
    },
  },
  getters: {
    token(state) {
      return state.token;
    },
    isAuthenticated(state) {
      return !!state.token;
    },
  },
  actions: {
    login({ dispatch, state, rootState }, { email, password, remember_me }) {
      fetch(`${rootState.api_host}/login`, {
        method: "POST",
        headers: {
          "Content-Type": "application/json",
          Authorization: `Bearer ${state.token}`,
        },
        body: JSON.stringify({
          email,
          password,
          remember_me,
        }),
      })
        .then((response) => response.json())
        .then((data) => {
          if (data.errors) {
            console.log("There were errors:");
            console.dir(data.errors);
            return;
          } else {
            console.log("Setting auth token:");
            console.dir(data.results.token);
            dispatch("setAuth", {
              user: JSON.parse(atob(data.results.token.split(".")[1])),
              token: data.results.token,
              permissions: [],
            });
          }
        });
    },
    logout({ commit }) {
      commit("clearAuth");
      window.localStorage.removeItem("authToken");
      window.localStorage.removeItem("authUser");
      window.localStorage.removeItem("authPermissions");
    },
    setAuth({ commit }, { user, token, permissions }) {
      commit("setAuth", { user, token, permissions });
      window.localStorage.setItem("authToken", token);
      window.localStorage.setItem("authUser", JSON.stringify(user));
      window.localStorage.setItem("authPermissions", permissions.join(","));
    },
    loadAuth({ commit }) {
      commit("setAuth", {
        token: window.localStorage.getItem("authToken"),
        user: JSON.parse(window.localStorage.getItem("authUser")),
        permissions: window.localStorage.getItem("authPermissions")?.split(","),
      });
    },
  },
};
