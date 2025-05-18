import { createApp } from 'vue'
import App from './App.vue'
import '@/assets/style/index.less'
// 引入全局样式
import ElementPlus from 'element-plus'
import 'element-plus/dist/index.css'
import DataVVue3 from '@kjgl77/datav-vue3'
import ICon from 'ant-design-vue/es/icon/index';
import Antd from "ant-design-vue/lib/index";
import "/node_modules/ant-design-vue/dist/reset.css";
import 'virtual:svg-icons-register'
// 导入路由
import router from '@/router/index'
import Particles from "@tsparticles/vue3";
import { loadSlim } from "@tsparticles/slim";
import pinia from "@/store/index"
const app = createApp(App)
app.use(router)
app.use(Particles, {
    init: async engine => {
        await loadSlim(engine);
    },
});
app.use(ElementPlus)
app.use(Antd).use(ICon)
app.use(DataVVue3);
app.use(pinia)
app.mount('#app')
