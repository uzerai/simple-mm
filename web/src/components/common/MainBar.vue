<template>
  <div
    id="main-bar"
    class="flex w-full h-16 bg-black"
  >
    <!-- Logo, left -->
    <div
      class="text-gray-100 flex items-center ml-4 text-xl italic font-bold select-none gap-1 lg:gap-4"
    >
      <p>SIMPLE-MM</p>
      <div class="h-1/2 border-r border-white" />
    </div>

    <nav class="flex-grow mx-4 text-sm lg:text-base">
      <ul
        id="nav-top"
        class="flex h-full gap-6"
      >
        <li
          v-for="route in routes"
          :key="route.displayName"
          class="border-b-4 border-black hover:border-yellow-400 text-white flex items-center font-thin"
        >
          <router-link :to="route.path">
            {{ route.displayName }}
          </router-link>
        </li>
      </ul>
    </nav>

    <!-- Sign in/Sign out button in top-right -->
    <router-link
      v-if="!$store.getters['auth/token']"
      to="/login"
      class="flex flex-shrink items-center h-full text-white hover:text-black hover:bg-green-400 px-2 lg:px-6 text-sm lg:text-base"
    >
      Sign in
    </router-link>
    <button
      v-else
      class="flex flex-shrink items-center h-full text-white hover:text-black hover:bg-green-400 px-6"
      @click="signOut"
    >
      Sign out
    </button>
  </div>
</template>

<script>
export default {
  name: "MainBar",
  props: {
    routes: {
      type: Array,
      default: () => {[]}
    },
  },
  methods: {
    signOut() {
      this.$store.dispatch("auth/logout");
      this.$router.push("/");
    },
  },
};
</script>
