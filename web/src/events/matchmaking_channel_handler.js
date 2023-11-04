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

const readEvent = async (storeContext, matchmaking_channel_event) => {
  const { commit, dispatch, rootGetters } = storeContext;
  console.info("MatchmakingChannel: Received event");
  console.dir(matchmaking_channel_event);

  const { status, match_id, not_ready } = matchmaking_channel_event;

  switch (status) {
    case "readying":
      // The stage at which point all users have accepted the match.
      if(rootGetters["matchmaking/status"] < STATUS["READY_CHECK"]) {
        await commit("setStatus", { status: STATUS["READY_CHECK"] });
        await dispatch("ready_check/startReadyCheck", { league_id: rootGetters["matchmaking/queuedLeague"], match_id }, { root: true });
      }

      await commit("ready_check/updateReadyPlayersFromWebsocket", { not_ready }, { root: true });
      break;
    case "live":
      // force-close the ready-check
      await dispatch("ready_check/closeReadyCheckMatchLive", null, { root: true });
      await dispatch("stopActiveQueue");
      break;
    case "cancelled":
      if(rootGetters["ready_check/playerReady"]) {
        await dispatch("ready_check/closeReadyCheck", null, { root: true });
        commit("setStatus", { status: STATUS["QUEUEING"] });
      } else {
        dispatch("ready_check/closeReadyCheckNotReady", null, { root: true });
      }
      break;
    default:
      break;
  }
};

export { readEvent };
