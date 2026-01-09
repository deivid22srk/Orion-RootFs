# 📁 Sources Directory

Este diretório contém todos os assets necessários para compilar o Orion RootFS.

## 📋 Estrutura

```
sources/
├── imagefs/              → Sistema base Linux (ImageFS)
├── proton/               → Wine/Proton binários
├── graphics_driver/      → Drivers gráficos (Adreno/Turnip)
├── dxwrapper/            → DXVK, VKD3D
├── wincomponents/        → Componentes Wine (DirectX, etc)
├── box64/                → Emulador Box64
├── fexcore/              → Emulador FEXCore
├── others/               → Outros componentes
└── metadata.json         → Metadados da build
```

## 📥 Assets Externos (Baixados)

Estes arquivos são baixados pelo `scripts/download.sh` e **NÃO** devem ser commitados no Git:

### imagefs/
- `imagefs.txz` (~300MB)
  - Source: GitLab Winlator
  - Compressão: XZ
  - Contém: Sistema Linux completo

### proton/
- `proton-9.0-arm64ec.txz` (~100MB)
  - Source: GitLab Winlator
  - Compressão: XZ
  - Contém: Wine/Proton binários

## 📦 Assets Incorporados (No Repositório)

Estes arquivos são copiados do app GoWLauncher e **podem** ser commitados:

### graphics_driver/
- `adrenotools-System.tzst`
- `adrenotools-v819.tzst`
- `adrenotools-turnip25.1.0.tzst`
- `wrapper.tzst`
- `extra_libs.tzst`
- `zink_dlls.tzst`

### dxwrapper/
- DXVK versions
- VKD3D versions

### wincomponents/
- DirectX components
- Runtime libraries

### box64/, fexcore/, others/
- Emuladores e componentes auxiliares

## 🚫 .gitignore

O arquivo `.gitignore` na raiz do repositório está configurado para:
- ✅ Ignorar `imagefs.txz` e `proton-9.0-arm64ec.txz` (muito grandes)
- ✅ Ignorar diretórios copiados do app (gerados automaticamente)
- ✅ Permitir `metadata.json` e estrutura de pastas

## 🔄 Atualização

Para atualizar assets:

1. **Assets externos** (imagefs, proton):
   - Edite URLs em `scripts/download.sh`
   - Execute novamente o script

2. **Assets incorporados**:
   - Atualize no app GoWLauncher primeiro
   - Execute `scripts/download.sh` para copiar

3. **Metadata**:
   - Edite `sources/metadata.json` com novas versões
   - Atualizar checksums se necessário

## ⚙️ Como o Build Usa Isso

1. **GitHub Actions** executa `scripts/download.sh`
   - Baixa imagefs.txz e proton.txz
   - Copia assets do app (se disponível)

2. **GitHub Actions** executa `scripts/compile.sh`
   - Organiza tudo em estrutura correta
   - Cria metadata.json com info da build
   - Compacta em arquivo .orfs

3. **Resultado**: `orion-rootfs-v1.0.orfs` pronto para distribuição
