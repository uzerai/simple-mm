<template>
  <div
    v-if="game"
    class="flex flex-col my-5"
  >
    <h1 class="text-md md:text-6xl font-bold text-stone-100 w-8/12 mx-auto mb-2 md:mb-5">
      {{ game?.name }}
    </h1>
    <h2 class="sm:text-sm md:text-2xl font-thin text-stone-200 w-8/12 mx-auto my-2" id="official-leagues">
      <strong><span class="pr-2 md:pr-8">≫</span></strong>Official leagues
    </h2>
    <div class="w-full">
      <div class="flex w-8/12 my-6 mx-auto gap-6 overflow-x-scroll">
        <div
          v-for="league in leagues"
          :key="league.id"
          class="flex bg-stone-300 shadow-md shadow-stone-900 flex-shrink-0"
        >
          <router-link :to="{ name: 'league', params: { league_id: league.id }}" class="relative m-2">
            <img
              :src="this.$store.getters['api_host'] + league.cover_image.url"
              class="h-40 md:h-80 object-fill"
            >
            <div class="absolute bottom-0 flex flex-col items-center w-full background-gradient pb-2">
              <p class="text-white  text-xs md:text-xl font-semibold text-center">
                {{ league.name }}
              </p>
              <p class="hidden md:show text-stone-200">
                {{ league.player_count }} players
              </p>
            </div>
          </router-link>
        </div>
      </div>
    </div>
    <h2 class="sm:text-sm md:text-2xl font-thin text-stone-200 w-8/12 mx-auto mt-2 mb-2 md:mt-4 md:mb-5" id="official-leagues">
      <strong><span class="pr-2 md:pr-8">≫</span></strong>Public leagues
    </h2>
    <div class="w-full">
      <div class="flex w-8/12 my-6 mx-auto gap-6 overflow-x-scroll">
        <div
          v-for="league in leagues"
          :key="league.id"
          class="flex bg-stone-300 shadow-md shadow-stone-900 flex-shrink-0"
        >
          <router-link :to="{ name: 'league', params: { league_id: league.id }}" class="relative m-2 cursor-pointer">
            <img
              src="../assets/default_game.jpg"
              class="h-40 md:h-80 object-fill"
            >
            <div class="absolute bottom-0 flex flex-col items-center w-full background-gradient pb-2">
              <p class="text-stone-200 text-xs md:text-xl font-semibold text-center">
                {{ league.name }}
              </p>
              <p class="hidden md:show text-stone-200">
                {{ league.player_count }} players
              </p>
            </div>
          </router-link>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
export default {
  name: "Leagues",
  components: {},
  props: {
    slug: {
      type: String,
      required: true
    }
  },
  data() {
    return {
      game: null,
      leagues: []
    };
  },
  async created() {
    const slug = this.$route.params.slug;
    const request = this.$store.dispatch("get", { path: `/games/${slug}/leagues` });
    const body = await request;

    const { game, leagues } = body.results;
    this.game = game;
    this.leagues = leagues;
  },
  methods: {},
};
</script>
<style>
  .league-description + .league-hover:hover {
    opacity: 1;
    display: unset;
  }

  .league-description {
    opacity: 0;
    display: none;
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

  .background-gradient {
    background: linear-gradient(to top, rgba(0, 0, 0, 1), rgba(0, 0, 0, 0));
  }
</style>