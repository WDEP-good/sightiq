import req from "@/utils/request"

enum API {
    Tipdata = '/homebg'
}
export const getTipdata = () => req.get(API.Tipdata)