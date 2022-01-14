<template>
  <div
    class="my-4 mx-6 p-4 rounded-sm pointer-events-auto"
    :class="bg_class"
    @mouseenter="enableLock"
    @mouseleave="removeLock"
  >
    <p>{{ message }}</p>
  </div>
</template>

<script>
export default {
  name: "Notification",
  components: {},
  
  props: {
    message: {
      type: String,
      required: true
    },
    uuid: {
      type: String,
      required: true,
    },
    type: {
      type: String,
      default: () => {'success'}
    },
    disappear: {
      type: Number,
      default: undefined
    }
  },
  computed: {
    bg_class: function () {
      let classes;
      switch(this.type) {
        case "error":
          classes = "bg-red-600 text-white border-red-800 border";
          break;
        case "success":
          classes = "bg-green-600 text-white border-green-800 border";
          break;
        case "information":
          classes = "bg-blue-600 text-white border-blue-800 border";
          break;
        default:
          classes = "bg-white border-slate-200"
      }

      return classes;
    }
  },
  mounted () {
    if(this.disappear) {
      this.scheduleSelfDestroy();
    }
  },
  methods: {
    // This is called on mouse-enter, and serves to stop the remove notification functionality
    // from being able to remove the notification. (Lock = true state notifs aren't allowed to be removed)
    enableLock() {
      if(this.disappear) {
        this.$store.dispatch("lockNotification", this.uuid);
      }
    },
    // This is called on mouse-leave of the notification.
    removeLock() {
      if(this.disappear) {
        this.$store.dispatch("unlockNotification", this.uuid);
        this.scheduleSelfDestroy();
      }
    },
    scheduleSelfDestroy() {
      console.log(`Setting Notification:'${this.uuid}' to disappear in ${this.disappear} ms`);
      setTimeout(() => this.$store.dispatch('removeNotification', this.uuid), this.disappear);
    }
  },
};
</script>