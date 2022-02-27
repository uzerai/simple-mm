const readEvent = (storeContext, event_channel_event) => {
  /* eslint-disable-next-line */
  const { commit, dispatch, getters, rootGetters } = storeContext;
  console.info("EventChannel: Received event");
  console.dir(event_channel_event);

  if (event_channel_event.type == "error") {
    dispatch("showError", event_channel_event.message, { root: true });
  } else {
    dispatch("showSuccess", event_channel_event.message, { root: true });
  }
};

export { readEvent };
