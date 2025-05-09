<template>
  <component :is="layout" />
</template>

<script setup>
import { useRoute } from "vue-router";
import { computed } from "vue";
import DefaultLayout from "./default.vue";

const route = useRoute();
const layout = computed(() => {
  return DefaultLayout;
});
</script>

<style scoped></style>
