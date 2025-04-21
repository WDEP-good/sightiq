<template>
    <div class="heilongjiang">
        <div id="chartHeiLongJiang"></div>
    </div>
</template>
<script setup lang="ts">
import * as echarts from "echarts";
var index = 0; //播放所在下标
import { onMounted } from 'vue'
// @ts-ignore
import heilongjiangjson from '@/assets/230000.json'
var mapGuangxiData = [{
    name: '全省',
    tradeBidsectionCount: 100,
    tradeProjectCount: 200,
    coordinate: [126.642464, 45.756967]
}, {
    name: '哈尔滨市',
    tradeBidsectionCount: 100,
    tradeProjectCount: 200,
    coordinate: [126.642464, 45.756967]
}, {
    name: '牡丹江市',
    tradeBidsectionCount: 100,
    tradeProjectCount: 200,
    coordinate:[
                    129.618602,
                    44.582962
                ]
}, {
    name: '大庆市',
    tradeBidsectionCount: 100,
    tradeProjectCount: 200,
    coordinate: [
                    125.11272,
                    46.590734
                ]
}, {
    name: '齐齐哈尔市',
    tradeBidsectionCount: 100,
    tradeProjectCount: 200,
    coordinate: [
        123.95792,
        47.342081
    ]
}, {
    name: '绥化市',
    tradeBidsectionCount: 100,
    tradeProjectCount: 200,
    coordinate: [
                    126.99293,
                    46.637393
                ]
}, {
    name: '七台河市',
    tradeBidsectionCount: 100,
    tradeProjectCount: 200,
    coordinate: [
                    131.015584,
                    45.771266
                ]
}, {
    name: '鸡西市',
    tradeBidsectionCount: 100,
    tradeProjectCount: 200,
    coordinate:  [
                    132.297639,
                    45.635227
                ]
}, {
    name: '黑河市',
    tradeBidsectionCount: 100,
    tradeProjectCount: 200,
    coordinate: [
                    127.499023,
                    50.249585
                ]
}, {
    name: '伊春市',
    tradeBidsectionCount: 100,
    tradeProjectCount: 200,
    coordinate: [
                    128.899396,
                    47.724775
                ]
}, {
    name: '鹤岗市',
    tradeBidsectionCount: 100,
    tradeProjectCount: 200,
    coordinate: [
                    130.807059,
                    47.644529
                ]
}, {
    name: '佳木斯市',
    tradeBidsectionCount: 100,
    tradeProjectCount: 200,
    coordinate: [
                    130.361634,
                    46.809606
                ]
}, {
    name: '双鸭山市',
    tradeBidsectionCount: 100,
    tradeProjectCount: 200,
    coordinate:  [
                    131.157304,
                    46.643442
                ]
}, {
    name: '大兴安岭地区',
    tradeBidsectionCount: 100,
    tradeProjectCount: 200,
    coordinate: [
                    124.711526,
                    52.335262
                ]
}];
echarts.registerMap('黑龙江', heilongjiangjson);
onMounted(() => {
    let MapHeiLongJiang = echarts.init(document.getElementById('chartHeiLongJiang'));
    MapHeiLongJiang.setOption(option, true);
    MapHeiLongJiang.on('mouseover', function (params) {
        console.log(params);
        clearInterval(showTip);
        MapHeiLongJiang.dispatchAction({
            type: 'showTip',
            seriesIndex: 0,
            dataIndex: params.dataIndex,
        });
    });
    var showTip = setInterval(function () {
        MapHeiLongJiang.dispatchAction({
            type: 'showTip',
            seriesIndex: 0,
            dataIndex: index,
        });
        index++;
        if (index >= 14) {
            index = 0;
        }
    }, 2000);
    MapHeiLongJiang.on('mouseout', function (params) {
        showTip && clearInterval(showTip);
        showTip = setInterval(function () {
            MapHeiLongJiang.dispatchAction({
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
        map: "黑龙江",
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
        map: "黑龙江",
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
        map: "黑龙江",
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
        map: "黑龙江",
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
        map: "黑龙江",
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
        name: "黑龙江市数据",
        type: "map",
        map: "黑龙江", // 自定义扩展图表类型
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
        data: mapGuangxiData,
    },],
};

</script>

<style scoped>
#chartHeiLongJiang {
    position: absolute;
    left: 0;
    right: 0;
    top: 0;
    bottom: 0;
}
</style>