<template>
    <div class="left">
        <div id="chartleft" style="width: 100%;min-height: 90vh;margin-top: 2vh;">
        </div>
    </div>
</template>
<script setup lang="ts">
import { onMounted } from 'vue';
import * as echarts from 'echarts';

onMounted(() => {
    let myChart = echarts.init(document.getElementById('chartleft'), null);
    myChart.showLoading();
    myChart.hideLoading();
    const startMoveDataZoom = () => {
        dataZoomMoveTimer = setInterval(() => {
            dataZoomMove.start += 1;
            dataZoomMove.end += 1;
            if (dataZoomMove.end > data.value.length - 1) {
                dataZoomMove.start = 0;
                dataZoomMove.end = 10;
            }
            myChart.setOption({
                dataZoom: [
                    {
                        type: "slider", // 有type这个属性，滚动条在最下面，也可以不行，写y：36，这表示距离顶端36px，一般就是在图上面。
                        startValue: dataZoomMove.start,
                        endValue: dataZoomMove.end,
                    },
                ],
            });
        }, 1000);
    };
    startMoveDataZoom()
    let chartDom = myChart.getDom();
    chartDom.addEventListener('mouseout', () => {
        // @ts-ignore 
        if (dataZoomMoveTimer) return;
        // @ts-ignore 
        let dataZoomMove_get = myChart.getOption().dataZoom[0];
        dataZoomMove.start = dataZoomMove_get.startValue;
        dataZoomMove.end = dataZoomMove_get.endValue;
        startMoveDataZoom();
    })
    chartDom.addEventListener('mouseover', () => {
        // @ts-ignore 
        clearInterval(dataZoomMoveTimer);
        dataZoomMoveTimer = undefined;
    })
    myChart.setOption(option);
    window.onresize = myChart.resize;
})

// var yData1 =[
//     {
//         name: '广西',
//         value: 100
//     },
//     {
//         name: '广东',
//         value: 100
//     },
//     {
//         name: '北京',
//         value: 100
//     },
//     {
//         name: '山东',
//         value: 100
//     },
//     {
//         name: '黑龙江',
//         value: 100
//     },
//     {
//         name: '吉林',
//         value: 100
//     },
//     {
//         name: '辽宁',
//         value: 100
//     },
//     {
//         name: '河北',
//         value: 100
//     },
//     {
//         name: '天津',
//         value: 100
//     },
//     {
//         name: '内蒙古',
//         value: 100
//     },
//     {
//         name: '新疆',
//         value: 100
//     },
//     {
//         name: '香港',
//         value: 100
//     },
//     {
//         name: '澳门',
//         value: 100
//     },
//     {
//         name: '江西',
//         value: 100
//     },
//     {
//         name: '江苏',
//         value: 100
//     },
//     {
//         name: '浙江',
//         value: 100
//     },
//     {
//         name: '安徽',
//         value: 100
//     },
//     {
//         name: '福建',
//         value: 100
//     },
//     {
//         name: '湖北',
//         value: 100
//     },
//     {
//         name: '湖南',
//         value: 100
//     },
//     {
//         name: '福建',
//         value: 100
//     },
//     {
//         name: '河南',
//         value: 100
//     },
//     {
//         name: '山西',
//         value: 100
//     },
//     {
//         name: '陕西',
//         value: 100
//     },
//     {
//         name: '山西',
//         value: 100
//     },
//     {
//         name: '甘肃',
//         value: 100
//     },
//     {
//         name: '青海',
//         value: 100
//     },
//     {
//         name: '宁夏',
//         value: 100
//     },
//     {
//         name: '海南',
//         value: 100
//     },
//     {
//         name: '四川',
//         value: 100
//     },
//     {
//         name: '贵州',
//         value: 100
//     },
//     {
//         name: '西藏',
//         value: 100
//     },
//     {
//         name: '云南',
//         value: 100
//     },
//     {
//         name: '重庆',
//         value: 100
//     },
//     {
//         name: '台湾',
//         value: 100
//     },
//     {
//         name: '上海',
//         value: 100
//     },
// ] 
var yData = [

    '广西',
    '广东',
    '北京',
    '山东',
    '黑龙江',
    '吉林',
    '辽宁',
    '河北',
    '天津',
    '内蒙古',
    '新疆',
    '香港',
    '澳门',
    '江西',
    '江苏',
    '浙江',
    '安徽',
    '福建',
    '湖北',
    '湖南',
    '河南',
    '山西',
    '陕西',
    '甘肃',
    '青海',
    '宁夏',
    '海南',
    '四川',
    '贵州',
    '西藏',
    '云南',
    '重庆',
    '台湾',
    '上海',
];
// var data = [100, 30, 100.63, 0, 0, 69.91, 0, 10.88, 100, 10, 10, 10, 10, 10, 100];

