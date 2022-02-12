<template>
  <div class="grid w-full grid-cols-3 lg:grid-cols-6 p-6 gap-6" />
</template>

<script>
export default {
  name: "LeaguesList",
  props: {
    all_leagues: {
      type: Array,
      required: true
    },
    leagues: {
      type: Array,
      required: false,
      default: () => [],
    }
  },
  methods: {},
};
</script>

<style scoped>
.background-image {
  background: linear-gradient(to top, rgba(0, 0, 0, 1), rgba(0, 0, 0, 0));
}
</style>
