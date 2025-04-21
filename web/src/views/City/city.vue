<template>
    <CityBg :city="data.name"/>
    <div class="city">
    </div>
</template>
<script setup lang="ts">
import {useRoute} from 'vue-router'
import CityBg from './compents/cityBg.vue'
const route = useRoute();
const data = route.query
console.log(data);


</script>

<style scoped>
.cityBg{
    z-index:0;
}
.city{
    z-index:1;
    color: #fff;
    Background:red;
}

</style>