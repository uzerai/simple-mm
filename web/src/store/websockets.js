
import { createConsumer } from "@rails/actioncable";

export default {
  namespaced: true,
  state() {
    return {
      consumer: undefined,
      channels: []
    }
  },
  mutations: {
    setConsumer(state, { consumer }) {
      state.consumer = consumer;
    },
    createSubscription(state, { channel, room }) {
      if(!state.channels.includes(channel)) {
        console.info(`Creating ws subscription to ${channel} ...`);
        state.consumer?.subscriptions.create({
          channel,
          room
        }, {
          received(data) {
            console.warn("Incoming websocket data:");
            console.dir(data);
          }
        });
        state.channels.push(channel);
      }
    }
  },
  getters: {
    consumer(state) {
      // Return already existing consumer.
      return state.consumer;
    }
  },
  actions: {
    async load({ commit, dispatch, rootGetters }){
      console.log("Loading websockets consumer ...");
      if (rootGetters['auth/isAuthenticated']){
        // Create a new consumer when the auth/token is present but no consumer is in store.
        commit("setConsumer", { consumer: createConsumer(`${rootGetters['api_host']}/cable?token=${rootGetters['auth/token']}`) })
        console.info("Connected consumer ...");
      } else {
        // Cannot create a new consumer, don't even attempt.
        console.warn(`Could not connect consumer ...`);
      }
      
      console.log("Loading websocket Notifications subscription.");
      dispatch("createSubscription", { channel: "NotificationsChannel", room: rootGetters['auth/token'] })
    },
    createSubscription({ commit, getters }, { channel, room }) {
      if(getters['consumer']) 
        commit("createSubscription", { channel, room });
    }
  }
};
