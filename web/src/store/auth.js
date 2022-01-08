
const extractToken = (data)  => {
  console.dir(data)
  return {
    user: JSON.parse(window.atob(data.results.token.split(".")[1])),
    token: data.results.token,
    permissions: [],
  }
}

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
      console.info("Setting auth")
      state.user = user;
      state.token = token;
      state.permissions = permissions;
    },
    rememberAuth(state, token) {
      console.info("Remembering auth");
      window.localStorage.setItem("authToken", token);
    },
    clearAuth(state) {
      console.warn("Clearing auth")
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
    async login({ dispatch, state, rootState }, { email, password, remember_me }) {
      const request = fetch(`${rootState.api_host}/login`, {
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
      
      const body = await request.then((resp) => resp.json())

      if (body.errors) {
        console.error("auth/login | There were errors:");
        console.dir(body.errors);
      } else {

        console.info("auth/login | Setting auth token:");
        console.dir(body.results.token);
        dispatch("setAuth", extractToken(body));
        
        console.log(`auth/login | Remember me is: ${remember_me}`)
        if(remember_me)
          dispatch("rememberAuth", body.results.token)
      }
    },
    async autologin({commit, rootState}, { stored_token }) {
      console.info("Autologin")
      // Fetches this in-sync, as we want the entire sequence of auto-login to be
      // performed during the loadAuth() sequences.
      const request = fetch(`${rootState.api_host}/autologin`, {
        method: "GET",
        headers: {
          "Content-Type": "application/json",
          Authorization: `Bearer ${stored_token}`,
        }
      })

      const body = await request
        .then((resp) => resp.json());
      
      if(body) {
        await commit("setAuth", extractToken(body));
      } else {
        await commit("clearAuth");
      }
    },
    logout({ commit }) {
      console.info("Logging out...")
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
      const remembered_token = window.localStorage.getItem("authToken");
      
      // loadAuth() is called during route loading; so let's not actually do the 
      // auto login if we already have a token which is valid in store.
      const is_authenticated = getters['isAuthenticated']

      // TODO: Refresh of token if it's close to expiry (maybe like 1h?)

      if (remembered_token && !is_authenticated) {
        // This must be done in await/async for the automatic login chain to work during hotlinking.
        await dispatch("autologin", { stored_token: remembered_token })
      }
    },
  },
};
