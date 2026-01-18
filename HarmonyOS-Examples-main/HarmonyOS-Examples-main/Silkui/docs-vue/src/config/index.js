/**
 * 组件配置加载器
 */

// 导入所有组件配置
import buttonConfig from './components/button.json';
import badgeConfig from './components/badge.json';
import calendarConfig from './components/calendar.json';
import cellConfig from './components/cell.json';
import dialogConfig from './components/dialog.json';
import collapseConfig from './components/collapse.json';
import highlightConfig from './components/highlight.json';
import iconConfig from './components/icon.json';
import imageConfig from './components/image.json';
import loadingConfig from './components/loading.json';
import popupConfig from './components/popup.json';
import rateConfig from './components/rate.json';
import toastConfig from './components/toast.json';

// 组件配置映射
const componentsConfig = {
  button: buttonConfig,
  badge: badgeConfig,
    calendar: calendarConfig,
  cell: cellConfig,
  dialog: dialogConfig,
  collapse: collapseConfig,
  highlight: highlightConfig,
  icon: iconConfig,
  image: imageConfig,
  loading: loadingConfig,
  popup: popupConfig,
  rate: rateConfig,
  toast: toastConfig
};

/**
 * 获取组件配置
 * @param {string} componentName - 组件名称
 * @returns {Object} 组件配置
 */
export function getComponentConfig(componentName) {
  return componentsConfig[componentName] || null;
}

/**
 * 获取组件示例
 * @param {string} componentName - 组件名称
 * @returns {Array} 组件示例列表
 */
export function getComponentExamples(componentName) {
  const config = getComponentConfig(componentName);
  return config ? config.examples || [] : [];
}

export default componentsConfig;
