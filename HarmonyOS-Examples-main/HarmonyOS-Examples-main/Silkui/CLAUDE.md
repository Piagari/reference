# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

SilkUI is a UI component library for HarmonyOS development using the CangjieScript (仓颉) programming language. The
project consists of:

- **silkui**: Core component library written in CangjieScript (.cj files)
- **docs-vue**: Vue 3-based documentation website
- **entry**: HarmonyOS application entry point that demonstrates component usage

## Common Development Commands

### Documentation Website (docs-vue/)

```bash
cd docs-vue
npm install                    # Install dependencies
npm run dev                   # Start development server
npm run build                 # Build for production
npm run preview               # Preview production build
```

### HarmonyOS Application

The project uses the HarmonyOS DevEco Studio build system with hvigor. Build commands should be run through DevEco
Studio or using hvigor CLI tools.

### Component Library Development

Components are developed in CangjieScript and located in `libs/silkui/src/main/cangjie/src/components/`. Each component
typically includes:

- Main component file (.cj)
- Model/types file (model.cj)
- Package exports (pkg.cj)
- Documentation (README.md)

## Project Architecture

### Core Structure

- `libs/silkui/` - Main component library
    - `src/main/cangjie/src/components/` - Individual UI components
    - `src/main/cangjie/src/constants/` - Constants and configuration
    - `src/main/cangjie/src/utils/` - Utility functions
    - `src/main/resources/` - Asset files (images, fonts, themes)
- `entry/` - HarmonyOS application entry module
- `docs-vue/` - Vue.js documentation website
- `docs/` - CangjieScript language development documentation

### Component Structure

Each component follows this pattern:

```
component_name/
├── component_name.cj          # Main component implementation
├── model.cj                   # Types and interfaces  
├── pkg.cj                     # Package exports
└── README.md                  # Component documentation
```

### Build Configuration

- `build-profile.json5` - Main HarmonyOS build configuration
- `oh-package.json5` - HarmonyOS package configuration
- `cjpm.toml` - CangjieScript package manager configuration
- `hvigorfile.ts` - Build script configuration

### Resource Management

- `libs/silkui/src/main/resources/base/` - Base theme resources
- `libs/silkui/src/main/resources/dark/` - Dark theme resources
- `libs/silkui/src/main/resources/rawfile/font/` - Custom fonts
- Icons and media assets are in `resources/base/media/`

### Documentation Integration

The Vue documentation site automatically pulls component documentation from the library's README.md files. When adding
new components:

1. Create complete README.md in the component directory
2. Add route configuration in `docs-vue/src/router/index.js`
3. Update sidebar navigation in `docs-vue/src/components/Sidebar.vue`
4. Add component name to `docs-vue/scripts/copy-markdown.js`

### Key Technologies

- **CangjieScript**: Primary development language for components
- **HarmonyOS**: Target platform with ArkUI framework
- **Vue 3 + Vite**: Documentation website
- **CJPM**: CangjieScript package manager
- **Hvigor**: HarmonyOS build tool

### Component Development Guidelines

- Follow the existing component structure pattern
- Include comprehensive README.md documentation
- Use TypeScript-like interfaces in model.cj files
- Export public APIs through pkg.cj files
- Support both light and dark themes via resource configuration
- Include proper error handling and validation

### Testing

The project includes testing infrastructure through:

- `@ohos/hypium`: HarmonyOS testing framework
- `@ohos/hamock`: Mocking framework
- Test files should be placed alongside component files or in dedicated test directories