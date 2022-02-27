
import { createConsumer } from "@rails/actioncable";
import { readEvent } from "../events/events_channel_handler";

export default {
  namespaced: true,
  state() {
    return {
      consumer: undefined,
      subscriptions: {}
    }
  },
  mutations: {
    setConsumer(state, { consumer }) {
      state.consumer = consumer;
    },
    createSubscription(state, { channel, room, onReceived }) {
      // Ensure we don't resubscribe.
      if(!Object.keys(state.subscriptions).includes(channel)) {
        console.info(`Creating websocket subscription to ${channel} ...`);
        const subscription = state.consumer?.subscriptions.create({
          channel,
          room
        }, {
          received(data) {
            console.log(`Incoming websocket data from: ${channel}`);
            
            if(onReceived) {
              onReceived(data);
            }
          }
        });

        // Don't allow re-subscribing to a single channel multiple times.
        state.subscriptions[channel] = subscription
      }
    }
  },
  getters: {
    consumer(state) {
      // Return already existing consumer.
      return state.consumer;
    },
    subscriptions(state) {
      return state.subscriptions;
    }
  },
  actions: {
    // Main functionality called during `main.js` which initializes a consumer and some standard
    // channels which are useful the entire application
    async loadWebsockets({ commit, dispatch, getters, rootGetters }){
      // Create a new consumer when the auth/token is present but no consumer is in store.
      if (rootGetters["auth/isAuthenticated"] && !getters["consumer"]){
        console.log("Loading websockets consumer ...");

        commit("setConsumer", { consumer: createConsumer(`${rootGetters["api_host"]}/cable?token=${rootGetters["auth/token"]}`) })
        
        // Initializes the main notifications channel for the application; allows 
        // server to broadcast notifications to each user.
        dispatch("createSubscription", { channel: "EventsChannel", onReceived: (data) => {
          // Imported from src/events/event_channel_handler.js
          readEvent({ commit, dispatch, getters, rootGetters }, data);
        }})
      }
    },
    async disconnect({getters}) {
      if(getters["consumer"]) {
        console.info("Disconnecting websockets consumer ...");
        getters["consumer"].disconnect();
      }
    },
    createSubscription({ commit, getters }, { channel, room, onReceived }) {
      if(getters["consumer"]) {
        commit("createSubscription", { channel, room, onReceived });
      } else {
        // Should ideally never happen, but in the scenario it does ...
        console.warn("Failed to create subscription, :consumer missing ...");
      }
    }
  }
};
