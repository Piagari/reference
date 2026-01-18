<template>
  <div class="markdown-content" v-html="renderedContent"></div>
</template>

<script setup>
import { ref, onMounted, watch } from 'vue';
import MarkdownIt from 'markdown-it';
import hljs from 'highlight.js';
import 'highlight.js/styles/github.css';

const props = defineProps({
  content: {
    type: String,
    default: '',
  },
  path: {
    type: String,
    default: '',
  },
});

const renderedContent = ref('');
const md = new MarkdownIt({
  html: true,
  linkify: true,
  typographer: true,
  highlight: function (str, lang) {
    if (lang && hljs.getLanguage(lang)) {
      try {
        return hljs.highlight(str, { language: lang }).value;
      } catch (__) {}
    }

    // 如果没有指定语言或语言不支持，尝试自动检测
    try {
      return hljs.highlightAuto(str).value;
    } catch (__) {}

    return ''; // 使用默认的转义
  }
});

// 处理相对路径的链接
const processMarkdown = (text) => {
  // 替换相对路径的链接
  const processedText = text.replace(/\]\(\.\.\/\.\.\//g, '](/');
  return processedText;
};

const renderMarkdown = async () => {
  if (props.content) {
    const processedContent = processMarkdown(props.content);
    renderedContent.value = md.render(processedContent);
  } else if (props.path) {
    try {
      const response = await fetch(props.path);
      const text = await response.text();
      const processedText = processMarkdown(text);
      renderedContent.value = md.render(processedText);
    } catch (error) {
      console.error('Failed to load markdown file:', error);
      renderedContent.value = '<p>Failed to load content.</p>';
    }
  }
};

onMounted(() => {
  renderMarkdown();
});

watch(() => props.content, renderMarkdown);
watch(() => props.path, renderMarkdown);
</script>

<style lang="scss">
.markdown-content {
  line-height: 1.6;

  h1, h2, h3, h4, h5, h6 {
    margin-top: 24px;
    margin-bottom: 16px;
    font-weight: 600;
    line-height: 1.25;
  }

  h1 {
    font-size: 2em;
    margin-top: 0;
    padding-bottom: 0.3em;
    border-bottom: 1px solid var(--border-color);
  }

  h2 {
    font-size: 1.5em;
    padding-bottom: 0.3em;
    border-bottom: 1px solid var(--border-color);
  }

  h3 {
    font-size: 1.25em;
  }

  p {
    margin-top: 0;
    margin-bottom: 16px;
  }

  a {
    color: var(--primary-color);
    text-decoration: none;

    &:hover {
      text-decoration: underline;
    }
  }

  code {
    font-family: var(--code-font-family);
    padding: 0.2em 0.4em;
    margin: 0;
    font-size: 85%;
    background-color: var(--code-background);
    border-radius: 3px;
  }

  pre {
    margin-top: 0;
    margin-bottom: 16px;
    padding: 16px;
    overflow: auto;
    font-size: 85%;
    line-height: 1.45;
    background-color: var(--code-background);
    border-radius: 3px;

    code {
      padding: 0;
      margin: 0;
      font-size: 100%;
      background-color: transparent;
      border-radius: 0;
    }
  }

  table {
    display: block;
    width: 100%;
    overflow: auto;
    margin-top: 0;
    margin-bottom: 16px;
    border-collapse: collapse;

    th, td {
      padding: 6px 13px;
      border: 1px solid var(--border-color);
    }

    th {
      font-weight: 600;
      background-color: var(--code-background);
    }

    tr {
      background-color: #fff;
      border-top: 1px solid var(--border-color);

      &:nth-child(2n) {
        background-color: var(--code-background);
      }
    }
  }

  img {
    max-width: 100%;
    box-sizing: content-box;
    background-color: #fff;
    border: 1px solid var(--border-color);
    border-radius: 3px;
    margin: 16px 0;
  }

  ul, ol {
    padding-left: 2em;
    margin-top: 0;
    margin-bottom: 16px;
  }

  blockquote {
    margin: 0 0 16px;
    padding: 0 1em;
    color: var(--text-color-2);
    border-left: 0.25em solid var(--border-color);

    > :first-child {
      margin-top: 0;
    }

    > :last-child {
      margin-bottom: 0;
    }
  }
}
</style>
