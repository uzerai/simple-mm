<template>
  <div class="grid w-full grid-cols-3 lg:grid-cols-6 p-6 gap-6">
    <div
      v-for="game in games"
      :key="game"
      class="bg-white"
    >
      <p>{{ game.name }}</p>
      <p>{{ game.id }}</p>
    </div>
  </div>
</template>

<script>
export default {
  name: "GameGrid",
  props: {},
  data() {
    return {
      games: []
    }
  },
  async created() {
    const request = this.$store.dispatch("get", { path: "/games" })
    const body = await request;

    this.games = body.results;
  },
  methods: {},
};
</script>
