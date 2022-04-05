<template>
  <div class="flex flex-col my-5">
    <h2 class="w-8/12 text-md md:text-6xl font-bold text-stone-100 mx-auto stroke mb-2 md:mb-5">
      Games
    </h2>
    <div class="w-8/12 mx-auto py-6 grid gap-6 grid-cols-2 md:grid-cols-5">
      <router-link
        v-for="game in games"
        :key="game"
        :to="{ name: 'game-leagues', params: { slug: game.slug }}"
        class="bg-stone-300 p-1 md:p-2"
      >
        <div class="relative">
          <img
            src="../assets/default_game.jpg"
            class="object-fill static"
          >
          <div class="absolute -bottom-0 md:-bottom-2 text-white flex flex-col items-center w-full background-gradient pb-2 md:pb-2 md:mb-2">
            <p class="text-xs md:text-lg font-semibold text-center">
              {{ game.name }}
            </p>
            <p class="hidden md:block">
              {{ game.player_count }} players
            </p>
          </div>
        </div> 
      </router-link>
    </div>
  </div>
</template>

<script>
export default {
  name: "Games",
  props: {},
  data() {
    return {
      all_games: [],
      games: []
    };
  },
  async created() {
    const request = this.$store.dispatch("get", { path: "/games" });
    const body = await request;

    this.all_games, this.games = body.results;
  },
  methods: {},
};
</script>
<style scoped>
  .background-gradient {
    background: linear-gradient(to top, rgba(0, 0, 0, 1), rgba(0, 0, 0, 0));
  }
</style>