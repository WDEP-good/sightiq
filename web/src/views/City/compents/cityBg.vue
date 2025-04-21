<template>
    <div class="cityBg">
        <GuangXi v-if="props.city === '广西'"/>
        <HeiLongJiang v-if="props.city === '黑龙江'"/>
        <div id="chart_guangdong"></div>
        <div id="chart_beijing"></div>
        <div id="chart_shanghai"></div>
        <div id="chart_shanxi"></div>
        <div id="chart_chongqing"></div>
        <div id="chart_neimonggu"></div>
    </div>
</template>
<script setup lang="ts">
import {defineProps} from 'vue'
import GuangXi from './guangxi.vue'
import HeiLongJiang from './heilongjiang.vue'
const props = defineProps({
    city:String
})
console.log(props);




</script>

<style scoped>

</style>
