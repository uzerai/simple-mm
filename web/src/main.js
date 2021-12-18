import { createApp } from 'vue'
import { createRouter, createWebHistory } from "vue-router"

import routes from './routes';
import './styles/app.css'
import Main from './Main.vue'

// Router creation and initialization.
// update routes in the accompanying routes.js
const router = createRouter({
	history: createWebHistory(),
	routes,
})

// Vue app instantiation, binding Main as the main entrypoint component of the application.
const app = createApp(Main)

// Registering router to work on the app.
app.use(router)
app.mount('#app')
