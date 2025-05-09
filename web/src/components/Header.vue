<template>
  <el-row justify="space-between">
    <el-col :span="3">
      <div class="demo">
        <div class="homeBg-img"></div>
        <div class="demotext">旅游信息数据</div>
      </div>
    </el-col>
    <el-col :span="3">
      <div class="demo1" @click="goto('search')">
        <div class="demo1text">搜索</div>
      </div>
    </el-col>
    <el-col :span="3">
      <div class="demo2" @click="goto('lvyu')">
        <div class="demo2text">全国旅游数据</div>
      </div>
    </el-col>
    <el-col :span="3">
      <div class="demo3">
        <div class="demo3text demo3time">
          {{ dayt.timemiao }}
        </div>
      </div>
    </el-col>
    <el-col :span="3">
      <div class="demo4">
        <div class="demo4text">天气</div>
      </div>
    </el-col>
    <el-col :span="3">
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
    </el-col>
  </el-row>
</template>
<script setup lang="ts">
import { ElMessage } from "element-plus";
import { reactive } from "vue";
import { CaretBottom } from "@element-plus/icons-vue";
import { daytime } from "@/utils/time";
import router from "@/router/index";
const dayarr = ["日", "一", "二", "三", "四", "五", "六"];
let dayt = reactive({
  timemiao: "",
  timeMonth: "",
  timexinqi: "",
});
const goto = (gowhere: string) => {
  console.log(1);
  if (gowhere == "lvyu") router.push("/home");
  if (gowhere == "search") router.push("/");
};

const guanli = () => {
  ElMessage({
    message: "账号管理",
    type: "success",
  });
};
const exit_login = () => {
  ElMessage({
    message: "退出登录成功！请重新登录",
    type: "success",
  });
};
const headerTime = () => {
  dayt.timemiao = daytime(Date.now()).timemiao;
  dayt.timeMonth = daytime(Date.now()).timeMonth;
  dayt.timexinqi = daytime(Date.now()).timexinqi;
};
const timeformat = () => {
  var num = ~~dayt.timexinqi;
  return `${dayt.timeMonth}  |  星期${dayarr[num]}`;
};

setInterval(() => {
  headerTime();
}, 1000);
</script>

<style scoped lang="less">
.homeBg-img {
  width: 50%;
  height: 100%;
  background-size: 100px 100px;
  background: url("@/assets/icons/svg/DT.svg") no-repeat 10px;
}
</style>
