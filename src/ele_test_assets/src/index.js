import Vue from 'vue'
import App from './App.vue'
import './registerServiceWorker'
import router from './router'
import store from './store'
import './plugins/element.js'
import 'element-ui/lib/theme-chalk/index.css';

import 'bootstrap/dist/css/bootstrap.min.css'
import '@/assets/css/style.css'
import '@/assets/css/default.css'
import '@/assets/css/global.css'

Vue.config.productionTip = false

new Vue({
  router,
  store,
  render: h => h(App)
}).$mount('#app')
