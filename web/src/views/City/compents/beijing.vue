<template>
    <div class="beijing">
        <div id="chartBeijing"></div>
    </div>
</template>
<script setup lang="ts">
import * as echarts from "echarts";
var index = 0; //播放所在下标
import {onMounted} from 'vue'
// @ts-ignore
import beijingjson from '@/assets/450000.json'
var mapBeijingData = [{
    name: '全省',
    tradeBidsectionCount: 100,
    tradeProjectCount: 200,
    coordinate: [116.405285, 39.904989]
}, {
    name: '南宁市',
    tradeBidsectionCount: 100,
    tradeProjectCount: 200,
    coordinate: [108.320004, 22.82402]
}, {
    name: '柳州市',
    tradeBidsectionCount: 100,
    tradeProjectCount: 200,
    coordinate: [109.411703, 24.314617]
}, {
    name: '桂林市',
    tradeBidsectionCount: 100,
    tradeProjectCount: 200,
    coordinate: [110.299121, 25.274215]
}, {
    name: '梧州市',
    tradeBidsectionCount: 100,
    tradeProjectCount: 200,
    coordinate: [111.297604, 23.474803]
}, {
    name: '北海市',
    tradeBidsectionCount: 100,
    tradeProjectCount: 200,
    coordinate: [109.119254, 21.473343]
}, {
    name: '防城港市',
    tradeBidsectionCount: 100,
    tradeProjectCount: 200,
    coordinate: [108.345478, 21.614631]
}, {
    name: '钦州市',
    tradeBidsectionCount: 100,
    tradeProjectCount: 200,
    coordinate: [108.624175, 21.967127]
}, {
    name: '贵港市',
    tradeBidsectionCount: 100,
    tradeProjectCount: 200,
    coordinate: [109.602146, 23.0936]
}, {
    name: '玉林市',
    tradeBidsectionCount: 100,
    tradeProjectCount: 200,
    coordinate: [110.154393, 22.63136]
}, {
    name: '百色市',
    tradeBidsectionCount: 100,
    tradeProjectCount: 200,
    coordinate: [106.616285, 23.897742]
}, {
    name: '贺州市',
    tradeBidsectionCount: 100,
    tradeProjectCount: 200,
    coordinate: [111.552056, 24.414141]
}, {
    name: '河池市',
    tradeBidsectionCount: 100,
    tradeProjectCount: 200,
    coordinate: [108.062105, 24.695899]
}, {
    name: '来宾市',
    tradeBidsectionCount: 100,
    tradeProjectCount: 200,
    coordinate: [109.229772, 23.733766]
}, {
    name: '崇左市',
    tradeBidsectionCount: 100,
    tradeProjectCount: 200,
    coordinate: [107.353926, 22.404108]
}];
echarts.registerMap('北京', beijingjson);
onMounted(()=>{
    let MapGuangxi = echarts.init(document.getElementById('chartBeijing'));
    MapGuangxi.setOption(option, true);
    MapGuangxi.on('mouseover', function (params) {
    console.log(params);
    clearInterval(showTip);
    MapGuangxi.dispatchAction({
        type: 'showTip',
        seriesIndex: 0,
        dataIndex: params.dataIndex,
    });
});
var showTip = setInterval(function () {
    MapGuangxi.dispatchAction({
        type: 'showTip',
        seriesIndex: 0,
        dataIndex: index,
    });
    index++;
    if (index >= 14) {
        index = 0;
    }
}, 2000);
MapGuangxi.on('mouseout', function (params) {
    showTip && clearInterval(showTip);
    showTip = setInterval(function () {
        MapGuangxi.dispatchAction({
            type: 'showTip',
            seriesIndex: 0,
            dataIndex: index,
        });
        index++;
        if (index >= 14) {
            index = 0;
        }
    }, 2000);
});

})

