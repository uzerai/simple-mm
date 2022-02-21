<template>
  <div class="flex my-5">
    <div class="w-full bg-neutral-300 shadow-inner shadow-stone-900">
      <div class="xl:w-8/12 w-full mx-auto py-6 overflow-x-auto">
        <div class="flex gap-6">
          <div
            v-for="game in games"
            :key="game"
            class="bg-stone-100 shadow-md shadow-stone-900 cursor-pointer flex-shrink-0"
            @click="$router.push(`/games/${game.slug}/leagues`)"
          >
            <div class="relative m-2">
              <img
                src="../../assets/default_game.jpg"
                class="object-scale-down h-80"
              >
              <div class="absolute bottom-0 flex flex-col items-center w-full background-image pb-2">
                <p class="text-white text-l font-semibold text-center">
                  {{ game.name }}
                </p>
                <p class="text-white text-sm">
                  {{ game.player_count }} players
                </p>
              </div>
            </div>
          </div>
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
