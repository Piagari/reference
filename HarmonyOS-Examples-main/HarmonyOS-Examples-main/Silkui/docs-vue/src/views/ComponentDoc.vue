<template>
  <div class="component-doc">
    <div class="content">
      <markdown-renderer :path="markdownPath" />

      <div class="component-demo">
        <h2>在线演示</h2>
        <demo-section :component-name="componentName" />
      </div>
    </div>
  </div>
</template>

<script setup>
import { computed } from 'vue';
import { useRoute } from 'vue-router';
import MarkdownRenderer from '../components/MarkdownRenderer.vue';
import DemoSection from '../components/DemoSection.vue';

const route = useRoute();

// 获取组件名称（从路由元数据中获取）
const componentName = computed(() => {
  return route.meta.componentName || '';
});

// 组件名称首字母大写
const capitalizedComponentName = computed(() => {
  return componentName.value.charAt(0).toUpperCase() + componentName.value.slice(1);
});

// Markdown 文件路径
const markdownPath = computed(() => {
  return `/markdown/${componentName.value}.md`;
});
</script>

<style lang="scss" scoped>
.component-doc {
  width: 100%;
}

.component-demo {
  margin-top: 40px;
  padding-top: 20px;
  border-top: 1px solid var(--border-color);
}
</style>
