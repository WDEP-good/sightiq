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
      proxy: {
        [env.VITE_APP_BASE_API]: {
          target: env.VITE_APP_SERVICE_URL,
          changeOrigin: true,
          rewrite: (path) => path.replace(/^\/api/, ''),
        },
      },
    },
  }
}