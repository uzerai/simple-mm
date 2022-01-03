<template>
  <div class="w-full h-screen absolute -top-16 pointer-events-none">
  <content id="absolute-centered" class="w-full h-full flex items-center justify-center">
    <div id="pointer-events-reenabled" class="pointer-events-auto">
      <h1 class="text-2xl text-gray-700 italic font-bold ">Home</h1>
    </div>
  </content>
  </div>
</template>

<script>
export default {
  name: "Home",
  props: {},
  components: {},
  methods: {},
};
</script>
