<template>
  <div class="flex flex-col my-5">
    <h2 class="w-8/12 text-6xl font-bold text-white mx-auto stroke my-4">
      Games
    </h2>
    <GameGrid />|
  </div>
</template>

<script>
import GameGrid from "../components/common/GameGrid";

export default {
  name: "Games",
  components: {
    GameGrid
  },
  props: {},
  methods: {},
};
</script>