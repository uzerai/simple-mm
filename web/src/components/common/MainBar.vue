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
    <div
      v-else
      class="flex flex-shrink items-center text-xs md:text-base text-white mx-6 gap-4 mr-6" 
    >
      <img 
        :src="$store.getters['api_host'] + user.avatar" 
        class="inline-flex justify-center w-full rounded-full h-8 w-8 ring-2 ring-white cursor-pointer profile-image"
      >
      <!-- having this be the element which has the hover-show effect means the menu will stay open
          when the mouse is between the profile image and the menu. -->
      <div class="origin-top-right top-0 right-0.5 absolute profile-menu pt-16 group text-sm z-50">
        <div class="bg-darkt-900 group-hover:border-b group-hover:border-l border-darkt-600 rounded-bl-lg flex flex-col hover:focus pl-5 pr-6">
          <button
            class="hover:text-blue-sapphire text-neutral-400 fill-neutral-400 hover:fill-blue-sapphire p-2 my-2"
            @click="console.log('Settings')"
          >
            <svg
              xmlns="http://www.w3.org/2000/svg"
              xmlns:xlink="http://www.w3.org/1999/xlink"
              version="1.1"
              x="0px"
              y="0px"
              viewBox="0 0 486.4 486.4"
              xml:space="preserve"
              class="w-4 h-4 inline"
            >
              <g>
                <path d="M454.8,195.05h-20.7c-4.7-18.6-12-36.3-21.9-52.7l14.7-14.7c6-6,9.3-13.9,9.3-22.4s-3.3-16.4-9.3-22.4l-23.4-23.4    c-6-6-13.9-9.3-22.4-9.3s-16.4,3.3-22.4,9.3l-14.6,14.8c-16.5-9.9-34.1-17.2-52.7-21.9v-20.7c0-17.4-14.2-31.6-31.6-31.6h-33    c-17.4,0-31.6,14.2-31.6,31.6v20.7c-18.6,4.7-36.3,12-52.7,21.9l-14.7-14.7c-6-6-13.9-9.3-22.4-9.3S89,53.55,83,59.55l-23.5,23.4    c-6,6-9.3,13.9-9.3,22.4s3.3,16.4,9.3,22.4l14.7,14.6c-9.9,16.5-17.2,34.1-21.9,52.7H31.6c-17.4,0-31.6,14.2-31.6,31.6v33    c0,17.4,14.2,31.6,31.6,31.6h20.7c4.7,18.6,12,36.3,21.9,52.7l-14.7,14.7c-6,6-9.3,13.9-9.3,22.4s3.3,16.4,9.3,22.4l23.4,23.4    c6,6,13.9,9.3,22.4,9.3s16.4-3.3,22.4-9.3l14.7-14.7c16.5,9.9,34.1,17.2,52.7,21.9v20.7c0,17.4,14.2,31.6,31.6,31.6h33    c17.4,0,31.6-14.2,31.6-31.6v-20.7c18.6-4.7,36.3-12,52.7-21.9l14.7,14.7c6,6,13.9,9.3,22.4,9.3s16.4-3.3,22.4-9.3l23.4-23.4    c6-6,9.3-13.9,9.3-22.4s-3.3-16.4-9.3-22.4l-14.7-14.5c9.9-16.5,17.2-34.1,21.9-52.7h20.7c17.4,0,31.6-14.2,31.6-31.6v-33    C486.4,209.25,472.2,195.05,454.8,195.05z M462.4,259.75c0,4.2-3.4,7.6-7.6,7.6h-30.3c-5.7,0-10.7,4-11.8,9.7    c-4.4,22.3-13.1,43.2-25.7,62.1c-3.2,4.8-2.6,11.1,1.5,15.2l21.5,21.5c1.4,1.4,2.2,3.4,2.2,5.4s-0.8,4-2.2,5.4l-23.4,23.4    c-1.4,1.4-3.4,2.2-5.4,2.2s-4-0.8-5.4-2.2l-21.5-21.5c-4-4-10.4-4.7-15.2-1.5c-18.9,12.7-39.8,21.3-62.1,25.7    c-5.6,1.1-9.7,6-9.7,11.8v30.3c0,4.2-3.4,7.6-7.6,7.6h-33c-4.2,0-7.6-3.4-7.6-7.6v-30.3c0-5.7-4-10.7-9.7-11.8    c-22.3-4.4-43.2-13.1-62.1-25.7c-2-1.4-4.4-2-6.7-2c-3.1,0-6.2,1.2-8.5,3.5l-21.5,21.5c-1.4,1.4-3.4,2.2-5.4,2.2s-4-0.8-5.4-2.2    l-23.4-23.4c-1.4-1.4-2.2-3.4-2.2-5.4s0.8-4,2.2-5.4l21.5-21.5c4-4,4.7-10.4,1.5-15.2c-12.7-18.9-21.3-39.8-25.7-62.1    c-1.1-5.6-6-9.7-11.8-9.7H31.6c-4.2,0-7.6-3.4-7.6-7.6v-33c0-4.2,3.4-7.6,7.6-7.6h30.3c5.7,0,10.7-4,11.8-9.7    c4.4-22.3,13.1-43.2,25.7-62.1c3.2-4.8,2.6-11.1-1.5-15.2l-21.5-21.5c-1.4-1.4-2.2-3.4-2.2-5.4s0.8-4,2.2-5.4l23.4-23.4    c1.4-1.4,3.4-2.2,5.4-2.2s4,0.8,5.4,2.2l21.5,21.5c4,4,10.4,4.7,15.2,1.5c18.9-12.7,39.8-21.3,62.1-25.7c5.6-1.1,9.7-6,9.7-11.8    v-30.3c0-4.2,3.4-7.6,7.6-7.6h33c4.2,0,7.6,3.4,7.6,7.6v30.3c0,5.7,4,10.7,9.7,11.8c22.3,4.4,43.2,13.1,62.1,25.7    c4.8,3.2,11.1,2.6,15.2-1.5l21.5-21.5c1.4-1.4,3.4-2.2,5.4-2.2s4,0.8,5.4,2.2l23.4,23.4c1.4,1.4,2.2,3.4,2.2,5.4s-0.8,4-2.2,5.4    l-21.5,21.5c-4,4-4.7,10.4-1.5,15.2c12.7,18.9,21.3,39.8,25.7,62.1c1.1,5.6,6,9.7,11.8,9.7h30.3c4.2,0,7.6,3.4,7.6,7.6V259.75z" />
                <path d="M313.7,181.65c4.4-5,3.9-12.5-1-16.9c-5-4.4-12.5-3.9-16.9,1c-4.4,5-3.9,12.6,1,16.9c2.3,2,5.1,3,7.9,3    C308,185.65,311.3,184.25,313.7,181.65z" />
                <path d="M280.9,314.75c-5.9,3.1-8.1,10.4-5,16.2c2.1,4.1,6.3,6.4,10.6,6.4c1.9,0,3.8-0.4,5.6-1.4c5.9-3.1,8.1-10.4,5-16.2    C294,313.95,286.8,311.65,280.9,314.75z" />
                <path d="M268.2,141.35c-6.4-1.6-12.9,2.4-14.5,8.8c-1.6,6.4,2.4,12.9,8.8,14.5c1,0.2,1.9,0.3,2.9,0.3c5.4,0,10.3-3.7,11.6-9.1    C278.6,149.45,274.6,142.95,268.2,141.35z" />
                <path d="M160,286.15c-5.4,3.8-6.8,11.3-3,16.7c2.3,3.4,6.1,5.2,9.9,5.2c2.4,0,4.7-0.7,6.8-2.1c5.4-3.8,6.8-11.3,3-16.7    C172.9,283.75,165.4,282.35,160,286.15z" />
                <path d="M326.5,285.95c-5.5-3.8-12.9-2.4-16.7,3.1c-3.8,5.5-2.4,12.9,3.1,16.7c2.1,1.4,4.5,2.1,6.8,2.1c3.8,0,7.6-1.8,9.9-5.2    C333.3,297.25,332,289.75,326.5,285.95z" />
                <path d="M336.8,242.35c-6.6-0.8-12.5,3.9-13.3,10.5l0,0c-0.8,6.6,3.9,12.6,10.5,13.3c0.5,0.1,1,0.1,1.4,0.1    c6,0,11.2-4.5,11.9-10.6C348.1,249.15,343.4,243.15,336.8,242.35z" />
                <path d="M330,222.15c1.4,0,2.9-0.3,4.3-0.8c6.2-2.4,9.3-9.3,6.9-15.5s-9.3-9.3-15.5-6.9c-6.2,2.4-9.3,9.3-6.9,15.5    C320.6,219.25,325.2,222.15,330,222.15z" />
                <path d="M162.9,253.05c-0.8-6.6-6.8-11.3-13.4-10.5c-6.6,0.8-11.3,6.8-10.5,13.4c0.7,6.1,5.9,10.6,11.9,10.6c0.5,0,1,0,1.4-0.1    C159,265.65,163.7,259.65,162.9,253.05z" />
                <path d="M152.1,221.55c1.4,0.5,2.8,0.8,4.3,0.8c4.8,0,9.4-2.9,11.2-7.8c2.4-6.2-0.8-13.1-7-15.5c-6.2-2.3-13.1,0.8-15.5,7l0,0    C142.8,212.35,145.9,219.25,152.1,221.55z" />
                <path d="M243.4,324.05C243.3,324.05,243.3,324.05,243.4,324.05c-0.1,0-0.1,0-0.2,0c-6.6,0-12,5.4-12,12s5.4,12,12,12h0.1h0.1    c6.6,0,12-5.4,12-12C255.4,329.45,250,324.05,243.4,324.05z" />
                <path d="M232.5,150.25c-1.6-6.4-8.1-10.4-14.5-8.8c-6.4,1.6-10.4,8.1-8.8,14.5c1.3,5.5,6.3,9.1,11.6,9.1c0.9,0,1.9-0.1,2.9-0.4    C230.2,163.15,234.1,156.65,232.5,150.25z" />
                <path d="M205.6,314.85c-5.9-3.1-13.1-0.8-16.2,5c-3.1,5.9-0.8,13.1,5,16.2c1.8,0.9,3.7,1.4,5.6,1.4c4.3,0,8.5-2.3,10.6-6.4    C213.8,325.25,211.5,317.95,205.6,314.85z" />
                <path d="M190.5,165.85c-4.4-5-12-5.4-16.9-1s-5.4,12-1,16.9c2.4,2.7,5.7,4,9,4c2.8,0,5.7-1,8-3    C194.5,178.35,195,170.75,190.5,165.85z" />
              </g>
            </svg>
          </button>
          <hr class="border-darkt-700">
          <div class="pt-2 pb-4">
            <button
              class="hover:text-blue-sapphire text-neutral-400 fill-neutral-400 hover:fill-blue-sapphire p-2"
              @click="logOut"
            >
              <svg
                xmlns="http://www.w3.org/2000/svg"
                viewBox="0 0 1024 1024"
                class="w-4 h-4 inline"
              >
                <path d="M868 732h-70.3c-4.8 0-9.3 2.1-12.3 5.8-7 8.5-14.5 16.7-22.4 24.5a353.84 353.84 0 0 1-112.7 75.9A352.8 352.8 0 0 1 512.4 866c-47.9 0-94.3-9.4-137.9-27.8a353.84 353.84 0 0 1-112.7-75.9 353.28 353.28 0 0 1-76-112.5C167.3 606.2 158 559.9 158 512s9.4-94.2 27.8-137.8c17.8-42.1 43.4-80 76-112.5s70.5-58.1 112.7-75.9c43.6-18.4 90-27.8 137.9-27.8 47.9 0 94.3 9.3 137.9 27.8 42.2 17.8 80.1 43.4 112.7 75.9 7.9 7.9 15.3 16.1 22.4 24.5 3 3.7 7.6 5.8 12.3 5.8H868c6.3 0 10.2-7 6.7-12.3C798 160.5 663.8 81.6 511.3 82 271.7 82.6 79.6 277.1 82 516.4 84.4 751.9 276.2 942 512.4 942c152.1 0 285.7-78.8 362.3-197.7 3.4-5.3-.4-12.3-6.7-12.3zm88.9-226.3L815 393.7c-5.3-4.2-13-.4-13 6.3v76H488c-4.4 0-8 3.6-8 8v56c0 4.4 3.6 8 8 8h314v76c0 6.7 7.8 10.5 13 6.3l141.9-112a8 8 0 0 0 0-12.6z" />
              </svg>
            </button>
          </div>
        </div>
      </div>
    </div>
  </div>

  <transition name="queuebar">
    <div
      v-if="show_queue_bar"
      class="absolute flex w-full h-10 bg-emerald-600 border-b border-t border-emerald-300 items-center shimmer z-20"
    >
      <div class="flex-grow" />
      <span class="text-emerald-100 mr-24 text-sm italic">{{ matchmaking_message }}</span>
      <button
        class="text-emerald-100 hover:text-darkt-800 mr-6 cursor-pointer"
        @click="$store.dispatch('matchmaking/stopActiveQueue')"
      >
        &times;
      </button>
    </div>
  </transition>
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
    data() {
      return {};
    },
    computed: {
      ...mapGetters({
        isAuthenticated: "auth/isAuthenticated",
        user: "auth/user",
        matchmaking_status: "matchmaking/status"
      }),
      show_queue_bar() {
        return this.matchmaking_status > 0 && this.matchmaking_status < 3;
      },
      matchmaking_message() {
        switch(this.matchmaking_status) {
          case 0:
            return "";
          case 1:
            return "Matchmaking ...";
          case 2:
            return "Found match ";
          case 3: 
            return "Scheduling match ...";
          default:
            return "";
        }
      }
    },
    methods: {
      logOut() {
        this.$store.dispatch("auth/logout");
        this.$router.push("/");
        this.dropdown_open = false;
      },
    },
  };
</script>
<style scoped>
  .queuebar-enter-active {
    animation: .4s sweep-in;
    transition-timing-function: ease-in-out;
  }

  .queuebar-leave-active {
    animation: .4s sweep-out;
    transition-timing-function: cubic-bezier(0, 0, 0.58, 1);
  }

  @keyframes sweep-in {
    0% { clip-path: inset(0 100% 0 0); }
    100% { clip-path: inset(0); }
  }

  @keyframes sweep-out {
    0% { clip-path: inset(0); }
  100% { clip-path: inset(0 0 0 100%); }
  }

  .profile-menu {
    display: none;
  }

  .profile-menu:hover {
    display: block;
  }

  .profile-image:hover ~ .profile-menu {
    display: block;
  }
</style>