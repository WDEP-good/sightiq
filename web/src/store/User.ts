import { defineStore } from "pinia";
import { getUserInfo } from '@/api/user'
let UserStore = defineStore('userStore', {
    state: () => {
        return {
            userInfo:[],

        }
    },
    actions: {
        async getMajorAll() {
            let result:any = await getUserInfo();
            this.userInfo = result[0];
            console.log(this.userInfo);
            // if (result.status == 0) {
            //     this.majors = (result.data as majorInfoData[])
            //     return "OK"
            // } else {
            //     return Promise.reject(new Error(result.msg))
            // }
        },
    }
})

export default UserStore;