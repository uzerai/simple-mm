<template>
  <div class="w-full h-screen absolute -top-16 pointer-events-none">
    <main
      id="absolute-centered"
      class="w-full h-full flex items-center justify-center"
    >
      <div
        id="pointer-events-reenabled"
        class="pointer-events-auto"
      >
        <h1 class="text-2xl text-gray-700 dark:text-slate-200 italic font-bold">
          Home
        </h1>
      </div>
    </main>
  </div>
</template>

<script>
export default {
  name: "Home",
  components: {},
  props: {},
  methods: {},
};
</script>
