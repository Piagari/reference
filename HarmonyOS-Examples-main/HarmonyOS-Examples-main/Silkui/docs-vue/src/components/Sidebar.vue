<template>
  <aside class="sidebar" :class="{ 'sidebar-active': sidebarActive }">
    <div class="sidebar-content">
      <div class="sidebar-group">
        <div class="sidebar-group-title">开发指南</div>
        <router-link class="sidebar-item" to="/guide/introduction">介绍</router-link>
        <router-link class="sidebar-item" to="/guide/quickstart">快速上手</router-link>
        <router-link class="sidebar-item" to="/guide/theme">主题定制</router-link>
        <router-link class="sidebar-item" to="/guide/contribution">贡献指南</router-link>
      </div>

      <div class="sidebar-group">
        <div class="sidebar-group-title">基础组件</div>
        <router-link class="sidebar-item" to="/components/button">Button 按钮</router-link>
        <router-link class="sidebar-item" to="/components/cell">Cell 单元格</router-link>
        <router-link class="sidebar-item" to="/components/icon">Icon 图标</router-link>
        <router-link class="sidebar-item" to="/components/image">Image 图片</router-link>
        <router-link class="sidebar-item" to="/components/badge">Badge 徽标</router-link>
      </div>

      <div class="sidebar-group">
        <div class="sidebar-group-title">展示组件</div>
        <router-link class="sidebar-item" to="/components/collapse">Collapse 折叠面板</router-link>
        <router-link class="sidebar-item" to="/components/highlight">HighLight 文字高亮</router-link>
        <router-link class="sidebar-item" to="/components/loading">Loading 加载</router-link>
        <router-link class="sidebar-item" to="/components/rate">Rate 评分</router-link>
      </div>

      <div class="sidebar-group">
        <div class="sidebar-group-title">表单组件</div>
        <router-link class="sidebar-item" to="/components/calendar">Calendar 日历</router-link>
      </div>

      <div class="sidebar-group">
        <div class="sidebar-group-title">反馈组件</div>
        <router-link class="sidebar-item" to="/components/toast">Toast 轻提示</router-link>
        <router-link class="sidebar-item" to="/components/dialog">Dialog 对话框</router-link>
        <router-link class="sidebar-item" to="/components/popup">Popup 弹出层</router-link>
      </div>
    </div>
    <div class="sidebar-toggle" @click="toggleSidebar">
      <span></span>
    </div>
  </aside>
</template>

<script setup>
import { ref } from 'vue';

const sidebarActive = ref(false);

const toggleSidebar = () => {
  sidebarActive.value = !sidebarActive.value;
};
</script>

<style lang="scss" scoped>
.sidebar {
  position: fixed;
  top: var(--header-height);
  left: 0;
  bottom: 0;
  width: var(--sidebar-width);
  background-color: #fff;
  border-right: 1px solid var(--border-color);
  overflow-y: auto;
  z-index: 90;
  transition: transform 0.3s;
}

.sidebar-content {
  padding: 24px 0;
}

.sidebar-group {
  margin-bottom: 16px;
}

.sidebar-group-title {
  padding: 8px 24px;
  color: var(--text-color-2);
  font-size: 14px;
  font-weight: 600;
}

.sidebar-item {
  display: block;
  padding: 8px 24px;
  color: var(--text-color);
  font-size: 14px;
  transition: all 0.3s;

  &:hover, &.router-link-active {
    color: var(--primary-color);
    background-color: var(--background-color);
  }
}

.sidebar-toggle {
  display: none;
  position: absolute;
  top: 50%;
  right: -16px;
  width: 32px;
  height: 32px;
  background-color: var(--primary-color);
  border-radius: 50%;
  transform: translateY(-50%);
  cursor: pointer;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.15);

  span {
    position: absolute;
    top: 50%;
    left: 50%;
    width: 12px;
    height: 12px;
    border-right: 2px solid #fff;
    border-bottom: 2px solid #fff;
    transform: translate(-75%, -50%) rotate(-45deg);
    transition: transform 0.3s;
  }
}

@media (max-width: 768px) {
  .sidebar {
    transform: translateX(-100%);

    &.sidebar-active {
      transform: translateX(0);
    }
  }

  .sidebar-toggle {
    display: block;
  }

  .sidebar-active .sidebar-toggle span {
    transform: translate(-25%, -50%) rotate(135deg);
  }
}
</style>
