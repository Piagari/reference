<template>
  <div class="demo-section">
    <!-- 复制提示 -->
    <div class="copy-tip" v-if="copyTipVisible">
      {{ copyTipText }}
    </div>

    <div v-for="(demo, index) in demos" :key="index" class="demo-item">
      <h3>{{ demo.title }}</h3>
      <p v-if="demo.description" v-html="formatDescription(demo.description)"></p>

      <div class="demo-content">
        <div class="demo-image" v-if="demo.image">
          <img :src="getImageUrl(demo.image)" :alt="demo.title" />
        </div>
      </div>

      <div class="demo-actions">
        <button class="demo-action-button" @click="toggleCode(index)">
          {{ codeVisible[index] ? '收起代码' : '查看代码' }}
        </button>
      </div>

      <div class="demo-code" :class="{ 'demo-code-expanded': codeVisible[index] }">
        <div class="demo-code-header" v-if="codeVisible[index]">
          <button class="copy-button" @click="copyCode(demo.code)" title="复制代码">
            <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
              <rect x="9" y="9" width="13" height="13" rx="2" ry="2"></rect>
              <path d="M5 15H4a2 2 0 0 1-2-2V4a2 2 0 0 1 2-2h9a2 2 0 0 1 2 2v1"></path>
            </svg>
          </button>
        </div>
        <pre><code class="language-js">{{ demo.code }}</code></pre>
      </div>
    </div>
  </div>
</template>

<script setup>
import { computed, ref, watch } from 'vue';
import { getComponentExamples } from '../config';

const props = defineProps({
  componentName: {
    type: String,
    required: true
  }
});

// 获取当前组件的演示配置
const demos = computed(() => {
  return getComponentExamples(props.componentName);
});

// 代码可见性状态
const codeVisible = ref({});

// 初始化代码可见性状态
watch(demos, (newDemos) => {
  newDemos.forEach((_, index) => {
    if (codeVisible.value[index] === undefined) {
      codeVisible.value[index] = false;
    }
  });
}, { immediate: true });

// 切换代码可见性
const toggleCode = (index) => {
  codeVisible.value[index] = !codeVisible.value[index];
};

// 格式化描述文本，将 `code` 转换为 <code> 标签
const formatDescription = (description) => {
  return description.replace(/`([^`]+)`/g, '<code>$1</code>');
};

// 获取图片 URL
const getImageUrl = (imagePath) => {
  return `/images/demos/${imagePath}`;
};

// 复制提示状态
const copyTipVisible = ref(false);
const copyTipText = ref('');
const copyTipTimer = ref(null);

// 复制代码到剪贴板
const copyCode = (code) => {
  navigator.clipboard.writeText(code).then(() => {
    // 显示复制成功提示
    copyTipText.value = '复制成功';
    copyTipVisible.value = true;

    // 清除之前的定时器
    if (copyTipTimer.value) {
      clearTimeout(copyTipTimer.value);
    }

    // 设置新的定时器，3秒后隐藏提示
    copyTipTimer.value = setTimeout(() => {
      copyTipVisible.value = false;
    }, 3000);
  }).catch(err => {
    // 显示复制失败提示
    copyTipText.value = '复制失败';
    copyTipVisible.value = true;

    // 清除之前的定时器
    if (copyTipTimer.value) {
      clearTimeout(copyTipTimer.value);
    }

    // 设置新的定时器，3秒后隐藏提示
    copyTipTimer.value = setTimeout(() => {
      copyTipVisible.value = false;
    }, 3000);

    console.error('复制失败:', err);
  });
};
</script>

<style lang="scss" scoped>
.demo-section {
  margin-top: 24px;
  position: relative;
}

.copy-tip {
  position: fixed;
  top: 50%;
  left: 50%;
  transform: translate(-50%, -50%);
  background-color: rgba(0, 0, 0, 0.7);
  color: white;
  padding: 8px 16px;
  border-radius: 4px;
  font-size: 14px;
  z-index: 1000;
  animation: fadeIn 0.3s;
}

@keyframes fadeIn {
  from {
    opacity: 0;
  }
  to {
    opacity: 1;
  }
}

.demo-item {
  margin-bottom: 32px;

  h3 {
    margin-bottom: 8px;
    font-size: 18px;
    font-weight: 600;
  }

  p {
    margin-bottom: 16px;
    font-size: 14px;
    line-height: 1.6;
    color: var(--text-color-2);

    :deep(code) {
      background-color: var(--code-background);
      padding: 2px 4px;
      border-radius: 4px;
      font-family: var(--code-font-family);
      font-size: 14px;
      color: var(--code-color);
    }
  }
}

.demo-content {
  display: flex;
  flex-direction: column;
  gap: 16px;
}

.demo-image {
  width: 100%;
  border: 1px solid var(--border-color);
  border-radius: 8px;
  overflow: hidden;
  background-color: #fff;

  img {
    width: 100%;
    height: auto;
    display: block;
  }
}

.demo-actions {
  display: flex;
  justify-content: center;
  margin: 8px 0;
}

.demo-action-button {
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

.demo-code {
  max-height: 0;
  overflow: hidden;
  transition: max-height 0.3s ease;
  background-color: var(--code-background);
  border-radius: 8px;
  position: relative;

  &.demo-code-expanded {
    max-height: 500px;
    margin-top: 8px;
  }

  pre {
    margin: 0;
    padding: 16px;
    overflow-x: auto;
  }

  code {
    font-family: var(--code-font-family);
    font-size: 14px;
    line-height: 1.5;
  }

  .demo-code-header {
    position: absolute;
    top: 0;
    right: 0;
    padding: 8px;
    z-index: 10;
  }

  .copy-button {
    background: rgba(255, 255, 255, 0.8);
    border: 1px solid var(--border-color);
    border-radius: 4px;
    padding: 4px;
    cursor: pointer;
    display: flex;
    align-items: center;
    justify-content: center;
    color: var(--text-color-2);
    transition: all 0.2s;

    &:hover {
      background: var(--primary-color);
      color: white;
      border-color: var(--primary-color);
    }
  }
}
</style>
