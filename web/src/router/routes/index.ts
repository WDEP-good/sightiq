let routes = [
  {
    path: "/",
    name: "Root",
    redirect: "/home",
    component: () => import("@/layout/index.vue"),
    children: [
      {
        path: "home",
        name: "home",
        component: () => import("@/views/Home/home.vue"),
      },
    ],
  },
  {
    path: "/Login",
    name: "Login",
    component: () => import("@/views/Login.vue"),
  },
  {
    path: "/nologin",
    name: "nologin",
    component: () => import("@/views/no_login.vue"),
  },
  {
    path: "/city",
    name: "city",
    component: () => import("@/views/City/city.vue"),
  },
];

export default [...routes];
