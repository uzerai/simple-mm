<template>
  <table class="table-auto">
    <thead class="bg-slate-500">
      <tr>
        <th class="py-4">
          Match ID:
        </th>
        <th class="py-4">
          Match Type:
        </th>
        <th class="py-4">
          State:
        </th>
        <th class="py-4">
          Started at
        </th>
        <th class="py-4">
          Ended at
        </th>
      </tr>
    </thead>
    <tbody class="bg-darkt-500 text-center">
      <tr
        v-for="match in matches"
        :key="match"
        class="hover:bg-orange-800"
      >
        <td class="py-4">
          <router-link :to="{ name: 'match', params: { match_id: match.id } }">
            {{ match.id }}
          </router-link>
        </td>
        <td class="py-4">
          {{ match.match_type?.name }}
        </td>
        <td class="py-4">
          {{ match.state }}
        </td>
        <td class="py-4">
          {{ match.started_at }}
        </td>
        <td class="py-4">
          {{ match.ended_at }}
        </td>
      </tr>
    </tbody>
  </table>
</template>

<script>
export default {
  name: "MatchList",
  props: {
    matches: {
      type: Array,
      required: true
    }
  },
  methods: {},
};
</script>

<style scoped>
.background-image {
  background: linear-gradient(to top, rgba(0, 0, 0, 1), rgba(0, 0, 0, 0));
}
</style>