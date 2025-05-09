<template>
    <div class="inxdexsearch">
        <div class="box">
            <div class="header_text header-item">旅游景区搜索</div>
            <div class="header-item" :style="headerstyle">
                <a-input-search v-model:value="value" placeholder="请输入搜索信息" @search="onSearch(searchId)">
                    <template #prefix>
                        <a-dropdown :trigger="['click']">
                            <img :src='linkinfo[searchId].icon' alt="" class="imgIcon" />
                            <template #overlay>
                                <a-menu>
                                    <a-menu-item v-for="item  in linkinfo" :key="item.id" style="width: 100px;"
                                        @click="handleClick(item.id)">
                                        <a-row>
                                            <a-col :span="10"><img :src="item.icon" alt="" class="imgIcon"
                                                    style="width: 20px;" /></a-col>
                                            <a-col :span="10" class="icontext">{{ item.name }}</a-col>
                                        </a-row>
                                    </a-menu-item>
                                </a-menu>
                            </template>
                        </a-dropdown>
                    </template>
                </a-input-search>
            </div>
        </div>
        <YoYou />
    </div>
</template>
<script setup lang="ts">
import { reactive, ref, onMounted, onUnmounted } from 'vue';

const value = ref<string>('');
const searchId = ref(0)
const onSearch = (searchId: number) => {
    console.log(value.value)
    window.open(linkinfo[searchId].linurl + value.value)
};
// import {use}

const windowdata = reactive({
    width: window.innerWidth,
    height: window.innerHeight,
})
const headerstyle = reactive({
    width: windowdata.width * 0.5 + "px",
    height: windowdata.height / 10 * 0.5 + "px",
})

function handleResize() {
    windowdata.width = window.innerWidth;
    windowdata.height = window.innerHeight;
    console.log(windowdata);

}
onMounted(() => {
    window.addEventListener('resize', handleResize);
});

onUnmounted(() => {
    window.removeEventListener('resize', handleResize);
});

const linkinfo = reactive([
    {
        id: 0,
        name: "百度",
        linurl: "https://www.baidu.com/s?tn=44004473_8_oem_dg&ie=utf-8&wd=",
        icon: "src/assets/icons/svg/百度.svg",
    },
    {
        id: 1,
        name: "谷歌",
        linurl: "https://www.google.com/search?q=",
        icon: "src/assets/icons/svg/谷歌.svg",
    },
    {
        id: 2,
        name: "必应",
        linurl: "https://cn.bing.com/search?q=",
        icon: "src/assets/icons/svg/必应.svg",
    },
    {
        id: 3,
        name: "duck",
        linurl: "https://duckduckgo.com/?q=",
        icon: "src/assets/icons/svg/DuckDuckGo.svg",
    },
    {
        id: 4,
        name: "搜狗",
        linurl: "https://www.sogou.com/sogou?query=",
        icon: "src/assets/icons/svg/搜狗搜索.svg",
    },
])

const handleClick = (id: number) => {
    searchId.value = id
}
</script>

<style scoped lang="less">
.inxdexsearch {
    top: 0;
    left: 0;
    right: 0;
    bottom: 0;
    position: relative;



    .box {
        display: flex;
        flex-direction: column;
        align-items: center;

        .header_text {
            color: #fff;
            font-size: 2em;
        }

        .header-item {
            margin: 30px;

            .item-input {
                box-sizing: border-box;
                border-style: none;
                border-radius: 20px;
            }


            .imgIcon {
                width: 20px;
                margin-right: 11px;
            }

            /deep/.icontext {
                font-size: 15px;
            }

        }
    }
}</style>