import Vue from 'vue'
import Router from 'vue-router'

Vue.use(Router);

export default new Router({
  routes:[
    {
      path:'',
      name:'main',
      component: () => import('../views/Main.vue'),
    },
    {
      path:'/library',
      name:'library',
      component: () => import('../views/library/index.vue'),
    },
    {
      path:'/dapp',
      name:'dapp',
      component: () => import('../views/dapp/index.vue'),
    },
  ],
  //默认是hash模式，url带#
  //history模式，不带#，但是不能在github，fleek中部署
  // mode:'history'
})
