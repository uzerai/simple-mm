import { STATUS } from "../store/matchmaking";

/* eslint-disable-next-line */
const STATES = [
  "queued",
  "preparing",
  "readying",
  "live",
  "completed",
  "cancelled",
  "aborted"
];

const readEvent = (storeContext, matchmaking_channel_event) => {
  const { commit, dispatch, rootGetters } = storeContext;
  console.info("MatchmakingChannel: Received event");
  console.dir(matchmaking_channel_event);

  const { status, match_id, not_ready } = matchmaking_channel_event;

  switch (status) {
    case "readying":
      // The stage at which point all users have accepted the match.
      if(rootGetters["matchmaking/status"] < STATUS["READY_CHECK"]) {
        commit("setStatus", { status: STATUS["READY_CHECK"] });
        dispatch("ready_check/startReadyCheck", { league_id: rootGetters["matchmaking/queuedLeague"], match_id }, { root: true });
      }

      commit("ready_check/updateReadyPlayersFromWebsocket", { not_ready }, { root: true });
      break;
    case "live":
      // force-close the ready-check
      dispatch("ready_check/closeReadyCheck", {}, { root: true });
      dispatch("stopActiveQueue");
      break;
    case "cancelled":
      if(rootGetters["ready_check/ready"]) {
        dispatch("ready_check/closeReadyCheck", {}, { root: true });
        commit("setStatus", { status: STATUS["QUEUEING"] });
      } else {
        dispatch("ready_check/closeReadyCheckNotReady", {}, { root: true });
      }
      break;
    default:
      break;
  }
};

export { readEvent };
