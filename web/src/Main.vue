<!-- Super simple main component for handling routing throughout the application. -->
<template>
  <div id="main">
    <div
      id="content-background"
      class="fixed -z-10 w-screen h-screen bg-zinc-50 dark:bg-darkt-800"
    />
    <MainBar :routes="routes" />
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

      <!-- This transition group makes the notifications absolute too. -->
      <transition-group
        class="absolute w-full lg:w-fit lg:top-auto sm:flex flex-col justify-center lg:inline-block lg:bottom-0 lg:right-0 overflow-hidden pointer-events-none"
        name="notifications"
        tag="div"
      >
        <Notification
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
import routes from "./routes";
import MainBar from "./components/common/MainBar";
import Notification from "./components/common/Notification";
import { mapGetters } from "vuex";

export default {
  name: "Main",
  components: {
    MainBar,
    Notification
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
  methods: {},
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
