import req from '@/utils/request';

enum API{
    UserInfo = "/users"
}



// 获取用户数据
export const getUserInfo = () => req.get(API.UserInfo);