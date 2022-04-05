<template>
  <div
    v-if="league"
    class="flex flex-col"
  >
    <h1 class="mx-4 my-6">
      <router-link
        class="text-sm  text-slate-200 font-thin hover:underline cursor-pointer"
        :to="{ name: 'game-leagues', params: { slug: game.slug }}"
      >
        {{ game.name }}
      </router-link>
      <span class="text-sm text-slate-200 font-thin">
        //
      </span>
      <span class="text-xl text-white font-bold">
        {{ league.name }}
      </span>
    </h1>
    <div class="flex flex-row w-full gap-4 px-2">
      <div class="flex flex-shrink flex-col w-1/6">
        <img
          src="../assets/default_game.jpg"
          class="object-scale-down"
        >
        <div class="bg-darkt-50">
          <p>
            {{ league.name }}
          </p>
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