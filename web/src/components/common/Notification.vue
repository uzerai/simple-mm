<template>
  <div class="my-4 mx-6 p-4 rounded-sm z-50" :class="bg_class" >
    <p>{{this.message}}</p>
  </div>
</template>

<script>
export default {
  name: "Notification",
  props: ['message', 'uuid', 'type', 'disappear'],
  mounted () {
    if(this.disappear) {
      console.log(`Setting ${this.uuid} to disappear in ${this.disappear} ms`);
      setTimeout(() => this.$store.dispatch('removeNotification', this.uuid), this.disappear);
    }
  },
  computed: {
    bg_class: function () {
      let classes;
      switch(this.type) {
        case "error":
          classes = "bg-red-600 text-white border-red-800 border";
          break;
        case "success":
          classes = "bg-green-600 text-white border-green-800 border";
          break;
        default:
          classes = "bg-white border-slate-200"
      }

      return classes;
    }
  },
  methods: {},
  components: {},
};
</script>