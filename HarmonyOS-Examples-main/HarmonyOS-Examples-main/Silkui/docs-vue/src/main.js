import { createApp } from 'vue';
import App from './App.vue';
import router from './router';
import './styles/index.scss';
import 'highlight.js/styles/github.css';

// 导入演示组件
import DemoBlock from './components/DemoBlock.vue';

const app = createApp(App);

// 注册全局组件
app.component('DemoBlock', DemoBlock);

app.use(router);
app.mount('#app');
