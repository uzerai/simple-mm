<template>
  <table class="table-auto">
    <thead class="bg-slate-500">
      <tr>
        <th class="py-2">
          Match ID:
        </th>
        <th class="py-2">
          Match Type:
        </th>
        <th class="py-2">
          State:
        </th>
        <th class="py-2">
          Started at
        </th>
        <th class="py-2">
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
        <td class="py-2">
          <router-link :to="{ name: 'match', params: { match_id: match.id } }">
            {{ match.id }}
          </router-link>
        </td>
        <td class="py-2">
          {{ match.match_type?.name }}
        </td>
        <td class="py-2">
          {{ match.state }}
        </td>
        <td class="py-2">
          {{ match.started_at }}
        </td>
        <td class="py-2">
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