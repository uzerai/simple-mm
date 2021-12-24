<!-- 
  Super simple main component for handling routing throughout the application.
-->
<template>
  <div id="main" class="">
    <div class="flex w-full h-16 bg-black border border-red-800 items-stretch">
      <div class="basis-1/3">
      </div>
      <nav class="basis-1/3">
        <ul id="nav-top" class="w-full flex justify-around h-full space-evenly">
          <li class="self-center"><router-link to="/" class="text-white ">Home</router-link></li>
          <li class="self-center"><router-link to="/players" class="text-white ">Players</router-link></li>
        </ul>
      </nav>
      <div class="basis-1/3">
      </div>
    </div>
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
