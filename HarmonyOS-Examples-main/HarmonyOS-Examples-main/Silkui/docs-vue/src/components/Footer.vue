<template>
  <footer class="footer">
    <div class="container">
      <div class="footer-links">
        <a class="footer-link" href="https://github.com/yourusername/silkui" target="_blank">GitHub</a>
        <a class="footer-link" href="/privacy-policy">隐私政策</a>
        <a class="footer-link" href="/terms-of-use">使用条款</a>
      </div>
      <div class="footer-copyright">© {{ currentYear }} SilkUI Team</div>
    </div>
  </footer>
</template>

<script setup>
import { computed } from 'vue';

const currentYear = computed(() => new Date().getFullYear());
</script>

<style lang="scss" scoped>
.footer {
  padding: 24px 0;
  background-color: #fff;
  border-top: 1px solid var(--border-color);
  text-align: center;
  margin-left: var(--sidebar-width);
  transition: margin-left 0.3s;
}

.footer-links {
  display: flex;
  justify-content: center;
  margin-bottom: 8px;
}

.footer-link {
  margin: 0 8px;
  color: var(--text-color-2);
  font-size: 14px;
  
  &:hover {
    color: var(--primary-color);
  }
}

.footer-copyright {
  color: var(--text-color-2);
  font-size: 14px;
}

@media (max-width: 768px) {
  .footer {
    margin-left: 0;
  }
}
</style>
