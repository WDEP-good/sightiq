<template>
    <div class="homeBg">
        <div id="chart"></div>
    </div>
</template>
<script setup lang="ts">
import { onMounted, reactive, watch } from "vue";
import * as echarts from "echarts";
import china from "@/assets/china.json";
import { GeoCoordMap } from "@/data/homeBgdata.ts";
import { data, convertData, img2, lineData } from "@/data/homeBgdata.ts";
import {useRouter} from 'vue-router'
const router = useRouter()
// @ts-ignore
echarts.registerMap("china", china);
let mapName = "china";
const geoCoordMap = reactive(GeoCoordMap);
// 定义展示数据
let toolTipData = reactive([
    {
        name: '湖南',
        value: 5,
        areas: ["长沙", "株洲", "益阳"]
    },
]);

/*获取地图数据*/
const mapFeatures = echarts.getMap(mapName).geoJson.features;
onMounted(() => {
    let myChart = echarts.init(document.getElementById("chart"));
    myChart.showLoading();
    myChart.hideLoading();
    myChart.setOption(Mapoption, true);

    // 点击事件:鼠标移入
    myChart.on("mouseover", function (params: any) {
        toolTipData[0].name = params.data.name
        toolTipData[0].value = 60
    });
    watch(
        toolTipData[0],
        async (nextsource) => {
            console.log(nextsource, 1);
            let map = echarts.init(document.getElementById('chart'));
            let Getoption: any = map.getOption() // 获取option数据
            Getoption.series[1].data = lineData(toolTipData) // 找到data修改数据
            Getoption.series[2].data = scatterData() // 找到data修改数据
            Getoption.series[3].data = convertData(toolTipData) // 找到data修改数据
            map.setOption(Getoption, true) // 重新渲染
        },
        {
            deep: true,
        }
    );
    myChart.on("click", function (params: any) {
        console.log(params.data);
        
        router.push({name:"city",query:params.data})

    });
});




mapFeatures.forEach(function (v: any) {
    // 地区名称
    var name = v.properties.name;

    // 地区经纬度
    // @ts-ignore
    geoCoordMap[name] = v.properties.cp;
});
function scatterData() {
    return toolTipData.map((item) => {
        // @ts-ignore
        return [geoCoordMap[item.name][0], geoCoordMap[item.name][1] + 2, item];
    });
}
// 处理地图

