<template>
  <div class="w-full flex flex-col divide-y divide-slate-700">
    <div
      v-for="player in players"
      :key="player"
      class="flex p-2 items-center"
    >
      <div class="flex-grow flex flex-col text-white">
        <p class="">
          {{ player.username }}
        </p>
        <p class="contents">
          <span class="text-2xl italic">
            {{ player.rating }}
          </span>
          {{ player.user.username }}
        </p>
      </div>
      <img
        class="object-fill rounded-full w-10 h-10 ring ring-neutral-200"
        :src="$store.getters['api_host'] + player.user.avatar.url"
      >
    </div>
  </div>
</template>

<script>
export default {
  name: "PlayersList",
  props: {
    players: {
      type: Array,
      required: true
    }
  },
  methods: {},
};
</script>

<style scoped>
</style>