/**
 * 复制组件 README.md 文件到文档网站的 public/markdown 目录
 */
const fs = require('fs');
const path = require('path');
const { fileURLToPath } = require('url');

// 目标目录（文档网站的 public/markdown 目录）
const targetDir = path.resolve(__dirname, '../public/markdown');

// 确保目标目录存在
if (!fs.existsSync(targetDir)) {
  fs.mkdirSync(targetDir, { recursive: true });
}

// 创建示例 Markdown 文件
const createExampleMarkdown = (filename, content) => {
  const filePath = path.join(targetDir, filename);
  fs.writeFileSync(filePath, content);
  console.log(`Created example Markdown file: ${filePath}`);
};

// 创建示例组件文档
const components = [
  'badge',
  'cell',
  'dialog',
  'collapse',
  'highlight',
  'icon',
  'image',
  'loading',
  'popup',
  'rate',
  'toast'
];

// 确保 button.md 和 theme.md 已经存在
if (!fs.existsSync(path.join(targetDir, 'button.md'))) {
  console.log('Creating example button.md file...');
  createExampleMarkdown('button.md', '# Button 按钮\n\n按钮用于触发一个操作，如提交表单。');
}

if (!fs.existsSync(path.join(targetDir, 'theme.md'))) {
  console.log('Creating example theme.md file...');
  createExampleMarkdown('theme.md', '# 主题定制\n\nSilkUI 提供了一套默认主题，支持灵活的样式定制。');
}

// 为其他组件创建示例文档
components.forEach(component => {
  const filePath = path.join(targetDir, `${component}.md`);
  if (!fs.existsSync(filePath)) {
    console.log(`Creating example ${component}.md file...`);
    createExampleMarkdown(`${component}.md`, `# ${component.charAt(0).toUpperCase() + component.slice(1)} 组件\n\n这是 ${component} 组件的文档。`);
  }
});

console.log('Markdown directory created successfully!');

console.log('Markdown files copied successfully!');
