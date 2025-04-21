import { defineStore } from 'pinia'


let homeStore = defineStore('homeStore', {
    state: () => {
        return {
            homedata: [],
            Tipdata: [
                {
                    name: '湖南',
                    value: 5,
                    areas: ["长沙", "株洲", "益阳"]
                },
                {
                    name: '安徽',
                    value: 3,
                    areas: ["合肥", "芜湖"]
                },
                {
                    name: '山东',
                    value: 80,
                    areas: ["济南", "青岛", "淄博", "烟台", "威海", "临沂"]
                },
                {
                    name: '四川',
                    value: 35,
                    areas: ["成都", "攀枝花", "乐山", "泸州"]
                },
                {
                    name: '云南',
                    value: 27,
                    areas: ["昆明", "玉溪", "丽江", "普洱", "临沧"]
                },
                {
                    name: '黑龙江',
                    value: 13,
                    areas: ["哈尔滨", "鹤岗", "黑河", "绥化", "大庆", "佳木斯"]
                },
                {
                    name: '甘肃',
                    value: 42,
                    areas: ["兰州", "嘉峪关", "天水", "酒泉"]
                },
                {
                    name: '西藏',
                    value: 74,
                    areas: []
                }
            ],
        }
    },
    actions: {

    }

})
export default homeStore