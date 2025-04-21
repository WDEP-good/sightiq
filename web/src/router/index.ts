import {createWebHistory,createRouter} from 'vue-router';

const router = createRouter({
    history:createWebHistory(),
    routes:[
        {
            path:'/',
            name:'index',
            component:()=>import('@/views/Search/indexSearch.vue')
        },
        {
            path:'/home',
            name:'home',
            component:()=>import('@/views/Home/home.vue')
        },
        {
            path:'/Login',
            name:'Login',
            component:()=>import('@/views/Login.vue')
        },
        {
            path:'/nologin',
            name:'nologin',
            component:()=>import('@/views/no_login.vue')
        },
        {
            path:'/search',
            name:'search',
            component:()=>import('@/views/Search/indexSearch.vue')
        },
        {
            path:'/city',
            name:'city',
            component:()=>import('@/views/City/city.vue')
        },
    ]
    
});

export default router;