import dayjs  from 'dayjs'

export function daytime(timenum:number){
    // console.log(timenum);
    return {
        timeMonth:dayjs(timenum).format('YYYY/MM/DD'),
        timexinqi:dayjs(timenum).format('d'),
        timemiao:dayjs(timenum).format('HH:mm:ss'),
    }
}