let option = {
    backgroundColor: "#003366",
    tooltip: {
        trigger: 'item',
        position: function (point, params, dom, rect, size) {
            var x = 0; // x坐标位置
            var y = 0; // y坐标位置
            // 当前鼠标位置
            var pointX = point[0];
            var pointY = point[1];
            // 提示框大小
            var boxWidth = size.contentSize[0];
            var boxHeight = size.contentSize[1];

            // boxWidth > pointX 说明鼠标左边放不下提示框
            if (boxWidth > pointX) {
                x = pointX + 10;
            } else { // 左边放的下
                x = pointX - boxWidth - 10;
            }

            // boxHeight > pointY 说明鼠标上边放不下提示框
            if (boxHeight > pointY) {
                y = 5;
            } else { // 上边放得下
                y = pointY - boxHeight;
            }
            return [x, y];
        },
        show: true,
        enterable: true,
        textStyle: {
            fontSize: 13,
            color: '#fff',
        },
        backgroundColor: 'rgba(0,2,89,0.8)',
        formatter: function (params) {
            // console.log(params)
            var tipHtml = '';
            tipHtml = `
                    <div class="ui-map-img">
                        <div class='ui-maptxt'>${params.name}</div>
                        <div class='ui-mapNum'>标段数:${params.data.tradeBidsectionCount}</div>
                        <div class='ui-mapNum'>项目数:${params.data.tradeProjectCount}</div>
                    </div>
                `
            return tipHtml;
        },
    },
    geo: [{
        map: "北京",
        aspectScale: 1,
        zoom: 0.65,
        layoutCenter: ["50%", "50%"],
        layoutSize: "180%",
        show: true,
        roam: false,
        label: {
            emphasis: {
                show: false,
            },
        },
        itemStyle: {
            normal: {
                borderColor: "#c0f3fb",
                borderWidth: 1,
                shadowColor: "#8cd3ef",
                shadowOffsetY: 10,
                shadowBlur: 120,
                areaColor: "transparent",
            },
        }
    },
    // 重影
    {
        type: "map",
        map: "北京",
        zlevel: -1,
        aspectScale: 1,
        zoom: 0.65,
        layoutCenter: ["50%", "51%"],
        layoutSize: "180%",
        roam: false,
        silent: true,
        itemStyle: {
            normal: {
                borderWidth: 1,
                // borderColor:"rgba(17, 149, 216,0.6)",
                borderColor: "rgba(58,149,253,0.8)",
                shadowColor: "rgba(172, 122, 255,0.5)",
                shadowOffsetY: 5,
                shadowBlur: 15,
                areaColor: "rgba(5,21,35,0.1)",
            },
        },
    }, {
        type: "map",
        map: "北京",
        zlevel: -2,
        aspectScale: 1,
        zoom: 0.65,
        layoutCenter: ["50%", "52%"],
        layoutSize: "180%",
        roam: false,
        silent: true,
        itemStyle: {
            normal: {
                borderWidth: 1,
                // borderColor: "rgba(57, 132, 188,0.4)",
                borderColor: "rgba(58,149,253,0.6)",
                shadowColor: "rgba(65, 214, 255,1)",
                shadowOffsetY: 5,
                shadowBlur: 15,
                areaColor: "transpercent",
            },
        },
    }, {
        type: "map",
        map: "北京",
        zlevel: -3,
        aspectScale: 1,
        zoom: 0.65,
        layoutCenter: ["50%", "53%"],
        layoutSize: "180%",
        roam: false,
        silent: true,
        itemStyle: {
            normal: {
                borderWidth: 1,
                // borderColor: "rgba(11, 43, 97,0.8)",
                borderColor: "rgba(58,149,253,0.4)",
                shadowColor: "rgba(58,149,253,1)",
                shadowOffsetY: 15,
                shadowBlur: 10,
                areaColor: "transpercent",
            },
        },
    }, {
        type: "map",
        map: "北京",
        zlevel: -4,
        aspectScale: 1,
        zoom: 0.65,
        layoutCenter: ["50%", "54%"],
        layoutSize: "180%",
        roam: false,
        silent: true,
        itemStyle: {
            normal: {
                borderWidth: 5,
                // borderColor: "rgba(11, 43, 97,0.8)",
                borderColor: "rgba(5,9,57,0.8)",
                shadowColor: "rgba(29, 111, 165,0.8)",
                shadowOffsetY: 15,
                shadowBlur: 10,
                areaColor: "rgba(5,21,35,0.1)",
            },
        },
    },
    ],
    series: [{
        name: "北京市数据",
        type: "map",
        map: "北京", // 自定义扩展图表类型
        aspectScale: 1,
        zoom: 0.65, // 缩放
        showLegendSymbol: true,
        label: {
            normal: {
                show: true,
                textStyle: {
                    color: "#fff",
                    fontSize: "120%"
                },
            },
            emphasis: {
                // show: false,
            },
        },
        itemStyle: {
            normal: {
                areaColor: {
                    type: "linear",
                    x: 1200,
                    y: 0,
                    x2: 0,
                    y2: 0,
                    colorStops: [{
                        offset: 0,
                        color: "rgba(3,27,78,0.75)", // 0% 处的颜色
                    }, {
                        offset: 1,
                        color: "rgba(58,149,253,0.75)", // 50% 处的颜色
                    },],
                    global: true, // 缺省为 false
                },
                borderColor: "#fff",
                borderWidth: 0.2,
            },
            emphasis: {
                show: false,
                color: "#fff",
                areaColor: "rgba(0,254,233,0.6)",
            },
        },
        layoutCenter: ["50%", "50%"],
        layoutSize: "180%",
        markPoint: {
            symbol: "none",
        },
        data: mapBeijingData,
    },],
};

</script>

<style scoped>
#chart_guangxi {
    position: absolute;
    left: 0;
    right: 0;
    top: 0;
    bottom: 0;
}
</style>