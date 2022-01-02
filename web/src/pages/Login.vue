<template>
  <div class="flex w-full justify-center lg:m-6">
    <div class="lg:w-1/2 w-full rounded-lg lg:border border-gray-200 p-8">
      <h1 class="text-3xl italic font-bold text-gray-800 mb-2">Sign-in</h1>
      <hr class="mb-4"/>
      <section class="flex flex-col gap-4 w-full py-4">
        <div id="inputgroup-email" class="relative">
          <label for="email-input" class="text-sm text-gray-600 px-4 absolute -top-2 left-4 select-none bg-white border border-gray-200 ">Email:</label>
          <input id="email-input" type="text" v-model="email" placeholder="user@email.com" class=" w-full p-4 text-sm bg-gray-50 focus:outline-none border border-gray-200 rounded text-gray-600">
        </div>
        <div id="inputgroup-email" class="relative">
          <label for="password-input" class="text-sm text-gray-600 px-4 absolute -top-2 left-4 select-none bg-white border border-gray-200">Password:</label>
          <input id="password-input" type="password" v-model="password" placeholder="hunter2" class=" w-full p-4 text-sm bg-gray-50 focus:outline-none border border-gray-200 rounded text-gray-600">
        </div>

        <button class="w-full py-4 bg-green-600 hover:bg-green-700 rounded text-sm font-bold text-gray-50 transition duration-200" @click="attemptLogin">
          Sign In
        </button>

        <div class="flex items-center justify-between">
          <div class="flex flex-row items-center">
            <input type="checkbox" class="focus:ring-green-500 h-4 w-4 accent-green-600 border-gray-300 rounded" v-model="remember_me">

            <label for="comments" class="ml-2 text-sm font-normal text-gray-400">
              Remember me
            </label>
          </div>
          <div>
            <a class="text-sm text-blue-600 hover:underline" href="#">
              Forgot password?
            </a>
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
      error: null
    }
  },
  methods: {
    attemptLogin() { 
      this.$store.dispatch('auth/login', this.$data)
      this.$router.push("/")
    }
  },
};
</script>
