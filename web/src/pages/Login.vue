<template>
  <div class="flex w-full justify-center py-4 md:py-12">
    <div
      class="lg:w-1/2 w-full lg:rounded-sm lg:border border-gray-200 pt-8 px-8 pb-4 bg-white motion-safe:animate-fadeIn"
    >
      <h1 class="text-3xl italic font-bold text-gray-800 mb-2">
        Sign-in
      </h1>
      <hr class="mb-2">
      <section class="flex flex-col gap-4 w-full py-4">
        <div
          id="inputgroup-email"
          class="relative"
        >
          <label
            for="email-input"
            class="text-sm text-gray-600 px-4 absolute -top-2 left-4 select-none bg-white border border-gray-200"
          >Email:</label>
          <input
            id="email-input"
            v-model="email"
            type="text"
            placeholder="user@email.com"
            class="w-full p-4 text-sm bg-white focus:outline-none border border-gray-200 rounded text-gray-600"
          >
        </div>
        <div
          id="inputgroup-email"
          class="relative"
        >
          <label
            for="password-input"
            class="text-sm text-gray-600 px-4 absolute -top-2 left-4 select-none bg-white border border-gray-200"
          >Password:</label>
          <input
            id="password-input"
            v-model="password"
            type="password"
            placeholder="hunter2"
            class="w-full p-4 text-sm bg-white focus:outline-none border border-gray-200 rounded text-gray-600"
          >
        </div>

        <button
          class="w-full py-4 bg-green-600 hover:bg-green-700 rounded text-sm font-bold text-gray-50 transition duration-200"
          @click="attemptLogin"
        >
          Sign In
        </button>

        <div class="flex flex-col gap-2">
          <div class="flex items-center justify-between">
            <div class="flex flex-row items-center">
              <input
                v-model="remember_me"
                type="checkbox"
                class="focus:ring-green-500 h-4 w-4 accent-green-600 border-gray-300 rounded"
              >
              <label
                for="comments"
                class="ml-2 text-sm font-normal text-gray-400"
              >
                Remember me
              </label>
            </div>
            <router-link
              class="text-sm text-blue-600 hover:underline"
              to="/users/forgot"
            >
              Forgot password?
            </router-link>
          </div>
          <div class="flex flex-row justify-end items-center">
            <router-link
              class="text-sm text-slate-700 font-bold hover:underline"
              to="/signup"
            >
              New here?
            </router-link>
          </div>
        </div>
      </section>
    </div>
  </div>
</template>

<script>
export default {
  name: "Login",
  data() {
    return {
      email: "",
      password: "",
      remember_me: false,
      error: null,
    };
  },
  methods: {
    async attemptLogin() {
      await this.$store.dispatch("auth/login", this.$data);

      if (
        this.$route.query?.redirect &&
        this.$store.getters["auth/isAuthenticated"]
      ) {
        console.info("User is authenticated; redirecting ...");
        this.$router.push(this.$route.query.redirect);
      } else if(this.$store.getters["auth/isAuthenticated"]) {
        this.$router.push("/");
      }
    },
  },
};
</script>
