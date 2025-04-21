import { defineStore } from "pinia";
import { getlocatweather } from '@/api/weather'
let UserStore = defineStore('userStore', {
    state: () => {
        return {
            locatweather: [],

        }
    },
    actions: {
        async getMajorAll() {
            let result: any = await getlocatweather("117.179.30.57");
            // const apidata = getlocatweather("117.179.30.57").then((response) =>response.data)
            console.log(result);
            
            this.locatweather = result;
        },
    }
})

export default UserStore;