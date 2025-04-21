<template>
    <div class="header">
        <div class="demo">
            <div class="homeBg-img"></div>
            <div class="demotext">旅游信息数据</div>
        </div>
        <div class="demo1" @click="goto('search')">
            <div class="demo1text">搜索</div>
        </div>
        <div class="demo2" @click="goto('lvyu')">
            <div class="demo2text">全国旅游数据</div>
        </div>
        <div class="demo3">
            <div class="demo3text demo3time">
                {{ dayt.timemiao }}</div>
            <div class="demo3text demo3moiao">
                {{ timeformat() }}</div>
        </div>
        <div class="demo4">
            <dv-border-box-8>
                <div class="headerTime">天气</div>
            </dv-border-box-8>
        </div>
        <div class="demo5">
            <div class="Usertext UserItem">当前用户</div>
            <div class="Username UserItem">用户名</div>
            <el-dropdown trigger="click" class="UserItem">
                <span class="el-dropdown-link">
                    <el-icon>
                        <CaretBottom />
                    </el-icon>
                    <!-- <el-icon class="el-icon--right"><arrow-down /></el-icon> -->
                </span>
                <template #dropdown>
                    <el-dropdown-menu>
                        <el-dropdown-item @click="guanli">账号管理</el-dropdown-item>
                        <el-dropdown-item @click="exit_login">退出登录</el-dropdown-item>
                    </el-dropdown-menu>
                </template>
            </el-dropdown>
        </div>
    </div>
</template>
<script setup lang="ts">
// import Dt from "@/components/Svg/Dt.vue";
import { ElMessage } from 'element-plus'
import { reactive } from 'vue'
import { CaretBottom } from '@element-plus/icons-vue'
import { daytime } from '@/utils/time'
import router from '@/router/index'
const dayarr = ['日', '一', '二', '三', '四', '五', '六']
let dayt = reactive({
    timemiao: '',
    timeMonth: '',
    timexinqi: ''
})
const goto = (gowhere: string) => {
    console.log(1);
    if (gowhere == 'lvyu') router.push('/home')
    if (gowhere == 'search') router.push('/')
}

const guanli = () => {
    ElMessage({
        message: '账号管理',
        type: 'success',
    })
}
const exit_login = () => {
    ElMessage({
        message: '退出登录成功！请重新登录',
        type: 'success',
    })
}
const headerTime = () => {
    dayt.timemiao = daytime(Date.now()).timemiao
    dayt.timeMonth = daytime(Date.now()).timeMonth
    dayt.timexinqi = daytime(Date.now()).timexinqi

}
const timeformat = () => {
    var num = ~~(dayt.timexinqi)
    return `${dayt.timeMonth}  |  星期${dayarr[num]}`
}

setInterval(() => {
    headerTime()
}, 1000);

</script>

<style scoped lang="less">
.header {
    width: 100%;
    display: flex;
    justify-content: space-between;
}

.demo {
    min-width: 20vh;
    display: flex;
    justify-content: center;
    align-items: center;

    .homeBg-img {
        width: 50%;
        height: 100%;
        background-size: 100px 100px;
        background: url('@/assets/icons/svg/DT.svg') no-repeat 10px;
    }

    .demotext {
        width: 100%;
        font-size: 30px;
        color: #fff;
    }

    .Usertext {
        width: 100px;
        height: 100px;
        background-color: #fff;
        border-radius: 50%;
        text-align: center;
        line-height: 100px;
    }
}

.demo1 {
    min-width: 20vh;
    display: flex;
    justify-content: center;
    align-items: center;
    box-sizing: border-box;
    margin: 10px;

    .demo1text {
        width: 100px;
        height: 100px;
        text-align: center;
        line-height: 100px;
        color: #fff;
    }
}

.demo2 {
    min-width: 20vh;
    display: flex;
    justify-content: center;
    align-items: center;
    box-sizing: border-box;
    margin: 10px;

    .demo2text {
        width: 100px;
        height: 100px;
        text-align: center;
        line-height: 100px;
        color: #fff;
    }
}

.demo3 {
    min-width: 20vh;
    display: flex;
    box-sizing: border-box;
    flex-direction: column;
    justify-content: center;


    .demo3text {
        text-align: center;
        color: #fff;
    }

    .demo3time {
        font-size: 50px;
        font-weight: 900;
    }

    .demo3moiao {
        font-size: 1.3vh;
    }


}

.demo4 {
    min-width: 20vh;
    display: flex;
    justify-content: center;
    align-items: center;
    box-sizing: border-box;
    margin: 10px;

    .demo4text {
        width: 100px;
        height: 100px;
        text-align: center;
        line-height: 100px;
        color: #fff;
    }


}


.demo5 {
    min-width: 20vh;
    display: flex;
    justify-content: center;
    align-items: center;
    box-sizing: border-box;
    margin: 10px;

    .Usertext {
        width: 100px;
        height: 100px;
        background-color: #fff;
        border-radius: 50%;
        text-align: center;
        line-height: 100px;
    }

    .Username {
        color: #fff;
    }

    .UserItem {
        margin-left: 10px;
    }
}
</style>