export default {
	namespaced: true,
	state () {
		return {
			user: undefined,
			token: undefined,
			permissions: []
		}
	},
	mutations: {
		setAuth (state, { user, token, permissions }) {
			state.user = user
			state.token = token
			state.permissions = permissions
		},
		clearAuth (state) {
			state.user = undefined
			state.token = undefined
			state.permissions = []
		}
	},
	getters: {
		token (state) {
			return state.token
		}
	}
}