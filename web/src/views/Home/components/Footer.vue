<template>
    <div class="footer">
        <!-- <div id="chartfooterdemo1"></div> -->
    </div>
</template>
<script setup lang="ts">
import {  onMounted  } from 'vue';
// import * as echarts from 'echarts';
onMounted (() => {
    // let myChart = echarts.init(document.getElementById('chartfooterdemo1'), null, {
    //     width: '10',
    //     height: '15',
    // });
    // myChart.showLoading();
    // myChart.hideLoading();
    // myChart.setOption(option);


    // 点击事件:鼠标移入
    // myChart.on('mouseover', function (params: any) {
    // });
})
//做环形图的本质是 radius: ['内半径', '外半径'] 内半径!=0
//画渐变色的原理是：data里面可以设置itemStyle



</script>

<style scoped></style>