# SilkUI 文档网站

这是 SilkUI 组件库的文档网站，基于 Vue 3 + Vite 构建。

## 项目结构

```
docs-vue/
├── public/            # 静态资源
│   ├── images/        # 图片资源
│   └── favicon.ico    # 网站图标
├── src/
│   ├── components/    # 公共组件
│   ├── router/        # 路由配置
│   ├── styles/        # 全局样式
│   ├── views/         # 页面组件
│   │   ├── components/  # 组件文档页面
│   │   └── guide/       # 指南文档页面
│   ├── App.vue        # 根组件
│   └── main.js        # 入口文件
├── index.html         # HTML 模板
├── package.json       # 项目配置
└── vite.config.js     # Vite 配置
```

## 开发

### 安装依赖

```bash
npm install
```

### 启动开发服务器

```bash
npm run dev
```

### 构建生产版本

```bash
npm run build
```

### 预览生产版本

```bash
npm run preview
```

## 添加新组件文档

本文档网站直接使用组件库中的 README.md 文件作为组件文档。要添加新组件文档，请按照以下步骤操作：

1. 确保组件在 `libs/silkui/src/main/cangjie/src/components/` 目录下有完整的 README.md 文件
2. 在 `src/router/index.js` 中添加新的路由配置，使用 `ComponentDoc` 组件作为页面组件
3. 在 `src/components/Sidebar.vue` 中添加新的侧边栏菜单项
4. 在 `scripts/copy-markdown.js` 中添加新组件的名称
5. 如果需要，在 `src/demos/` 目录下创建新组件的演示组件

## 文档编写规范

### 组件文档结构

每个组件文档应包含以下部分：

1. 组件介绍
2. 引入方式
3. 代码演示
4. API 说明
   - Props
   - Events
   - Slots
   - Methods
5. 主题定制

### 代码演示

使用 `DemoBlock` 组件来展示组件示例：

```vue
<demo-block title="基础用法">
  <div class="demo-row">
    <!-- 组件示例 -->
    <silk-button text="按钮" />
  </div>

  <template #code>
    <pre><code class="language-html">&lt;silk-button text="按钮" /&gt;</code></pre>
  </template>
</demo-block>
```

## 部署

构建完成后，将 `dist` 目录下的文件部署到服务器即可。
