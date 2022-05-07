<template>
  <!-- eslint-disable vue/no-v-html -->
  <div
    class="markdown-area mr-4"
    v-html="markdownHTML"
  />
  <!-- eslint-enable vue/no-v-html -->
</template>

<script>
import { marked } from "marked";

export default {
  name: "Markdown",
  props: {
    markdown: {
      type: String,
      required: true
    },
  },
  computed: {
    markdownHTML () {
      return marked.parse(this.markdown);
    }
  }
};
</script>

<style>
  .markdown-area {
    @apply overflow-y-scroll scroll-smooth;
  }

  .markdown-area h1{
    @apply text-4xl underline my-4;
  }

  .markdown-area h2 {
    @apply text-3xl my-2;
  }

  .markdown-area h3 {
    @apply text-2xl my-1;
  }

  .markdown-area h4 {
    @apply text-xl my-0.5;
  }
  
  .markdown-area p {
    @apply my-4;
  }

  .markdown-area a {
    @apply text-blue-400 underline;
  }

  .markdown-area hr {
    @apply my-6 mr-4;
  }
</style>