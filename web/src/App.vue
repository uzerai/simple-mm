<template>
  <div className="grid place-items-center h-screen">
    <div className="bg-blue-200 p-8 rounded-lg">
      <h1 className="text-3xl font-bold text-gray-900">Simple Matchmaking</h1>
      <hr className="my-2 border-gray-700"/>
      <PlayerTable />

      <h2>Current match:</h2>
      <button v-on:click="findMatch">Find match</button>
    </div>
  </div>
</template>

<script>
  import PlayerTable from './components/PlayerTable.vue'
  import { createConsumer } from "@rails/actioncable"

  export default {
    name: 'App',
    props: {},
    components: {
      PlayerTable
    },
    methods: {
      findMatch: function() {
        console.log("Creating consumer")
        let consumer = createConsumer('http://localhost:8010/cable')
        consumer.subscriptions.create({
            channel: "MatchmakingChannel" 
          },
          {
            received(data) {
            console.log("RECEIVED DATA:")
            console.dir(data)
          }
        })
        console.log("Finding Match...")
      }
    }
  }
</script>

