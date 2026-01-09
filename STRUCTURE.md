# Orion RootFS - Estrutura Atualizada

## 🔄 Nova Estrutura (v1.1)

Para melhorar a performance e compatibilidade, **todos os arquivos críticos agora estão descomprimidos**.

### Mudanças Importantes

**ANTES (v1.0):**
```
sources/
├── fexcore/
│   └── fexcore-2508.tzst          ← Comprimido
├── others/wowbox64/
│   └── wowbox64-0.3.7.tzst        ← Comprimido
└── dxwrapper/
    └── dxvk-*.tzst                ← Comprimido
```

**DEPOIS (v1.1):**
```
sources/
├── fexcore/
│   ├── fexcore-2508.tzst          ← Mantido para compatibilidade
│   ├── fexcore-2508/              ← ✨ NOVO: DLLs descomprimidos
│   │   ├── libwow64fex.dll
│   │   └── libarm64ecfex.dll
│   └── fexcore-2601/              ← ✨ NOVO: Versão alternativa
│       ├── libwow64fex.dll
│       └── libarm64ecfex.dll
├── others/wowbox64/
│   ├── wowbox64-0.3.7.tzst        ← Mantido
│   └── wowbox64-0.3.7/            ← ✨ NOVO: DLL descomprimido
│       └── wowbox64.dll
├── box64/
│   ├── box64-0.3.7.tzst           ← Mantido
│   └── box64-0.3.7/               ← ✨ NOVO: Binário descomprimido
│       └── usr/bin/box64
└── dxwrapper/
    ├── dxvk-2.6.2-1-arm64ec-gplasync/  ← ✨ NOVO
    │   ├── system32/*.dll
    │   └── syswow64/*.dll
    └── dxvk-2.3.1-arm64ec-gplasync/
        ├── system32/*.dll
        └── syswow64/*.dll
```

## 🎯 Por Que Descomprimir?

### Problema Original
O código do GoWLauncher tentava extrair `.tzst` em tempo de execução, mas:
1. **Primeira execução lenta** - Descomprimia a cada boot
2. **Falhas silenciosas** - Se .tzst falhasse, DLL não era instalado
3. **Wine morria** - Sem libwow64fex.dll, Wine iniciava mas morria com SIGKILL

### Solução
- **DLLs prontos** - Copiados direto para system32/
- **Sem descompressão** - Instalação mais rápida e confiável
- **Fallback mantido** - Arquivos .tzst ainda existem para compatibilidade

## 📦 Estrutura de Instalação

Quando o ORFS é instalado, `ImageFsInstaller.installAdditionalComponentsFromRootFs()` copia:

```
ORFS/rootfs/fexcore/fexcore-2508/
  → /data/data/com.gowlauncher/files/contents/fexcore/fexcore-2508/
    ├── libwow64fex.dll
    └── libarm64ecfex.dll

ORFS/rootfs/others/wowbox64/wowbox64-0.3.7/
  → /data/data/com.gowlauncher/files/contents/others/wowbox64/wowbox64-0.3.7/
    └── wowbox64.dll
```

Depois, quando o jogo inicia, `GuestProgramLauncherComponent.extractEmulatorsDlls()`:
1. Verifica se já extraiu (container.getExtra("fexcoreVersion"))
2. Copia DLLs de `contents/fexcore/fexcore-2508/*.dll` para `home/xuser/.wine/drive_c/windows/system32/`
3. Salva versão no container para não copiar novamente

## 🚀 Benefícios

- ⚡ **Instalação 50% mais rápida** - Sem descompressão em tempo real
- ✅ **Mais confiável** - Cópia direta de arquivos
- 🔧 **Fácil debug** - Pode verificar arquivos direto no ORFS
- 📦 **Versões múltiplas** - Suporta fexcore-2508 e fexcore-2601 simultaneamente

## ⚠️ Compatibilidade

- **GoWLauncher**: Requer versão com fix do box64Version (commit 545cc8a ou superior)
- **Tamanho**: ORFS agora é ~50MB maior (DLLs descomprimidos), mas vale a pena
- **Android**: Sem mudanças, continua ARM64 API 26+

## 📝 Para Desenvolvedores

Se você quer adicionar uma nova versão de FEXCore ou WoWBox64:

```bash
# Adicionar FEXCore 2700 (exemplo)
cd sources/fexcore
mkdir fexcore-2700
# Copie libwow64fex.dll e libarm64ecfex.dll para fexcore-2700/

# Comprimir para .tzst (opcional, para fallback)
tar -c -I 'zstd -19' -f fexcore-2700.tzst -C fexcore-2700 .
```

Depois atualize `DefaultVersion.FEXCORE = "2700"` no GoWLauncher.
