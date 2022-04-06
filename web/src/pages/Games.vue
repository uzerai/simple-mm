<template>
  <div class="flex flex-col my-5">
    <div class="w-8/12 mx-auto text-stone-100 flex items-baseline mb-2 md:mb-5">
      <h2 class="text-md md:text-6xl font-bold">
        Games
      </h2>
      <select v-model="gametype" class="rounded-sm text-darkt-100 bg-darkt-800 border-none accent:cyan-900 radius-sm ml-12">
        <option value="digital">DIGITAL</option>
        <option value="physical">PHYSICAL</option>
        <option value="all">ALL</option>
      </select>
    </div>
    <div class="w-8/12 mx-auto py-6 grid gap-6 grid-cols-2 md:grid-cols-5">
      <div
        v-for="game in filtered_games"
        :key="game"
        class="bg-stone-300 hover:bg-cyan-900 transition ease-in-out duration-200 shadow-md shadow-stone-900"
      >
        <router-link class="relative m-1 md:m-2 block" :to="{ name: 'game-leagues', params: { slug: game.slug }}">
          <img
            :src="this.$store.getters['api_host'] + game.cover_image.cover.url"
            class="h-40 md:h-80 object-fill aspect-[11/16] border border-black"
          >
          <div class="absolute -bottom-0 md:-bottom-2 text-white flex flex-col items-center w-full background-gradient pb-2 md:pb-2 md:mb-2">
            <p class="text-xs md:text-lg font-semibold text-center">
              {{ game.name }}
            </p>
            <p class="hidden md:block">
              {{ game.player_count }} players
            </p>
          </div>
        </router-link>
      </div> 
    </div>
  </div>
</template>

<script>
export default {
  name: "Games",
  props: {},
  data() {
    return {
      gametype: "all",
      all_games: []
    };
  },
  computed: {
    filtered_games() {
      switch(this.gametype) {
        case "digital":
          return this.digital_games;
        case "physical":
          return this.physical_games;
        default:
          return this.all_games;
      }
    },
    physical_games() {
      return this.all_games.filter(game => game.physical);
    },
    digital_games() {
      return this.all_games.filter(game => !game.physical);
    },
  },
  async created() {
    const request = this.$store.dispatch("get", { path: "/games" });
    const body = await request;

    this.all_games = body.results;
  },
  methods: {},
};
</script>
<style scoped>
  .background-gradient {
    background: linear-gradient(to top, rgba(0, 0, 0, 1), rgba(0, 0, 0, 0));
  }

  .triangle {
    clip-path: polygon(50% 0, 100% 100%, 0% 100%);
    transform: rotate(-90deg);
  }
</style>