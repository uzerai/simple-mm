<template>
  <table className="min-w-full">
    <thead className="bg-gray-100">
      <tr>
        <th className="text-left text-l tracking-wider" scope="col">
          Username
        </th>
        <th className="text-left text-l tracking-wider" scope="col">Rating</th>
      </tr>
    </thead>
    <tbody className="divide-y divide-gray-500">
      <tr v-for="player in players" :key="player.id">
        <td>{{ player.username }}</td>
        <td className="text-center">{{ player.rating }}</td>
      </tr>
    </tbody>
  </table>
</template>

<script>
export default {
  name: "PlayerTable",
  data() {
    return {
      players: [],
    };
  },
  async created() {
    const request = await fetch(`${this.$store.getters.api_host}/players`, {
      headers: {
        "Content-Type": "application/json",
        Authorization: `Bearer ${this.$store.getters["auth/token"]}`,
      },
    });

    if (request.ok) {
      const data = await request.json();
      this.players = data.results;
    }
  },
};
</script>
