import req from '@/utils/request';
// import type {
//     ipdatatype
// } from './types/weathertype'


enum API {
    Locatweather = "/weather"
}



// 获取用户数据
export const getlocatweather = (ipdata: string) =>req.post(API.Locatweather, {ipdata});