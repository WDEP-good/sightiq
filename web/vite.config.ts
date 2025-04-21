import  { UserConfig, ConfigEnv,loadEnv } from 'vite';
import { createSvgIconsPlugin } from 'vite-plugin-svg-icons';
import { resolve } from 'path';
import vue from '@vitejs/plugin-vue'
import path from 'path'


// 配置svg路径
const pathResolve = (pathStr: any) => {
  return path.resolve(__dirname, pathStr)
}




export default ({ command, mode }: ConfigEnv): UserConfig => {
  let env = loadEnv(mode, process.cwd())
  console.log(env.VITE_APP_SERVICE_URL,"121231")
  return {
    plugins: [
      vue(),
      createSvgIconsPlugin({
        iconDirs: [pathResolve('@/../public/svg')],
        symbolId: 'icon-[dir]-[name]',
      }),
    ],
    resolve: {
      alias: [
        {
          find: /\/@\//,
          replacement: pathResolve('src') + '/',
        },
        {
          find: /@\//,
          replacement: pathResolve('src') + '/',
        },

      ]
    },
    server: {
      // 开启代理
      proxy: {
        // 环境：'/dev-api'
        [env.VITE_APP_BASE_API]: {
          // 代理目标'http://localhost:3000'
          target: env.VITE_APP_SERVICE_URL,
          changeOrigin: true,//允许跨域
          // 重写url
          rewrite: (path) => path.replace(/^\/api/, ''),
        },
      },
    },
  }
}