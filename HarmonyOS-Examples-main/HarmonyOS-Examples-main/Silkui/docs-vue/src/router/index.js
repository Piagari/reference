import { createRouter, createWebHistory } from 'vue-router';

// 指南页面
import Introduction from '../views/guide/Introduction.vue';
import Quickstart from '../views/guide/Quickstart.vue';
import Theme from '../views/guide/Theme.vue';
import Contribution from '../views/guide/Contribution.vue';

// 通用组件文档页面
import ComponentDoc from '../views/ComponentDoc.vue';

const routes = [
  {
    path: '/',
    redirect: '/guide/introduction'
  },
  // 指南路由
  {
    path: '/guide/introduction',
    name: 'introduction',
    component: Introduction,
    meta: { title: '介绍' }
  },
  {
    path: '/guide/quickstart',
    name: 'quickstart',
    component: Quickstart,
    meta: { title: '快速上手' }
  },
  {
    path: '/guide/theme',
    name: 'theme',
    component: Theme,
    meta: { title: '主题定制' }
  },
  {
    path: '/guide/contribution',
    name: 'contribution',
    component: Contribution,
    meta: { title: '贡献指南' }
  },
  // 组件路由
  {
    path: '/components/button',
    name: 'button',
    component: ComponentDoc,
    meta: { title: 'Button 按钮', componentName: 'button' }
  },
  {
    path: '/components/badge',
    name: 'badge',
    component: ComponentDoc,
    meta: { title: 'Badge 徽标', componentName: 'badge' }
  },
  {
    path: '/components/cell',
    name: 'cell',
    component: ComponentDoc,
    meta: { title: 'Cell 单元格', componentName: 'cell' }
  },
  {
    path: '/components/dialog',
    name: 'dialog',
    component: ComponentDoc,
    meta: { title: 'Dialog 对话框', componentName: 'dialog' }
  },
  {
    path: '/components/collapse',
    name: 'collapse',
    component: ComponentDoc,
    meta: { title: 'Collapse 折叠面板', componentName: 'collapse' }
  },
  {
    path: '/components/highlight',
    name: 'highlight',
    component: ComponentDoc,
    meta: { title: 'HighLight 文字高亮', componentName: 'highlight' }
  },
  {
    path: '/components/icon',
    name: 'icon',
    component: ComponentDoc,
    meta: { title: 'Icon 图标', componentName: 'icon' }
  },
  {
      path: '/components/image',
      name: 'image',
      component: ComponentDoc,
      meta: { title: 'Image 图片', componentName: 'image' }
  },
    {
    path: '/components/loading',
    name: 'loading',
    component: ComponentDoc,
    meta: { title: 'Loading 加载', componentName: 'loading' }
  },
  {
      path: '/components/popup',
      name: 'popup',
      component: ComponentDoc,
      meta: { title: 'Popup 弹出层', componentName: 'popup' }
  },
    {
    path: '/components/toast',
    name: 'toast',
    component: ComponentDoc,
    meta: { title: 'Toast 轻提示', componentName: 'toast' }
  },
  {
    path: '/components/rate',
    name: 'rate',
    component: ComponentDoc,
    meta: { title: 'Rate 评分', componentName: 'rate' }
  },
    {
        path: '/components/calendar',
        name: 'calendar',
        component: ComponentDoc,
        meta: { title: 'Calendar 日历', componentName: 'calendar' }
    },
    {
        path: '/components/picker',
        name: 'picker',
        component: ComponentDoc,
        meta: { title: 'Picker 选择器', componentName: 'picker' }
    }
];

const router = createRouter({
  history: createWebHistory(),
  routes,
  scrollBehavior() {
    return { top: 0 };
  }
});

router.beforeEach((to, from, next) => {
  document.title = to.meta.title ? `${to.meta.title} - SilkUI` : 'SilkUI - 轻量、可靠的移动端组件库';
  next();
});

export default router;
