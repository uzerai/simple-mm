<template>
  <div
    v-if="match"
    class="flex flex-col w-full"
  >
    <!-- <h1 class="mx-4 my-6">
      <router-link
        class="text-sm  text-slate-200 font-thin hover:underline cursor-pointer"
        :to="{ name: 'League', params: { league_id: league.id }}"
      >
        {{ game.name }}
      </router-link>
      <span class="text-sm text-slate-200 font-thin">
        //
      </span>
      <span class="text-xl text-white font-bold">
        {{ match.id }}
      </span>
    </h1> -->
    <div class="flex">
      <div class="flex flex-col text-white flex-grow items-center gap-4">
        <div class="mb-6 text-center">
          <h4>
            Team A [{{ match_teams[0].outcome }}]
          </h4>
          <p>
            Average rating: <span>
              {{ match_teams[0].avg_rating }}
            </span>
          </p>
        </div>
        <div
          v-for="player in match_teams[0].match_players"
          :key="player"
        >
          <p>{{ player.player.username }} [<span>{{ player.start_rating }}</span>]</p>
        </div>
      </div>
      <div class="w-1/16 text-2xl font-bold text-white">
        VS
      </div>
      <div class="flex flex-col text-white flex-grow items-center gap-4">
        <div class="mb-6 text-center">
          <h4>
            Team A [{{ match_teams[1].outcome }}]
          </h4>
          <p>
            Average rating: <span>
              {{ match_teams[1].avg_rating }}
            </span>
          </p>
        </div>
        <div
          v-for="player in match_teams[1].match_players"
          :key="player"
        >
          <p>{{ player.player.username }} [<span>{{ player.start_rating }}</span>]</p>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
export default {
  name: "Match",
  components: {},
  props: {
    match_id: {
      type: String,
      required: true,
    }
  },
  data() {
    return {
      match: undefined,
      game: undefined,
      league: undefined,
      match_teams: undefined,
    };
  },
  async created() {
    const request = this.$store.dispatch("get", { path: `/matches/${this.match_id}` });
    const body = await request;

    const { match, league, game, match_teams } = body.results;
    
    this.league = league;
    this.game = game;
    this.match_teams = match_teams;
    this.match = match;
  },
  methods: {},
};
</script>