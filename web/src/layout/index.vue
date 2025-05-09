<template>
  <component :is="layout" />
</template>

<script setup>
import { useRoute } from "vue-router";
const route = useRoute();
const layout = computed(() => {
  return "default";
});
</script>

<style scoped></style>
