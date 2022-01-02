import { createStore } from "vuex";

// Global store for all globally-required information.
export default createStore({
	state () {
		return {
			auth: undefined,
		}
	},
	mutations: {
		setAuth(state, auth) {
			state.auth = auth
		},
		clearAuth(state) {
			state.auth = undefined
		}
	}
})