<template>
  <div
    v-if="match"
  >
    <div class="flex justify-center items-center">
      <div class="text-white">
        <div class="">
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
      <div class="text-white mx-20">
        VS
      </div>
      <div class="text-white">
        <div class="">
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

    const { match, league, game, match_teams } = body.data;
    
    this.league = league;
    this.game = game;
    this.match_teams = match_teams;
    this.match = match;
  },
  methods: {},
};
</script>