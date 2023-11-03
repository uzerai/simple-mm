<template>
  <Dialog
    id="ready-check-dialog"
    :open="false"
    :on_close="onClose"
  >
    <div class="h-48 m-6 flex-col flex items-center">
      <h1 class="text-5xl font-bold">
        READY CHECK
      </h1>
      <hr class="my-8 border-2 w-full">
      <button
        v-if="!ready"
        class="w-1/2 my-4"
        @click="setReady"
      >
        READY
      </button>
      <div
        v-else
        class="flex place-content-evenly gap-x-1 w-full"
      >
        <div
          v-for="elem in new Array(readyPlayers)"
          :key="elem"
          class="h-10 w-10 bg-green-700"
        />
        <div
          v-for="elem in new Array(totalPlayers - readyPlayers)"
          :key="elem"
          class="h-10 w-10 border border-gray-200"
        />
      </div>
    </div>
  </Dialog>
</template>
<script>
import { mapGetters } from "vuex";
import Dialog from "./common/Dialog.vue";

export default {
  name: "ReadyCheck",
  components: {
    Dialog,
  },
  props: {},
  data() {
    return {
      ready: false,
    };
  },
  computed: {
    ...mapGetters({ 
      queuedLeague: "matchmaking/queuedLeague",
      totalPlayers: "ready_check/totalPlayers",
      readyPlayers: "ready_check/readyPlayers",
      matchReady: "ready_check/matchReady",
    }),
  },
  watch: {
    matchReady(newMatchReady) {
      if (newMatchReady) {
        console.info("ReadyCheck | Ready check completed successfully, closing dialog ... ");
        const dialog = document.getElementById("ready-check-dialog");
        this.$store.commit("matchmaking/setStatus", { status: 3 }, { root: true });
        setTimeout(() => dialog.close(), 1000);
      }
    },
  },
  methods: {
    setReady() {
      // this.ready = true;
      this.$store.dispatch("ready_check/declareReady");
    },
    onClose() {
      this.$store.commit("ready_check/reset");
    }
  },
};
</script>
<style scoped>
</style>