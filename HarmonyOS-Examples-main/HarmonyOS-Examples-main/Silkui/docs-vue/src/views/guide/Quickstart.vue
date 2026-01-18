<template>
  <div class="content">
    <h1>快速上手</h1>
    <p>本节将介绍如何在项目中使用 SilkUI。</p>
    
    <h2>安装</h2>
    <pre><code class="language-bash">npm install silkui</code></pre>
    
    <h2>引入组件</h2>
    <pre><code class="language-js">import { SilkButton } from 'silkui';</code></pre>
    
    <h2>使用组件</h2>
    <pre><code class="language-html">&lt;silk-button text="按钮" /&gt;</code></pre>
    
    <h2>按需引入</h2>
    <p>SilkUI 支持按需引入，只引入需要的组件，减小打包体积。</p>
    
    <h2>完整引入</h2>
    <p>如果你想一次性引入所有组件，可以使用完整引入的方式。</p>
    
    <h2>浏览器引入</h2>
    <p>你也可以直接在浏览器中使用 CDN 引入 SilkUI。</p>
  </div>
</template>

<script setup>
// 这里可以添加页面逻辑
</script>

<style lang="scss" scoped>
// 这里可以添加页面样式
</style>
