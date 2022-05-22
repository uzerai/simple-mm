<template>
  <dialog
    ref="html5dialog"
    :open="open"
    class="dialog"
  >
    <slot />
  </dialog>
</template>
<script>
export default {
  name: "Dialog",
  props: {
    open: {
      type: Boolean,
      required: true
    },
    on_close: {
      type: Function,
      required: false,
      default: () => {}
    }
  },
  mounted() {
    // Binds the given on_close() property to the close event of the 
    // html5 dialog element.
    this.$refs.html5dialog.addEventListener("close", (event) => {
      if (this.on_close) {
        this.on_close(event);
      }
    });
  },
};
</script>
<style scoped>
  dialog::backdrop {
    background: rgba(0, 0, 0, 0.755);
  }
</style>