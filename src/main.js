import Vue from 'vue'
import App from './App.vue'
import VueRouter from 'vue-router';
import './plugins/element.js'
import login from './components/login.vue'

Vue.config.productionTip = false

localStorage.cha = '0';

new Vue({
  render: h => h(App),
}).$mount('#app')
