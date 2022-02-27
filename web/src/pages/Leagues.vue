<template>
  <div
    v-if="game"
    class="flex flex-col my-5"
  >
    <h1 class="text-6xl font-bold text-white w-8/12 mx-auto mb-5">
      {{ game?.name }}
    </h1>
    <div class="w-full  bg-slate-300 shadow-inner shadow-stone-900">
      <div class="grid w-8/12 lg:grid-cols-6 my-6 mx-auto gap-6">
        <div
          v-for="league in leagues"
          :key="league.id"
          class="bg-stone-100 shadow-md shadow-stone-900 cursor-pointer"
          @click="$router.push(`/leagues/${league.id}`)"
        >
          <div class="relative m-2">
            <img
              src="../assets/default_game.jpg"
              class="object-scale-down"
            >
            <div class="absolute bottom-0 flex flex-col items-center w-full background-image pb-2">
              <p class="text-white text-xl font-semibold">
                {{ league.name }}
              </p>
              <p class="text-white">
                {{ league.player_count }} players
              </p>
            </div>
          </div>
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