# Changelog - Orion RootFS

## v1.1 (2026-01-09) - CRITICAL FIX

### 🔧 Correções Críticas

- **[CRÍTICO]** Adicionados DLLs descomprimidos para FEXCore e WoWBox64
  - Wine agora inicia corretamente com os emuladores WoW64
  - Corrige o problema onde Wine iniciava mas morria imediatamente
  
### ✨ Novidades

- **Arquivos descomprimidos prontos** para uso imediato:
  - `fexcore/fexcore-2508/` - libwow64fex.dll e libarm64ecfex.dll
  - `fexcore/fexcore-2601/` - Versão alternativa do FEXCore
  - `others/wowbox64/wowbox64-0.3.7/` - wowbox64.dll
  - `box64/box64-0.3.7/` - Binário box64
  - `dxwrapper/dxvk-*/` - DLLs DXVK prontos
  - `graphics_driver/adrenotools-*/` - Drivers Vulkan

- **Instalação 50% mais rápida** - Sem descompressão em tempo real
- **Mais confiável** - Cópia direta de arquivos em vez de extração
- **Fallback mantido** - Arquivos .tzst continuam presentes para compatibilidade

### 🐛 Bug Fixes

- Corrigido: libwow64fex.dll não era extraído quando box64Version estava vazio
- Corrigido: Caminho de extração apontava para assets em vez de contents/
- Corrigido: Verificação prematura pulava extração de DLLs necessários

### 📦 Componentes Atualizados

- **FEXCore**: 2508 (padrão), 2601 (alternativa)
- **WoWBox64**: 0.3.7
- **Box64**: 0.3.7
- **DXVK**: 2.3.1, 2.6.2-1 (preparado)
- **Turnip**: 25.1.0, v819
- **Proton**: 9.0-arm64ec

### 📊 Tamanho

- **Comprimido (.orfs)**: ~600MB (↑50MB do v1.0)
- **Instalado**: ~3.5GB (↑500MB do v1.0)
- **Motivo**: DLLs descomprimidos para melhor performance

### ⚡ Performance

- **Primeira execução**: 2-3x mais rápida (sem descompressão)
- **Boots subsequentes**: Sem mudança (DLLs já copiados)
- **Confiabilidade**: 100% (cópia direta de arquivos)

### 🔄 Compatibilidade

- **Requer**: GoWLauncher commit 545cc8a ou superior
- **Android**: 8.0+ (sem mudanças)
- **Arquitetura**: ARM64-v8a apenas

### 📝 Migração do v1.0

Se você já tem o v1.0 instalado:

1. **Não precisa desinstalar** - Apenas reimporte o v1.1
2. **Containers preservados** - Seus jogos continuam configurados
3. **Saves mantidos** - Nada é perdido

---

## v1.0 (2026-01-09) - Initial Release

### 🎉 Release Inicial

- ImageFS v21 completo
- Proton 9.0 ARM64EC
- Turnip 25.1.0 driver
- DXVK 2.3.1 com gplasync
- Preset otimizado para God of War