var Mapoption = {
    backgroundColor: "#003366",
    // 地图标题
    title: {
        show: true,
        text: "各省市景区数量图",
        x: "center",
        top: "80vh",
        textStyle: {
            color: "#fff",
            fontFamily: "等线",
            fontSize: 22,
        },
    },
    tooltip: {
        trigger: "none",
        formatter: function (params: any) {
            if (typeof params.value[2] == "undefined") {
                var toolTiphtml = "";
                for (var i = 0; i < toolTipData.length; i++) {
                    // @ts-ignore
                    if (params.name == toolTipData[i].name) {
                        // @ts-ignore
                        toolTiphtml += toolTipData[i].name + "：" + toolTipData[i].value;
                    }
                }
                return toolTiphtml;
            } else {
                var toolTiphtml = "";
                for (var i = 0; i < toolTipData.length; i++) {
                    // @ts-ignore
                    if (params.name == toolTipData[i].name) {
                        // @ts-ignore
                        toolTiphtml += toolTipData[i].name + ":" + toolTipData[i].value;
                    }
                }
                return toolTiphtml;
            }
        },
        backgroundColor: "#fff",
        borderColor: "#333",
        padding: [5, 10],
        textStyle: {
            color: "#333",
            fontSize: "16",
        },
    },
    // 国家地图边缘
    geo: [
        {
            layoutCenter: ["50%", "40%"], //位置
            layoutSize: "150%", //大小
            show: true,
            map: mapName,
            roam: false,
            zoom: 0.65,
            aspectScale: 1,
            label: {
                normal: {
                    show: false,
                    textStyle: {
                        color: "#fff",
                    },
                },
                emphasis: {
                    show: true,
                    textStyle: {
                        color: "#fff",
                    },
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
                        colorStops: [
                            {
                                offset: 0,
                                color: "rgba(3,27,78,0.75)", // 0% 处的颜色
                            },
                            {
                                offset: 1,
                                color: "rgba(58,149,253,0.75)", // 50% 处的颜色
                            },
                        ],
                        global: true, // 缺省为 false
                    },
                    borderColor: "#c0f3fb",
                    borderWidth: 1,
                    shadowColor: "#8cd3ef",
                    shadowOffsetY: 10,
                    shadowBlur: 120,
                },
                emphasis: {
                    areaColor: "rgba(0,254,233,0.6)",
                    // borderWidth: 0
                },
            },
        },
        {
            type: "map",
            map: mapName,
            zlevel: -1,
            aspectScale: 1,
            zoom: 0.65,
            layoutCenter: ["50%", "41%"],
            layoutSize: "150%",
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
        },
        {
            type: "map",
            map: mapName,
            zlevel: -2,
            aspectScale: 1,
            zoom: 0.65,
            layoutCenter: ["50%", "42%"],
            layoutSize: "150%",
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
        },
        {
            type: "map",
            map: mapName,
            zlevel: -3,
            aspectScale: 1,
            zoom: 0.65,
            layoutCenter: ["50%", "43%"],
            layoutSize: "150%",
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
        },
        {
            type: "map",
            map: mapName,
            zlevel: -4,
            aspectScale: 1,
            zoom: 0.65,
            layoutCenter: ["50%", "44%"],
            layoutSize: "150%",
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
    series: [
        {
            type: "map",
            map: mapName,
            geoIndex: 0,
            aspectScale: 1, //长宽比
            zoom: 0.65,
            showLegendSymbol: true,
            roam: true,
            label: {
                normal: {
                    show: true,
                    textStyle: {
                        color: "#fff",
                        fontSize: "100%",
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
                        colorStops: [
                            {
                                offset: 0,
                                color: "rgba(3,27,78,0.75)", // 0% 处的颜色
                            },
                            {
                                offset: 1,
                                color: "rgba(58,149,253,0.75)", // 50% 处的颜色
                            },
                        ],
                        global: true, // 缺省为 false
                    },
                    borderColor: "#fff",
                    borderWidth: 0.2,
                },
            },
            layoutCenter: ["50%", "50%"],
            layoutSize: "180%",
            animation: false,
            markPoint: {
                symbol: "none",
            },
            data: data,
        },
        //柱状体的主干
        {
            type: "lines",
            zlevel: 5,
            effect: {
                show: false,
                symbolSize: 5, // 图标大小
            },
            lineStyle: {
                width: 6, // 尾迹线条宽度
                color: "rgba(249, 105, 13, 0.6)",
                opacity: 1, // 尾迹线条透明度
                curveness: 0, // 尾迹线条曲直度
            },
            label: {
                show: 0,
                position: "end",
                formatter: "245",
            },
            silent: true,
            data: lineData(toolTipData),
        },
        // 柱状体的顶部
        {
            type: "scatter",
            coordinateSystem: "geo",
            geoIndex: 0,
            zlevel: 5,
            label: {
                normal: {
                    show: true,
                    formatter: function (params: any) {
                        var name = params.data[2].name;
                        var value = params.data[2].value;
                        var text = `{tline|${name}} : 旅游景区{fline|${value}}个`;
                        // var text = `{tline|项目个数} : {fline|${value}}`
                        return text;
                    },
                    color: "#fff",
                    rich: {
                        fline: {
                            // padding: [0, 25],
                            color: "#fff",
                            fontSize: 14,
                            fontWeight: 600,
                        },
                        tline: {
                            // padding: [0, 27],
                            color: "#ABF8FF",
                            fontSize: 12,
                        },
                    },
                },
                emphasis: {
                    show: true,
                },
            },
            itemStyle: {
                color: "#00FFF6",
                opacity: 1,
            },
            symbol: img2,
            symbolSize: [150, 60],
            symbolOffset: [0, -20],
            z: 999,
            data: scatterData(),
        },
        // 底部范围圈
        {
            name: "quan",
            type: "effectScatter",
            coordinateSystem: "geo",
            data: convertData(toolTipData),
            showEffectOn: "render",
            itemStyle: {
                normal: {
                    color: "#00FFFF",
                },
            },
            rippleEffect: {
                scale: 5,
                brushType: "stroke",
            },
            label: {
                normal: {
                    formatter: "{b}",
                    position: "bottom",
                    show: false,
                    color: "#fff",
                    distance: 10,
                },
            },
            symbol: "circle",
            symbolSize: [20, 10],
            zlevel: 4,
            lazyUpdate: true,
        },
    ],
};
</script>

<style scoped>
#chart {
    position: absolute;
    left: 0;
    right: 0;
    top: 0;
    bottom: 0;
}
</style>
