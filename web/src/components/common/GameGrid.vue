<template>
  <div class="grid w-full grid-cols-3 lg:grid-cols-6 p-6 gap-6">
    <div
      v-for="game in games"
      :key="game"
      class="bg-white"
    >
      <div
        class="relative m-1"
        @click="$router.push(`/games/${game.slug}/leagues`)"
      >
        <img
          src="../../assets/default_game.jpg"
          class="object-scale-down"
        >
        <div class="absolute bottom-0 flex flex-col items-center w-full background-image pb-2">
          <p class="text-white text-xl font-semibold">
            {{ game.name }}
          </p>
          <p class="text-white">
            {{ game.player_count }} players
          </p>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
export default {
  name: "GameGrid",
  props: {},
  data() {
    return {
      all_games: [],
      games: []
    }
  },
  async created() {
    const request = this.$store.dispatch("get", { path: "/games" })
    const body = await request;

    this.all_games, this.games = body.results;
  },
  methods: {},
};
</script>

<style scoped>
.background-image {
  background: linear-gradient(to top, rgba(0, 0, 0, 1), rgba(0, 0, 0, 0));
}
</style>