const data = {
    label: yData,
    value: [11, 22, 33, 44, 55, 66, 77, 88, 99, 210, 32, 43, 190, 230, 400, 100, 200, 120, 120, 112, 210, 232, 20, 30, 200, 300, 200, 200, 400, 500, 600, 500, 400, 500]
}
let dataZoomMove = {
    start: 0,
    end: 10
}
// @ts-ignore 
let dataZoomMoveTimer = null
const title = {
    text: '各省市景点数量排名',
    textStyle: {
        color: '#fff',
        fontSize: 16,
    },
    top: 20,
    left: 'center',
};
let option = {
    backgroundColor: "rgba(00,33,66,0)",
    title,
    tooltip: {
        trigger: "axis",
        backgroundColor: "rgba(21, 154, 255, 0.32)",
        textStyle: {
            color: "#fff",
        },
        borderColor: "#159AFF",
        axisPointer: {
            lineStyle: {
                color: "transparent",
            },
        },
    },


    dataZoom: [
        {
            show: false, // 为true 滚动条出现
            startValue: dataZoomMove.start,
            endValue: dataZoomMove.end,
            yAxisIndex: [0, 1], //关联多个y轴
        },
        {
            //没有下面这块的话，只能拖动滚动条，鼠标滚轮在区域内不能控制外部滚动条
            type: "inside",
            yAxisIndex: 0,
            zoomOnMouseWheel: false, //滚轮是否触发缩放
            moveOnMouseMove: true, //鼠标滚轮触发滚动
            moveOnMouseWheel: true,
        },
    ],
    grid: {
        grid: { // 让图表占满容器
        top: "0px",
        left: "0px",
        right: "0px",
        bottom: "0px"
    },
    },
    xAxis: {
        type: "value",
        axisLabel: {
            show: false,
        },
        axisLine: {
            show: false,
        },
        axisTick: {
            show: false,
        },
        splitLine: {
            show: false,
        },
    },
    yAxis: [
        {
            type: "category",
            data: data.label,
            inverse: true,
            axisLabel: {
                inside: true,
                verticalAlign: "bottom",
                lineHeight: 36,
                margin: 2, //刻度标签与轴线之间的距离
                formatter: function (value: any) {
                    let k = data.label.indexOf(value);
                    let index = k < 9 ? "0" + (k + 1) : k + 1;
                    return `{b|${index}} {a|${value}}`;
                },
                rich: {
                    b: {
                        borderColor: "#fff",
                        borderWidth: 1,
                        padding: [3, 1, 0, 1],
                        color: "#fff",
                        fontSize: 14,
                    },
                    a: {
                        fontSize: 14,
                        color: "#D0DEEE",
                        padding: [4, 0, 0, 8],
                    },
                },
            },
            axisLine: {
                show: false,
            },
            axisTick: {
                show: false,
            },
            splitLine: {
                show: false,
            },
        },

        {
            type: "category",
            data: data.label,
            inverse: true,
            axisLabel: {
                inside: true,
                verticalAlign: "bottom",
                lineHeight: 34,
                margin: 2,
                formatter: function (value: any) {
                    let k = data.label.indexOf(value);
                    let index = k;
                    return `{a|${data.value[index]}}`;
                },
                rich: {
                    a: {
                        fontSize: 16,
                        color: "#fff",
                        padding: [4, 0, 0, 0],
                        fontFamily: "DOUYU",
                    },
                },
            },
            axisLine: {
                show: false,
            },
            axisTick: {
                show: false,
            },
            splitLine: {
                show: false,
            },
        },
    ],
    series: [
        {
            data: data.value,
            type: "bar",
            barWidth: 6,
            showBackground: true,
            backgroundStyle: {
                color: "rgba(128, 136, 142, 0.4)",
                borderRadius: 50,
            },
            itemStyle: {
                borderRadius: 50,
                color: "#159AFF",
            },
        },
    ],
};

</script>

<style scoped lang="less"></style>