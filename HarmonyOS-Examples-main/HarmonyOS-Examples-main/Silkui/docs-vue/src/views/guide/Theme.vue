<template>
  <div class="content">
    <h1>主题定制</h1>
    <p>SilkUI 提供了一套默认主题，支持灵活的样式定制，满足业务和品牌上多样化的视觉需求。</p>

    <h2>样式变量</h2>
    <p>SilkUI 使用了 Cangjie 的变量系统来组织样式，所有组件的样式变量都在 <code>constants</code> 目录下定义。通过修改这些变量，可以实现对组件样式的定制。</p>

    <h3>基础变量</h3>
    <p>SilkUI 提供了一系列基础变量，包括颜色、字体、尺寸等，这些变量在 <code>constants.cj</code> 文件中定义。</p>

    <h4>颜色变量</h4>
    <div class="code-block">
      <pre><code class="language-js">// 修改主题色
import silkui.constants.SilkColorConstants
import silkui.constants.SilkColorKey
import silkui.constants.updateColorConstant

// 修改主题色
updateColorConstant(SilkColorKey.PRIMARY_COLOR, Color(25, 137, 250, alpha: 1.0))

// 修改文字颜色
updateColorConstant(SilkColorKey.TEXT_COLOR, Color(50, 50, 50, alpha: 1.0))</code></pre>
    </div>

    <p>以下是所有可用的颜色变量：</p>
    <table>
      <thead>
        <tr>
          <th>变量名</th>
          <th>默认值</th>
          <th>说明</th>
        </tr>
      </thead>
      <tbody>
        <tr>
          <td><code>--silk-black</code></td>
          <td><code>#000000</code></td>
          <td>黑色</td>
        </tr>
        <tr>
          <td><code>--silk-white</code></td>
          <td><code>#ffffff</code></td>
          <td>白色</td>
        </tr>
        <tr>
          <td><code>--silk-gray-1</code></td>
          <td><code>#f7f8fa</code></td>
          <td>浅灰色</td>
        </tr>
        <tr>
          <td><code>--silk-primary-color</code></td>
          <td><code>#1989fa</code></td>
          <td>主题色</td>
        </tr>
        <tr>
          <td><code>--silk-success-color</code></td>
          <td><code>#07c160</code></td>
          <td>成功色</td>
        </tr>
        <tr>
          <td><code>--silk-danger-color</code></td>
          <td><code>#ee0a24</code></td>
          <td>危险色</td>
        </tr>
        <tr>
          <td><code>--silk-warning-color</code></td>
          <td><code>#ff976a</code></td>
          <td>警告色</td>
        </tr>
      </tbody>
    </table>

    <h4>尺寸变量</h4>
    <div class="code-block">
      <pre><code class="language-js">// 修改内边距
import silkui.constants.SilkSizeConstants
import silkui.constants.SilkSizeKey
import silkui.constants.updateSizeConstant

// 修改内边距
updateSizeConstant(SilkSizeKey.PADDING_MD, 20.vp)

// 修改字体大小
updateSizeConstant(SilkSizeKey.FONT_SIZE_MD, 15.vp)</code></pre>
    </div>

    <h2>组件变量</h2>
    <p>除了基础变量，每个组件都有自己的样式变量。您可以在各个组件的文档中查看详细的变量列表。</p>

    <h3>按钮组件</h3>
    <div class="code-block">
      <pre><code class="language-js">// 修改按钮颜色
import silkui.constants.SilkButtonColorConstants
import silkui.constants.SilkButtonColorKey
import silkui.constants.updateButtonColorConstant

// 修改主要按钮背景色
updateButtonColorConstant(SilkButtonColorKey.BUTTON_PRIMARY_BACKGROUND, Color(114, 50, 221, alpha: 1.0))</code></pre>
    </div>

    <h2>重置主题</h2>
    <p>SilkUI 提供了重置主题的方法，可以将所有样式变量恢复为默认值。</p>
    <div class="code-block">
      <pre><code class="language-js">// 重置所有基础常量
import silkui.constants.resetAllConstants

// 重置所有常量（包括组件常量）
import silkui.constants.resetAll

// 重置基础常量
resetAllConstants()

// 重置所有常量
resetAll()</code></pre>
    </div>

    <h2>定制主题的最佳实践</h2>
    <ol>
      <li><strong>集中管理主题变量</strong>：建议在应用的入口文件或专门的主题文件中统一管理主题变量。</li>
      <li><strong>按需修改</strong>：只修改需要自定义的变量，其他变量保持默认值。</li>
      <li><strong>使用枚举值</strong>：使用 SilkUI 提供的枚举值来修改变量，避免直接使用字符串键。</li>
      <li><strong>响应式主题</strong>：可以根据用户设置或系统主题动态切换主题。</li>
    </ol>

    <div class="code-block">
      <pre><code class="language-js">// 示例：根据系统主题切换明暗主题
if (systemTheme === "dark") {
    // 设置暗色主题
    updateColorConstant(SilkColorKey.BACKGROUND, Color(28, 28, 30, alpha: 1.0))
    updateColorConstant(SilkColorKey.TEXT_COLOR, Color(255, 255, 255, alpha: 1.0))
} else {
    // 设置亮色主题
    updateColorConstant(SilkColorKey.BACKGROUND, Color(247, 248, 250, alpha: 1.0))
    updateColorConstant(SilkColorKey.TEXT_COLOR, Color(50, 50, 50, alpha: 1.0))
}</code></pre>
    </div>
  </div>
</template>

<script setup>
// 这里可以添加页面逻辑
</script>

<style lang="scss" scoped>
.code-block {
  background-color: var(--code-background);
  border-radius: 4px;
  overflow: hidden;
  margin-bottom: 16px;
}
</style>
