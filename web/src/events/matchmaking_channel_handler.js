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

  switch (matchmaking_channel_event?.status) {
    case "queued":
      // Setting to 'queued' is handled in the matchmaking store 
      // setActiveQueue action.
      break;
    case "preparing":
      // This should instigate the ready-check for all users.
      // status should be 2
      commit("setStatus", { newStatus: 2});
      break;
    case "readying":
      // The stage at which point all users have accepted the match.
      commit("setStatus", { newStatus: 3 });
      break;
    case "live":
      break;
    default:
      break;
  }
};

export { readEvent };
