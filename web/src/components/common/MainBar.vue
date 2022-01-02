<template>
  <div class="flex w-full h-16 bg-black" id="main-bar">
    <div class="text-gray-100 flex items-center ml-4 text-xl italic font-bold select-none gap-4">
      <p>SIMPLE-MM</p>
      <div class="h-1/2 border-r border-white"></div>
    </div>
    <nav class="flex-grow mx-4">
      <ul id="nav-top" class="flex h-full gap-6">
        <li v-for="route in routes" v-bind:key="route.displayName" class="border-b-4  border-black hover:border-yellow-400 text-white flex items-center font-thin">
          <router-link v-bind:to="route.path">{{route.displayName}}</router-link>
        </li>
      </ul>
    </nav>
    <div class="flex-shrink flex">
      <LoginButton />
    </div>
  </div>
</template>

<script>
import LoginButton from "./auth/LoginButton"

export default {
  name: "MainBar",
  props: {
    routes: Array
  },
  components: {
    LoginButton
  },
  methods: {},
};
</script>