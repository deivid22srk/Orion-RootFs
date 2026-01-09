# Sources Directory - Orion RootFS

## 📁 Estrutura de Diretórios

Esta pasta contém todos os componentes que serão incluídos no pacote `.orfs`.

### Estrutura Completa

```
sources/
├── metadata.json                  # Informações da build
├── box64/                         # Emulador Box64 (para Wine x86_64)
│   ├── box64-0.3.7.tzst          # Comprimido (fallback)
│   └── box64-0.3.7/              # ✨ Descomprimido (preferencial)
│       └── usr/bin/box64
├── fexcore/                       # Emulador FEXCore (para Wine ARM64EC)
│   ├── fexcore-2508.tzst         # Comprimido (fallback)
│   ├── fexcore-2508/             # ✨ Descomprimido (preferencial)
│   │   ├── libwow64fex.dll
│   │   └── libarm64ecfex.dll
│   ├── fexcore-2601.tzst         # Versão alternativa
│   └── fexcore-2601/             # ✨ Descomprimido
│       ├── libwow64fex.dll
│       └── libarm64ecfex.dll
├── dxwrapper/                     # DirectX to Vulkan wrappers
│   ├── dxvk-2.6.2-1-arm64ec-gplasync/  # ✨ Descomprimido
│   │   ├── system32/*.dll
│   │   └── syswow64/*.dll
│   ├── dxvk-2.3.1-arm64ec-gplasync/    # ✨ Descomprimido
│   │   ├── system32/*.dll
│   │   └── syswow64/*.dll
│   ├── vkd3d-*.tzst              # VKD3D (D3D12)
│   └── d8vk-*.tzst               # D8VK (D3D8)
├── graphics_driver/               # Drivers de GPU
│   ├── adrenotools-turnip25.1.0/ # ✨ Descomprimido
│   │   ├── vulkan.ad07xx.so
│   │   └── meta.json
│   ├── adrenotools-v819/         # ✨ Descomprimido
│   │   └── vulkan.ad8191.so
│   ├── wrapper.tzst              # Wrapper configs
│   ├── extra_libs.tzst           # Libs adicionais
│   └── zink_dlls.tzst            # Zink DLLs
├── wincomponents/                 # Componentes do Windows
│   ├── direct3d.tzst
│   ├── directsound.tzst
│   ├── vcrun2010.tzst
│   └── ...
└── others/                        # Componentes diversos
    ├── wowbox64/                  # WoW64 DLLs para Box64
    │   ├── wowbox64-0.3.7.tzst
    │   └── wowbox64-0.3.7/       # ✨ Descomprimido
    │       └── wowbox64.dll
    ├── container_pattern_common.tzst
    ├── proton-9.0-arm64ec_container_pattern.tzst
    ├── input_dlls.tzst
    ├── layers.tzst
    └── ...
```

## 🎯 Mudança Importante: Arquivos Descomprimidos

### Por que descomprimir?

**Problema anterior:**
- O código tentava extrair .tzst em tempo real durante o primeiro boot
- Se falhasse, o Wine iniciava sem os DLLs necessários e morria
- `box64Version` vazio causava pulo na extração

**Nova solução:**
- **DLLs críticos já vêm descomprimidos** em pastas separadas
- O código tenta primeiro copiar os arquivos prontos
- Se não existirem, faz fallback para extrair o .tzst
- Muito mais rápido e confiável

### Arquivos Críticos Descomprimidos

1. **fexcore-2508/** e **fexcore-2601/**
   - `libwow64fex.dll` - Emulador WoW64 principal do FEXCore
   - `libarm64ecfex.dll` - Suporte ARM64EC

2. **wowbox64-0.3.7/**
   - `wowbox64.dll` - Emulador WoW64 do Box64

3. **box64-0.3.7/**
   - `usr/bin/box64` - Executável do Box64

4. **dxvk-*/**
   - `system32/*.dll` - DLLs DirectX 64-bit
   - `syswow64/*.dll` - DLLs DirectX 32-bit

5. **adrenotools-*/**
   - `vulkan.ad*.so` - Drivers Vulkan para GPU Adreno

## 📦 Como o ORFS é Montado

1. **scripts/compile.sh** compacta tudo em um único arquivo:
   ```
   orion-rootfs-v1.1.orfs
   ```

2. **GoWLauncher** instala o ORFS:
   - Extrai `orion-rootfs-v1.1.orfs` para `/cache/rootfs_temp/`
   - Copia `sources/*` para `/files/contents/`
   - Mantém **AMBAS** versões (comprimida .tzst + descomprimida)

3. **Primeira execução do jogo:**
   - Tenta copiar de `contents/fexcore/fexcore-2601/` (direto)
   - Se não existir, extrai `contents/fexcore/fexcore-2601.tzst`
   - Salva no container para não copiar novamente

## 🔍 Verificar Instalação

Após importar o ORFS no GoWLauncher, verifique:

```bash
# Verificar se DLLs descomprimidos estão presentes
adb shell ls -la /data/data/com.gowlauncher/files/contents/fexcore/
# Deve mostrar: fexcore-2508/ fexcore-2508.tzst fexcore-2601/ fexcore-2601.tzst

adb shell ls -la /data/data/com.gowlauncher/files/contents/fexcore/fexcore-2601/
# Deve mostrar: libwow64fex.dll libarm64ecfex.dll
```

## 📊 Tamanho dos Componentes

| Componente | .tzst | Descomprimido | Total |
|------------|-------|---------------|-------|
| fexcore-2508 | 3.3MB | 17MB | 20.3MB |
| wowbox64-0.3.7 | 1MB | 4.5MB | 5.5MB |
| box64-0.3.7 | 2.9MB | 17MB | 19.9MB |
| **Overhead** | - | - | **~40MB extra** |

O overhead de 40MB vale MUITO a pena pela confiabilidade e velocidade.

## ⚙️ Desenvolvimento

### Adicionar Nova Versão de Componente

**Exemplo: Adicionar FEXCore 2700**

```bash
cd sources/fexcore

# Criar diretório
mkdir fexcore-2700

# Adicionar DLLs (obtenha do build do FEXCore)
cp /caminho/para/libwow64fex.dll fexcore-2700/
cp /caminho/para/libarm64ecfex.dll fexcore-2700/

# Criar .tzst de backup
tar -c -I 'zstd -19' -f fexcore-2700.tzst -C fexcore-2700 .

# Verificar
ls -lh fexcore-2700/
```

### Remover Versão Antiga

```bash
# Remover versão 2508 (exemplo)
cd sources/fexcore
rm -rf fexcore-2508/ fexcore-2508.tzst
```

## 🚀 Build e Release

Após modificar os sources, rode:

```bash
bash scripts/compile.sh
```

Isso irá:
1. Validar estrutura
2. Criar `orion-rootfs-v1.1.orfs`
3. Gerar checksum SHA256
4. Colocar em `output/`

Depois faça push e crie release no GitHub.
