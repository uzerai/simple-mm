<!-- 
  Super simple main component for handling routing throughout the application.
-->
<template>
  <div id="main">
    <div
      id="content-background"
      class="fixed -z-50 w-screen h-screen bg-gray-50 dark:bg-zinc-900"
    >
      <transition-group class="absolute bottom-0 right-0" name="notifications" tag="div">
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
    <MainBar v-bind:routes="routes" />
    <div id="main-content">
      <router-view></router-view>
    </div>
  </div>
</template>

<script>
import routes from "./routes";
import MainBar from "./components/common/MainBar";
import Notification from "./components/common/Notification";

export default {
  name: "Main",
  props: {},
  data() {
    return {
      notifications: this.$store.getters["notifications"],
      routes: routes.filter((route) => route.displayName),
    };
  },
  methods: {},
  components: {
    MainBar,
    Notification
  },
};
</script>

<style scoped>
.notifications-item {
  display: inline-block;
  margin-right: 10px;
}

.notifications-enter-active,
.notifications-leave-active {
  transition: all 0.4s ease;
}
.notifications-enter-from,
.notifications-leave-to {
  opacity: 0;
  transform: translateY(30px);
}

</style>
