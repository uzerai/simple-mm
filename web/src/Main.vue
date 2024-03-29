<!-- Super simple main component for handling routing throughout the application. -->
<template>
  <div id="main">
    <div
      id="content-background"
      class="fixed -z-10 w-screen h-screen bg-zinc-50 dark:bg-darkt-800"
    />
    <main-bar :routes="routes" />
    <ready-check />
    <div id="main-content relative">
      <router-view v-slot="{ Component }">
        <transition
          name="fade"
          mode="out-in"
          appear
        >
          <component :is="Component" />
        </transition>
      </router-view>

      <div class="text-darkt-100 text-center my-4">
        <p> Simple-MM matchmaking systems </p>
        <p> 2020 &copy;</p>
      </div>

      <!-- This transition group makes the notifications absolute too. -->
      <transition-group
        class="absolute w-full lg:w-fit lg:top-auto sm:flex flex-col justify-center lg:inline-block lg:bottom-0 lg:right-0 overflow-hidden pointer-events-none"
        name="notifications"
        tag="div"
      >
        <notification
          v-for="notif in notifications"
          :key="notif.uuid"
          :uuid="notif.uuid"
          :message="notif.message"
          :type="notif.type"
          :disappear="notif.disappear"
        />
      </transition-group>
    </div>
  </div>
</template>

<script>
import { mapGetters } from "vuex";
import ReadyCheck from "./components/ReadyCheck";
import MainBar from "./components/common/MainBar";
import Notification from "./components/common/Notification";
import routes from "./routes";

export default {
  name: "Main",
  components: {
    MainBar,
    Notification,
    ReadyCheck
  },
  props: {},
  data() {
    return {
      routes: routes.filter((route) => route.displayName),
    };
  },
  computed: {
    ...mapGetters([
      "notifications"
    ])
  },
  methods: {
    openDialog() {
      const league_id = this.$store.getters["matchmaking/queuedLeague"];
      this.$store.dispatch("ready_check/startReadyCheck", { league_id });
    }
  },
};
</script>

<style>
  .notifications-enter-active,
  .notifications-leave-active {
    transition: all 0.4s ease;
  }

  @media(max-width: 1023px) {  
    .notifications-enter-from,
    .notifications-leave-to {
      opacity: 0;
      transform: translateY(-30px);
    }
  }
  
  @media (min-width: 1024px) {
    .notifications-enter-from,
    .notifications-leave-to {
      opacity: 0;
      transform: translateY(30px);
    }
  }
  
  .fade-enter-active {
    transition: all .2s ease;
  }

  .fade-leave-active {
    transition: all .180s cubic-bezier(1.0, 0.5, 0.8, 1.0);
  }
  
  .fade-enter, .fade-leave-to {
    opacity: 0;
  }
</style>
