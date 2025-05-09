<template>
    <HomeBg />
    <div class="home">
       
        <Left />
        <Right />
        <Footer />
    </div>
</template>
<script setup lang="ts">

import Left from './components/Left.vue';
import Right from './components/Right.vue';
import Footer from './components/Footer.vue';
import HomeBg from '@/components/homeBg.vue';
</script>

<style scoped lang="less">
.home {
    height: 100%;
    .demo-bg{
        position: fixed;
        top: 10vh;
        left: 40vh;
        width: 110vh;
        height: 60vh;
        overflow-x:hidden;
    }

    .header {
        min-width: 100vh;
        left: 0;
        min-height: 8vh;
        position: fixed;
        box-sizing: border-box;
        background-color: rgba(40, 44, 52, 0.5);
    }

    .left {
        border-radius: 0 20px 0 0;
        flex: 1;
        margin-top: 10vh;
        box-sizing: border-box;
        left: 0;
        width: 35vh;
        min-height: 100vh;
        margin-bottom: 10vh;
        
        position: fixed;
        overflow: hidden;
    }

    .right {
        border-radius: 20px 0 0 0;
        box-sizing: border-box;
        margin-top: 10vh;
        width: 35vh;
        min-height: 100vh;
        background-color: rgba(40, 44, 52, 0.5);
        position: fixed;
        right: 0;
        margin-bottom: -10vh;
        overflow: hidden;
        margin-left: 20px;
    }

    .footer {
        flex: 1;
        width: 90vh;
        margin-left: -45vh;
        left: 50%;
        box-sizing: border-box;
        background-color: rgba(40, 44, 52, 0.5);
        position: fixed;
        bottom: 0;
        min-height: 25vh;
        border-radius: 20px 20px 0 0;
    }
}
</style>