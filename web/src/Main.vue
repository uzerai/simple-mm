<!-- 
  Super simple main component for handling routing throughout the application.
-->
<template>
  <div id="main" class="">
    <div id="top-bar" class="w-full h-10 bg-black"></div>
    <router-view></router-view>
  </div>
</template>

<script>
export default {
  name: "Main",
  props: {},
  methods: {},
};
</script>
