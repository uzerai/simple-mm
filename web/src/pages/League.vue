<template>
  <div
    v-if="league"
    class="flex flex-col mx-10 md:mx-20 "
  >
    <div class="mx-4 my-6">
      <router-link
        class="ml-2 text-sm text-slate-200 font-thin hover:underline"
        :to="{ name: 'game-leagues', params: { slug: game.slug }}"
      >
        {{ game.name }}
      </router-link>
      <div class="text-4xl">
        <span class="text-slate-200 font-thin mx-2">
          //
        </span>
        <h1 class="text-white font-bold inline">
          {{ league.name }}
        </h1>
      </div>
    </div>
    <div class="flex flex-row w-full gap-4">
      <div class="flex flex-col w-1/4">
        <img
          :src="this.$store.getters['api_host'] + league.cover_image.url"
          class="w-full aspect-[11/16] border border-black self-center"
        >
        <div class="w-full text-white">
          <p>{{ league.desc }}</p>
        </div>
      </div>
      <div class="flex-grow">
        <MatchList
          :matches="league.matches"
          class="w-full"
        />
      </div>
      <div class="w-1/24" />
    </div>
  </div>
</template>

<script>
import MatchList from "../components/common/MatchList";

export default {
  name: "League",
  components: {
    MatchList,
  },
  props: {
    league_id: {
      type: String,
      required: true
    }
  },
  data() {
    return {
      game: undefined,
      league: undefined
    };
  },
  async created() {
    const request = this.$store.dispatch("get", { path: `/leagues/${this.league_id}` });
    const body = await request;

    const { league } = body.results;
    this.league = league;
    this.game = league.game;
  },
  methods: {},
};
</script>