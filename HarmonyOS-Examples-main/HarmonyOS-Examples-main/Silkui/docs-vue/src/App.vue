<template>
  <div class="app">
    <Header />
    <div class="app-content">
      <Sidebar />
      <div class="app-main">
        <router-view />
      </div>
    </div>
    <Footer />
  </div>
</template>

<script setup>
import Header from './components/Header.vue';
import Sidebar from './components/Sidebar.vue';
import Footer from './components/Footer.vue';
</script>

<style lang="scss">
.app {
  display: flex;
  flex-direction: column;
  min-height: 100vh;
}

.app-content {
  display: flex;
  flex: 1;
}

.app-main {
  flex: 1;
  padding: 24px;
  margin-left: var(--sidebar-width);
  margin-top: var(--header-height);
  background-color: var(--background-color);
  transition: margin-left 0.3s;
}

@media (max-width: 768px) {
  .app-main {
    margin-left: 0;
  }
}
</style>
