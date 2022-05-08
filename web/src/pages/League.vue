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
        <button
          v-if="leaguePlayer && !isInQueue"
          class="ml-6 px-6 py-2 text-md transition-colors duration-300 rounded border border-emerald-600 shadow-md text-emerald-100 bg-emerald-700 hover:bg-emerald-600 shadow-emerald-600/30"
          @click="queueForLeague"
        >
          Play
        </button>
        <button
          v-else-if="leaguePlayer && isInQueueForLeague"
          class="ml-6 px-6 py-2 text-md transition-colors duration-300 rounded border border-rose-600 shadow-md text-rose-100 bg-rose-700 hover:bg-rose-900 hover:border-rose-800 hover:text-rose-300 shadow-rose-600/30"
          @click="unqueueFromLeague"
        >
          Cancel
        </button>
        <button
          v-else-if="leaguePlayer && isInQueue"
          class="ml-6 px-6 py-2 text-md transition-colors duration-300 rounded border border-neutral-600 shadow-md text-neutral-100 bg-neutral-700 cursor-not-allowed"
          disabled
        >
          In other queue ...
        </button>
        <button
          v-else
          class="ml-6 px-6 py-2 text-md transition-colors duration-300 rounded border border-blue-600 shadow-md text-blue-100 bg-blue-700 hover:bg-blue-600 shadow-blue-600/30"
          @click="joinLeague"
        >
          Join
        </button>
      </div>
    </div>
    <div class="flex flex-row w-full gap-4">
      <img
        :src="$store.getters['api_host'] + league.cover_image.url"
        class="w-1/4 aspect-[11/16] border border-black self-center"
      >
      <div class="flex-grow w-full">
        <div class="grid grid-flow-col grid-cols-2 h-full gap-4">
          <div class="flex flex-col border-slate-700 border bg-darkt-700 row-span-2">
            <div
              id="description" 
              class="m-6 text-slate-300 overflow-y-scroll max-h-96 flex-grow"
            >
              <markdown :markdown="league.desc" />
            </div>
            <div class="flex justify-between border-t divide-slate-700 border-slate-700 divide-x bg-darkt-800">
              <div class="w-full h-12 text-center text-slate-600 flex items-center justify-center cursor-pointer hover:underline hover:text-blue-300">
                Link 1
              </div>
              <div class="w-full h-12 text-center text-slate-600 flex items-center justify-center cursor-pointer hover:underline hover:text-blue-300">
                Link 2
              </div>
              <div class="w-full h-12 text-center text-slate-600 flex items-center justify-center cursor-pointer hover:underline hover:text-blue-300">
                Socials
              </div>
            </div>
          </div>
          <div class="row-span-2 grid grid-flow-col grid-cols-1 grid-rows-2 gap-4">
            <div class="border-slate-700 border bg-darkt-700" />
            <div class="border-slate-700 border bg-darkt-700" />
          </div>
        </div>
      </div>
    </div>
    <div class="flex w-full gap-2 mt-6">
      <div class="w-full bg-darkt-700">
        <match-list
          :matches="league.matches"
          class="w-full"
        />
      </div>
      <div class="border-slate-700 border bg-darkt-700 ml-4 w-1/5">
        <h3 class="mx-auto text-darkt-700 text-4xl whitespace-nowrap text-center font-bold bg-orange-700 italic">
          Top players
        </h3>
        <players-list :players="league.top5" />
      </div>
    </div>
  </div>
</template>

<script>
import MatchList from "../components/common/MatchList";
import PlayersList from "../components/common/PlayersList";
import Markdown from "../components/common/Markdown";

export default {
  name: "League",
  components: {
    MatchList,
    PlayersList,
    Markdown,
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
    isInQueueForLeague() {
      const inQd4League = this.$store.getters["matchmaking/status"] > 0 && this.$store.getters["matchmaking/queuedLeague"] == this.league_id;
      console.info("User id queued for league:" + inQd4League);
      return inQd4League;
    },
    isInQueue() {
      return this.$store.getters["matchmaking/status"] > 0;
    },
    leaguePlayer() {
      const hasPlayer = this.$store.getters["auth/user"]?.players.map(player => player.league_id)
        .includes(this.league_id);
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
    async joinLeague() {
      // eslint-disable-next-line
      const request = await this.$store.dispatch("post", { path: `/leagues/${this.league_id}/join` });
      
      this.$store.dispatch("auth/autologin");
    },
    async unqueueFromLeague() {
      const league_id = this.$store.getters["matchmaking/queuedLeague"];
      this.$store.dispatch("matchmaking/stopQueue", { league_id });
    },
    async queueForLeague() {
      // Only allow users which are not currently in queue, to queue.
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