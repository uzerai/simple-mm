<template>
  <div
    id="main-bar"
    class="flex w-full h-16 bg-darkt-900 border-b border-black"
  >
    <!-- Logo, left -->
    <div class="text-gray-100 flex items-center ml-2 md:ml-4 text-sm md:text-xl italic font-bold select-none gap-3 md:gap-4">
      <p>SIMPLE-MM</p>
      <div class="h-1/2 border-r border-white" />
    </div>

    <nav class="flex-grow mx-4 text-sm md:text-base">
      <ul
        id="nav-top"
        class="flex h-full gap-6"
      >
        <li
          v-for="route in routes"
          :key="route.displayName"
          class="border-b-4 border-neutral-900 hover:border-blue-sapphire text-white flex items-center font-thin"
        >
          <router-link :to="route.path">
            {{ route.displayName }}
          </router-link>
        </li>
      </ul>
    </nav>

    <!-- Sign in/Sign out button in top-right -->
    <router-link
      v-if="!user"
      to="/login"
      class="flex flex-shrink items-center h-full text-xs md:text-base text-white hover:text-black hover:bg-green-400 px-6"
    >
      Sign in
    </router-link>
    <button
      v-else
      class="flex flex-shrink items-center h-full text-xs md:text-base text-white hover:text-black hover:bg-green-400 px-6"
      @click="logOut"
    >
      Sign out
    </button>
  </div>
</template>

<script>
  import { mapGetters } from "vuex";

  export default {
    name: "MainBar",
    props: {
      routes: {
        type: Array,
        default: () => {[];}
      },
    },
    computed: {
      ...mapGetters({
        isAuthenticated: "auth/isAuthenticated",
        user: "auth/user"
      })
    },
    methods: {
      logOut() {
        this.$store.dispatch("auth/logout");
        this.$router.push("/");
      },
    },
  };
</script>