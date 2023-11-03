import { STATUS } from '../store/matchmaking';

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
  /* eslint-disable-next-line */
  const { commit, dispatch, getters, rootGetters } = storeContext;
  console.info("MatchmakingChannel: Received event");
  console.dir(matchmaking_channel_event);

  const { status, match_id, not_ready } = matchmaking_channel_event;

  switch (status) {
    case "preparing":
      // This should instigate the ready-check for all users.
      commit("setStatus", { status: STATUS["READY_CHECK"] }); // this commit comes from matchmaking.js
      dispatch("ready_check/startReadyCheck", { league_id: rootGetters["matchmaking/queuedLeague"], match_id }, { root: true });
      break;
    case "readying":
      // The stage at which point all users have accepted the match.
      commit("setStatus", { status: STATUS["READY_CHECK"] });
      commit("ready_check/updateReadyPlayersFromWebsocket", { not_ready }, { root: true });
      break;
    case "live":
      break;
    default:
      break;
  }
};

export { readEvent };
