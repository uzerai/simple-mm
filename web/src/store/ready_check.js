
export default {
  namespaced: true,
  state() {
    return {
      league_id: undefined,
      match_type: undefined,
      match_id: undefined,
      ready_players: 0,
      total_players: 0,
      current_player_ready: false,
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
    },
    setPlayerReady(state, { ready }) {
      state.current_player_ready = ready;
    },
    reset(state) {
      state.current_player_ready = false;
      state.ready_players = 0;
      state.total_players = 0;
      state.league_id = undefined;
      state.match_id = undefined;
      state.match_type = undefined;
    },
    updateReadyPlayersFromWebsocket(state, { not_ready }) {
      console.info("Updating nr of ready players.");
      if (state.total_players === 0) {
        console.info("total_players is 0");
        state.ready_players = 0;
      } else {
        state.ready_players = state.total_players - not_ready.length;
        console.info(`ready players are ${state.ready_players}`);
      }
    },
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
    playerReady(state) {
      return state.current_player_ready;
    },
    matchReady(state) {
      return (state.total_players - state.ready_players) === 0 && state.total_players != 0;
    }
  },
  actions: {
    /* eslint-disable-next-line */
    async declareReady({ commit, getters, rootGetters }) {
      console.info("ReadyCheck | Declaring user ready ...");
      const matchmakingChannel = rootGetters["websockets/subscriptions"][`MatchmakingChannel:${getters["leagueId"]}`];
      await matchmakingChannel.perform("ready_check", { user_id: rootGetters["auth/user"].id, match_id: getters["matchId"] });
      await commit("setPlayerReady", { ready: true });
    },
    async startReadyCheck({ dispatch, commit }, { league_id, match_id }) {
      const request = dispatch(
        "get",
        { path: `/leagues/${league_id}` },
        { root: true});

      // We ensure that there is a league which can be queued for here.
      const body = await request;

      if (body?.data) {
        const league = body.data;
        console.info(`ReadyCheck | ! Matchmaking READY CHECK for ${league.id} initialized !`);
        await commit("setQueue", { league_id: league.id, match_type: league.match_type });
        await commit("setMatchId", { match_id });
        dispatch("openReadyCheck", null);
      }
    },
    openReadyCheck() {
      const dialog = document.getElementById("ready-check-dialog");
      dialog.showModal();
    },
    async closeReadyCheckMatchLive({ dispatch, commit }) {
      await commit("matchmaking/setStatus", { status: 3 }, { root: true });
      dispatch("closeReadyCheck");
    },
    closeReadyCheck() {
      const dialog = document.getElementById("ready-check-dialog");
      setTimeout(() =>dialog.close(), 1000);
    },
    async closeReadyCheckNotReady({ dispatch }) {
      console.warn("ReadyCheck | Closing ready check as not ready.");
      await dispatch("closeReadyCheck");
      dispatch("matchmaking/stopActiveQueue", null, { root: true });
    }
  }
};