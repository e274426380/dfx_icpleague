import Vue from 'vue'
import VueRouter from 'vue-router'

Vue.use(VueRouter)

const routes = [
  {
    path: '/',
    name: 'Home',
    component: () => import('@/views/Home/Home.vue')
  },
  {
    path: '/library',
    name: 'Library',
    component: () => import('@/views/Library/Library.vue')
  },
  {
    path: '/dapp',
    name: 'Dapp',
    component: () => import('@/views/Dapp/Dapp.vue')
  },
  {
    path: '/hackathon',
    name: 'Hackathon',
    component: () => import('@/views/Hackathon/Hackathon.vue')
  },
  {
    path: '/sponsor',
    name: 'Sponsor',
    component: () => import('@/views/Sponsor/Sponsor.vue')
  }
]

const router = new VueRouter({
  mode: 'history',
  base: process.env.BASE_URL,
  routes,
  scrollBehavior() {
    return { x: 0, y: 0 }
  }
})

export default router
