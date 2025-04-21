import  axios from 'axios';

let req = axios.create({
    // 请求地址
    baseURL: import.meta.env.VITE_APP_BASE_API,
    // 请求时长
    timeout: 5000,
    responseEncoding: 'utf8', //表示用于解码响应的编码
    responseType: 'json',
})


export default req
