<template>
  <div class="flex w-full h-16 bg-black" id="main-bar">
    <div class="text-gray-100 flex items-center ml-4 text-xl italic font-bold select-none gap-4">
      <p>SIMPLE-MM</p>
      <div class="h-1/2 border-r border-white"></div>
    </div>
    <nav class="flex-grow mx-4">
      <ul id="nav-top" class="flex h-full gap-6">
        <li v-for="route in routes" :key="route.displayName" class="border-b-4  border-black hover:border-yellow-400 text-white flex items-center font-thin">
          <router-link :to="route.path">{{route.displayName}}</router-link>
        </li>
      </ul>
    </nav>
    <div v-if="!this.$store.state.auth" class="flex flex-shrink items-center h-full text-white hover:text-black hover:bg-green-400 px-6">
      <router-link to="/login">
        Sign in
      </router-link>
    </div>
    <button v-else class="flex flex-shrink items-center h-full text-white hover:text-black hover:bg-green-400 px-6" @click="signOut">
      Sign out
    </button>
  </div>
</template>

<script>
export default {
  name: "MainBar",
  props: {
    routes: Array
  },
  methods: {
    signOut () {
      this.$store.commit("clearAuth")
    }
  }
};
</script>