<template>
  <div
    v-if="league"
    class="flex flex-col mx-10 md:mx-20 my-10"
  >
    <div class="mx-4 my-6">
      <router-link
        class="ml-2 text-sm text-slate-200 font-thin hover:underline"
        :to="{ name: 'game-leagues', params: { slug: game.slug }}"
      >
        {{ game.name }}
      </router-link>
      <div class="flex items-center">
        <span class="text-4xl text-slate-200 font-thin mr-2">
          //
        </span>
        <h1 class="text-4xl text-white font-bold inline">
          {{ league.name }}
        </h1>
        <button v-if="leaguePlayer" @click="queueForLeague" class="ml-6 px-6 py-2 text-md transition-colors duration-300 rounded rounded border border-emerald-600 shadow-md text-emerald-100 bg-emerald-700 hover:bg-emerald-600 shadow-emerald-600/30">
          Play
        </button>
        <button v-else class="ml-6 px-6 py-2 text-md transition-colors duration-300 rounded rounded border border-blue-600 shadow-md text-blue-100 bg-blue-700 hover:bg-blue-600 shadow-blue-600/30">
          Join
        </button>
      </div>
    </div>
    <div class="flex flex-row w-full gap-4">
      <img
        :src="this.$store.getters['api_host'] + league.cover_image.url"
        class="w-1/4 aspect-[11/16] border border-black self-center"
      >
      <div class="flex-grow w-full">
        <div class="grid grid-flow-col grid-cols-2 h-full gap-4">
          <div class="border-slate-700 border bg-darkt-700 row-span-2">
            <section id="description" class="m-6">
              <p class="text-slate-200">{{ league.desc }}</p>
            </section>
          </div>
          <div class="row-span-2 grid grid-flow-col grid-cols-2 grid-rows-2 gap-4">
            <div class="border-slate-700 border bg-darkt-700 ">
            </div>
            <div class="border-slate-700 border bg-darkt-700 ">
            </div>
            <div class="border-slate-700 border bg-darkt-700 ">
            </div>
            <div class="border-slate-700 border bg-darkt-700 ">
            </div>
          </div>
        </div>
      </div>
    </div>
    <div class="flex w-full gap-2 mt-6">
      <div class="w-full bg-darkt-700">
        <match-list :matches="league.matches" class="w-full"/>
      </div>
      <div class="border-slate-700 border bg-darkt-700 ml-4 w-1/5">
        <p class="mx-auto pb-1.5 text-darkt-700 text-5xl whitespace-nowrap text-center font-['Kanit'] bg-orange-700 italic leading-8">
          // TOP
        </p>
        <players-list :players="league.top_5" />
      </div>
    </div>
  </div>
</template>

<script>
import MatchList from "../components/common/MatchList";
import PlayersList from "../components/common/PlayersList";

export default {
  name: "League",
  components: {
    MatchList,
    PlayersList
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
  computed: {
    leaguePlayer() {
      const hasPlayer = this.$store.getters["auth/user"]?.players.map(player => player.league_id).includes(this.league_id);
      console.info("User has player in league: " + hasPlayer);
      return hasPlayer;
    }
  },
  async created() {
    const request = this.$store.dispatch("get", { path: `/leagues/${this.league_id}` });
    const body = await request;

    const { league } = body.results;
    this.league = league;
    this.game = league.game;
  },
  methods: {
    async queueForLeague() {
      if (this.$store.getters["matchmaking/status"] === 0) {        
        this.$store.dispatch("matchmaking/startQueue", {
          player: this.$store.getters["auth/user"]?.players.find(player => player.league_id == this.league_id),
          league: this.league
        });
      }
    }
  },
};
</script>