import { readEvent } from "../events/matchmaking_channel_handler";

export const STATUS = {
  "IDLE": 0,
  "QUEUEING": 1,
  "READY_CHECK": 2,
  "FINALIZING": 3,
};

export default {
  namespaced: true,
  state() {
    return {
      status: parseInt(window.localStorage.getItem("queue_status")) || 0,
      queue_id: window.localStorage.getItem("active_queue") || undefined,
    };
  },
  mutations: {
    setStatus(state, { status }) {
      console.warn(`Matchmaking | Updating status to ${status}`);
      state.status = status;
      window.localStorage.setItem("queue_status", status);
    },
    /**
     *  Queue id should always have a format of '<current_user#player_id>:<league_id>'
     */
    setQueueId(state, { queue_id }) {
      state.queue_id = queue_id;
      window.localStorage.setItem("active_queue", queue_id);
    },
    setIdle(state) {
      console.info("Matchmaking | Setting matchmaking bar to idle.");
      state.queue_id = undefined;
      state.status = STATUS["IDLE"];
      window.localStorage.removeItem("active_queue");
      window.localStorage.removeItem("queue_status");
    },
    setQueueing(state, { queue_id }) {
      state.queue_id = queue_id;
      state.status = STATUS["QUEUEING"];
    }
  },
  getters: {
    status(state) {
      return state.status;
    },
    queueId(state) {
      return state.queue_id;
    },
    queuedLeague(state) {
      return state.queue_id?.split(":")[1];
    },
    queuedPlayer(state) {
      return state.queue_id?.split(":")[0];
    }
  },
  actions: {
    // Sends an initial post request to indicate to the server that the user is searching for a game.
    // requires the player of the league (which belongs to the user and the league).
    async startQueue({ dispatch }, { player }) {
      console.info(`Starting queueing for league ... ${player.league_id}`);
      const request = dispatch(
        "post",
        {
          path: "/matchmaking/queue",
          body: {
            league_id: player.league_id,
            player_id: player.id,
          }
        },
        { root: true });

      const body = await request;

      if (body?.data) {
        console.log("Queue request OK -- Setting active queue ...");
        dispatch("connectActiveQueue", { queue_id: body.data.queue });

        // Set a reminder for the active queues in the case the user disconnects.
        window.localStorage.setItem("active_queue", body.data.queue);
      }
    },
    // TODO: Make it possible to have multiple queues going at the same time.
    async stopActiveQueue({ dispatch, getters }) {
      const league_id = getters["queuedLeague"];
      dispatch("stopQueue", { league_id });
    },
    async stopQueue({ commit }, { league_id }) {
      if (league_id) {
        console.info(`Stopping queue: ${league_id}`);
        commit("websockets/removeSubscription", { channel: "MatchmakingChannel", room: league_id}, { root: true });
      }
      commit("setIdle");
    },
    async connectActiveQueue({ commit, dispatch, rootGetters }, { queue_id }) {
      console.info(`Establishing WS connection ... for queue ${queue_id}`);

      // NOTE: The MatchmakingChannel is connected to per-user per-league, thus we can strip out the player_id from the
      // queue_id returned from server.
      dispatch("websockets/createSubscription", { channel: "MatchmakingChannel", 
        room: queue_id.split(":")[1], 
        onReceived: (data) => readEvent({ commit, dispatch, rootGetters }, data)}, 
        { root: true });
      commit("setQueueing", { queue_id });
    }
  }
};