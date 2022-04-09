import { readEvent } from "../events/matchmaking_channel_handler";

const STATUS = {
  "IDLE": 0,
  "QUEUEING": 1,
  "READY_CHECK": 2
};

export default {
  namespaced: true,
  state() {
    return {
      status: 0
    };
  },
  mutations: {
    setStatus(state, { newStatus }) {
      state.status = newStatus;
    }
  },
  getters: {
    status(state) {
      return state.status;
    }
  },
  actions: {
    // Sends an initial post request to indicate to the server that the user is searching for a game.
    // requires the player of the league (which belongs to the user and the league).
    async startQueue({ dispatch }, { player }) {
      console.info(`Starting queueing for league ... ${player?.league_id}`);
      const request = dispatch(
        "post",
        {
          path: "/matchmaking/queue",
          body: {
            player_id: player?.id,
            league_id: player?.league_id
          }
        },
        { root: true });

      const body = await request;

      if (body?.results) {
        console.log("Queue request OK -- Setting active queue ...");
        dispatch("setActiveQueue", { queue_id: body.results.id });
      }
    },
    async setActiveQueue({ commit, dispatch }, { queue_id }) {
      console.info("Establishing WS connection ... for queue " + queue_id);
      dispatch("websockets/createSubscription", { channel: "MatchmakingChannel", 
        room: queue_id, onReceived: (data) => readEvent({ commit, dispatch }, data)}, 
        { root: true });
      commit("setStatus", { newStatus: STATUS["QUEUEING"] });
    }
  }
};