<template>
  <div class="demo-block">
    <div class="demo-block-title">{{ title }}</div>
    <div class="demo-block-content">
      <slot></slot>
    </div>
    <div class="demo-block-code" :class="{ 'demo-block-code-expanded': codeVisible }">
      <slot name="code"></slot>
    </div>
    <div class="demo-block-actions">
      <button class="demo-block-action-button" @click="toggleCode">
        {{ codeVisible ? '收起代码' : '查看代码' }}
      </button>
    </div>
  </div>
</template>

<script setup>
import { ref } from 'vue';

defineProps({
  title: {
    type: String,
    default: '',
  },
});

const codeVisible = ref(false);

const toggleCode = () => {
  codeVisible.value = !codeVisible.value;
};
</script>

<style lang="scss" scoped>
.demo-block {
  margin: 16px 0 24px;
  border: 1px solid var(--border-color);
  border-radius: 8px;
  overflow: hidden;
  background-color: #fff;
}

.demo-block-title {
  padding: 16px;
  font-size: 16px;
  font-weight: 600;
  border-bottom: 1px solid var(--border-color);
}

.demo-block-content {
  padding: 24px 16px;
  position: relative;
}

.demo-block-code {
  max-height: 0;
  overflow: hidden;
  transition: max-height 0.3s ease;
  background-color: var(--code-background);
  
  &.demo-block-code-expanded {
    max-height: 500px;
    border-top: 1px solid var(--border-color);
  }
}

.demo-block-actions {
  display: flex;
  justify-content: center;
  padding: 8px 0;
  border-top: 1px solid var(--border-color);
}

.demo-block-action-button {
  background: none;
  border: none;
  color: var(--primary-color);
  font-size: 14px;
  cursor: pointer;
  padding: 4px 8px;
  
  &:hover {
    opacity: 0.8;
  }
}
</style>
