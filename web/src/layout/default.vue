<template>
  <LoginBg />
  <div class="header">
    <Header />
  </div>
  <div class="container">
    <RouterView />
  </div>
</template>

<script setup>
import LoginBg from "@/components/loginBg.vue";
import { RouterView } from "vue-router";
import Header from "@/components/Header.vue";
</script>

<style scoped>
.header {
  width: 100%;
  position: relative;
  top: 0;
  z-index: 100;
  border-radius: 0 0 20px 20px;
  background-color: rgba(0, 0, 0, 0.5);
}
</style>
