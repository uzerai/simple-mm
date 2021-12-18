import { createApp } from 'vue'
import { createRouter, createWebHistory } from "vue-router"

import routes from './routes';
import './styles/app.css'
import Main from './Main.vue'

const router = createRouter({
	history: createWebHistory(),
	routes,
})

const app = createApp(Main)

// Registering router to work on the app.
app.use(router)
app.mount('#app')
