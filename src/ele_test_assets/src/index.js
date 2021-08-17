import Vue from 'vue'
import App from './App.vue'
import router from './router'
Vue.use(router);
import store from './store'

import ElementUI from 'element-ui';
import 'element-ui/lib/theme-chalk/index.css';
Vue.use(ElementUI);
import axios from 'axios';
import i18n from './i18n/i18n'
Vue.config.productionTip = false;
Vue.prototype.axios = axios;
new Vue({
  router,
  i18n,
  store,
  render: (h) => h(App)
}).$mount('#app')

