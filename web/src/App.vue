<template>
  <div className="grid place-items-center h-screen">
    <div className="bg-blue-200 p-8 rounded-lg">
      <h1 className="text-3xl font-bold text-gray-900">Simple Matchmaking</h1>
      <hr className="my-2 border-gray-700"/>
      <PlayerTable />
    </div>
  </div>
</template>

<script>
  import PlayerTable from './components/PlayerTable.vue'

  export default {
    name: 'App',
    props: {},
    components: {
      PlayerTable
    }
  }
</script>

