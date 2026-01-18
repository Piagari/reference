<template>
  <header class="header">
    <div class="container header-container">
      <router-link class="header-logo" to="/">
        <img src="/images/logo.svg" alt="SilkUI Logo" />
        <span>SilkUI</span>
      </router-link>
      <nav class="header-nav">
        <router-link class="header-nav-item" to="/guide/introduction">指南</router-link>
        <router-link class="header-nav-item" to="/components/button">组件</router-link>
        <a class="header-nav-item" href="https://github.com/yourusername/silkui" target="_blank">GitHub</a>
      </nav>
      <div class="header-mobile-nav-btn" @click="toggleMobileNav">
        <span></span>
        <span></span>
        <span></span>
      </div>
    </div>
    <div class="mobile-nav" :class="{ 'mobile-nav-active': mobileNavActive }">
      <router-link class="mobile-nav-item" to="/guide/introduction" @click="closeMobileNav">指南</router-link>
      <router-link class="mobile-nav-item" to="/components/button" @click="closeMobileNav">组件</router-link>
      <a class="mobile-nav-item" href="https://github.com/yourusername/silkui" target="_blank">GitHub</a>
    </div>
  </header>
</template>

<script setup>
import { ref } from 'vue';

const mobileNavActive = ref(false);

const toggleMobileNav = () => {
  mobileNavActive.value = !mobileNavActive.value;
};

const closeMobileNav = () => {
  mobileNavActive.value = false;
};
</script>

<style lang="scss" scoped>
.header {
  position: fixed;
  top: 0;
  left: 0;
  right: 0;
  height: var(--header-height);
  background-color: #fff;
  box-shadow: 0 1px 4px rgba(0, 0, 0, 0.1);
  z-index: 100;
}

.header-container {
  display: flex;
  align-items: center;
  justify-content: space-between;
  height: 100%;
}

.header-logo {
  display: flex;
  align-items: center;
  font-size: 20px;
  font-weight: 600;
  color: var(--text-color);

  img {
    height: 32px;
    margin-right: 8px;
  }
}

.header-nav {
  display: flex;
  align-items: center;
}

.header-nav-item {
  margin-left: 24px;
  font-size: 15px;
  color: var(--text-color);
  transition: color 0.3s;

  &:hover, &.router-link-active {
    color: var(--primary-color);
  }
}

.header-mobile-nav-btn {
  display: none;
  flex-direction: column;
  justify-content: space-between;
  width: 24px;
  height: 20px;
  cursor: pointer;

  span {
    display: block;
    width: 100%;
    height: 2px;
    background-color: var(--text-color);
    transition: all 0.3s;
  }
}

.mobile-nav {
  display: none;
  position: fixed;
  top: var(--header-height);
  left: 0;
  right: 0;
  background-color: #fff;
  box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
  padding: 16px 0;
  transform: translateY(-100%);
  opacity: 0;
  transition: all 0.3s;
  z-index: 99;

  &.mobile-nav-active {
    transform: translateY(0);
    opacity: 1;
  }
}

.mobile-nav-item {
  display: block;
  padding: 12px 24px;
  font-size: 16px;
  color: var(--text-color);

  &:hover, &.router-link-active {
    color: var(--primary-color);
    background-color: var(--background-color);
  }
}

@media (max-width: 768px) {
  .header-nav {
    display: none;
  }

  .header-mobile-nav-btn {
    display: flex;
  }

  .mobile-nav {
    display: block;
  }
}
</style>
