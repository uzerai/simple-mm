<template>
  <div class="flex flex-col my-5">
    <h1 class="text-6xl font-bold text-white ml-6">
      {{ game.name }}
    </h1>
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
    }
  },
  async created() {
    const slug = this.$route.params.slug;
    const request = this.$store.dispatch("get", { path: `/games/${slug}/leagues` });
    const body = await request;

    this.game = body.results;
    this.leagues = this.game.leagues;
  },
  methods: {},
};
</script>