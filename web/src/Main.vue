<!-- 
  Super simple main component for handling routing throughout the application.
-->
<template>
  <div id="main" class="">
    <MainBar v-bind:routes="routes"/>
    <div id="main-content">
     <router-view></router-view>
    </div>
  </div>
</template>

<script>
import routes from "./routes"
import MainBar from "./components/common/MainBar";

export default {
  name: "Main",
  props: {},
  data() {
    return {
      routes
    }
  },
  methods: {},
  components: {
    MainBar
  }
};
</script>
