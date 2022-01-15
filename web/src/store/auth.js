// Extracts the user data from a response from a successful login or auto-login.
const extractUserdata = (data) => {
  return {
    user: JSON.parse(window.atob(data.results.token.split(".")[1])),
    token: data.results.token,
    permissions: [],
  };
};

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
      console.info("Setting auth ...");
      state.user = user;
      state.token = token;
      state.permissions = permissions;
    },
    rememberAuth(state, token) {
      console.info("Remembering auth ...");
      window.localStorage.setItem("authToken", token);
    },
    clearAuth(state) {
      console.warn("Clearing auth ...");
      state.user = undefined;
      state.token = undefined;
      state.permissions = [];
    },
  },
  getters: {
    token(state) {
      // current auth token can be either state or remembered authToken
      if (!state.token) return localStorage.getItem("authToken");
      return state.token;
    },
    isAuthenticated(state) {
      return !!state.token;
    },
    authAboutToExpire(state) {
      // For use in dispatch("loadAuth") to only load if the
      // auth is about to expire.
      if (!state.user) return false;

      // Super straight-forward date comparison; return true if expire in less than 15min
      const expire = Date.parse(state.user.expire);
      const now = Date.now();
      const diff_in_minutes = (expire - now) / (1000 * 60);

      return diff_in_minutes < 15;
    },
  },
  actions: {
    async login({ dispatch }, { email, password, remember_me }) {
      console.info("Login ...");
      const request = dispatch(
        "post",
        { path: "/login", body: { email, password, remember_me }},
        { root: true }
      );

      const body = await request;

      if (body.errors) {
        console.error("auth/login | There were errors:");
        console.dir(body.errors);
      } else {
        dispatch("setAuth", extractUserdata(body));
        dispatch("showSuccess", "Signed in successfully.", { root: true })

        if (remember_me) dispatch("rememberAuth", body.results.token);
      }
    },
    async autologin({ commit, dispatch }) {
      console.info("Autologin ...");
      // Fetches this in-sync, as we want the entire sequence of auto-login to be
      // performed during the loadAuth() sequences.
      const request = dispatch("get", { path: "/autologin" }, { root: true });
      const body = await request;

      if (body) {
        await commit("setAuth", extractUserdata(body));
      } else {
        await commit("clearAuth");
      }
    },
    async signup(
      { commit, dispatch },
      { username, email, password, password_confirm, remember_me }
    ) {
      const request = dispatch(
        "post",
        {
          path: "/signup",
          body: {
            username,
            email,
            password,
            password_confirm,
            remember_me,
          }
        },
        { root: true }
      );
      const body = await request;
      if (body) {
        await commit("setAuth", extractUserdata(body));

        dispatch("showSuccess", "Welcome to Simple-MM!", { root: true })
      }
    },
    logout({ commit }) {
      console.info("Logging out ...");
      commit("clearAuth");
      window.localStorage.removeItem("authToken");
    },
    setAuth({ commit }, { user, token, permissions }) {
      commit("setAuth", { user, token, permissions });
    },
    rememberAuth({ commit }, token) {
      commit("rememberAuth", token);
    },
    async loadAuth({ dispatch, getters }) {
      // When attempting to load auth, the user can either have
      // a set token in local storage; or an active access token in
      // store (and this token can be close to expiry)
      const remembered_token = window.localStorage.getItem("authToken");
      const is_authenticated = getters["isAuthenticated"];
      const about_to_expire = getters["authAboutToExpire"];

      // Only refetch authentication (autologin) if user has a token
      // which is about to expire, or if they are unauthenticated
      // but have a remembered token (ie during hotlinking)
      if (about_to_expire || (remembered_token && !is_authenticated)) {
        // This must be done in await/async for the automatic login chain to work during hotlinking.
        await dispatch("autologin");
      }
    },
  },
};
