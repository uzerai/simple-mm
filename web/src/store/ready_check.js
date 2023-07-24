
export default {
  namespaced: true,
  state() {
    return {
      league_id: undefined,
      match_type: undefined,
      match_id: undefined,
      ready_players: 0,
      total_players: 20,
    };
  },
  mutations: {
    setQueue(state, { league_id, match_type }) {
      state.league_id = league_id;
      state.match_type = match_type;
      state.total_players = match_type.team_size * state.match_type.team_count;
    },
    setMatchId(state, { match_id }) {
      state.match_id = match_id;
    }
  },
  getters: {
    matchId(state) {
      return state.match_id;
    },
    leagueId(state) {
      return state.league_id;
    },
    totalPlayers(state) {
      return state.total_players;
    },
    readyPlayers(state) {
      return state.ready_players;
    },
    matchReady(state) {
      return !(state.total_players - state.ready_players);
    }
  },
  actions: {
    async declareReady({ getters, rootGetters }) {
      console.info("Declaring user ready.");
      const matchmakingChannel = rootGetters["websockets/subscriptions"][`MatchmakingChannel:${getters["leagueId"]}`];
      console.dir(matchmakingChannel);
      matchmakingChannel.perform("ready_check", { user: rootGetters["auth/user"] });
    },
    async startReadyCheck({ dispatch, commit }, { league_id, match_id }) {
      const request = dispatch(
        "get",
        { path: `/leagues/${league_id}` },
        { root: true});

      // We ensure that there is a league which can be queued for here.
      const body = await request;

      if (body?.data) {
        const { league } = body.data;
        console.info(`! Matchmaking READY CHECK for ${league.id} initialized !`);
        commit("setQueue", { league_id: league.id, match_type: league.match_type });
        commit("setMatchId", { match_id });

        const dialog = document.getElementById("ready-check-dialog");
        dialog.showModal();
      }
    },
  }
};