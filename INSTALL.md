# 📥 Guia de Instalação - Orion RootFS

## Para Usuários do GoWLauncher

### Passo 1: Baixar o RootFS

1. Acesse: [Releases do Orion-RootFs](https://github.com/deivid22srk/Orion-RootFs/releases/latest)
2. Baixe o arquivo `orion-rootfs-v1.0.orfs` (~500MB)
3. Salve em um local de fácil acesso no seu dispositivo

### Passo 2: Verificar Integridade (Opcional)

1. Baixe também o arquivo `orion-rootfs-v1.0.sha256`
2. Use um app de checksum para verificar a integridade
3. Compare com o hash no arquivo .sha256

### Passo 3: Importar no GoWLauncher

1. Abra o **GoWLauncher**
2. Na primeira execução, você verá uma mensagem "Sistema Não Instalado"
3. Clique em **"Importar RootFS"**
4. Selecione o arquivo `orion-rootfs-v1.0.orfs` que você baixou
5. Confirme a importação
6. Aguarde 3-5 minutos (depende do dispositivo)
7. Pronto! O sistema está instalado

### Passo 4: Começar a Jogar

1. Clique em **"Adicionar Jogo"**
2. Navegue até a pasta do seu jogo
3. Selecione o executável (.exe)
4. Digite um nome para o jogo
5. Clique em iniciar!

---

## Para Desenvolvedores

### Compilar o RootFS Localmente

```bash
# Clone o repositório
git clone https://github.com/deivid22srk/Orion-RootFs.git
cd Orion-RootFs

# Baixe os assets externos
bash scripts/download.sh

# Compile o pacote
bash scripts/compile.sh

# Verifique a integridade
bash scripts/verify.sh

# O arquivo estará em: output/orion-rootfs-v1.0.orfs
```

### Estrutura do Pacote .orfs

```
orion-rootfs-v1.0.orfs (arquivo tar.zst)
├── rootfs/
│   ├── metadata.json                     → Informações da build
│   ├── imagefs/
│   │   └── imagefs.txz                   → Sistema base Linux
│   ├── proton/
│   │   └── proton-9.0-arm64ec.txz       → Wine/Proton
│   ├── graphics_driver/
│   │   ├── adrenotools-System.tzst
│   │   ├── adrenotools-v819.tzst
│   │   └── adrenotools-turnip25.1.0.tzst
│   ├── dxwrapper/
│   │   ├── dxvk-*.tzst
│   │   └── vkd3d-*.tzst
│   ├── wincomponents/
│   │   └── *.tzst
│   └── others/
│       └── arquivos adicionais
```

### Modificar e Criar Nova Versão

1. Modifique os assets em `sources/`
2. Atualize a versão em `scripts/compile.sh`
3. Execute `bash scripts/compile.sh`
4. Faça commit e push
5. Crie uma tag: `git tag v1.1.0 && git push --tags`
6. O GitHub Actions criará o release automaticamente

---

## Requisitos do Sistema

### Dispositivo Android
- **Android**: 8.0 ou superior (API 26+)
- **Arquitetura**: ARM64-v8a (64 bits)
- **RAM**: 4GB ou mais (recomendado 6GB+)
- **Armazenamento**: 5GB livres (8GB+ recomendado)
- **GPU**: Suporte a Vulkan 1.1+

### Durante Instalação
- **Conexão**: WiFi estável (para download inicial)
- **Bateria**: 50%+ ou conectado ao carregador
- **Espaço**: Livre em memória interna (não aceita SD Card)

---

## Troubleshooting

### ❌ "Arquivo inválido"
- Verifique se baixou o arquivo .orfs completo
- Confirme que não está corrompido (use checksum)
- Tente baixar novamente

### ❌ "Espaço insuficiente"
- Libere pelo menos 5GB de espaço
- Vá em Configurações → Armazenamento
- Delete apps ou arquivos desnecessários

### ❌ "Erro ao extrair"
- Verifique se o arquivo não está corrompido
- Certifique-se de ter permissões de armazenamento
- Reinicie o dispositivo e tente novamente

### ❌ "Instalação muito lenta"
- Normal em dispositivos mais antigos (pode levar até 10 minutos)
- Não feche o app durante a instalação
- Mantenha o dispositivo conectado ao carregador

---

## Atualização

Para atualizar para uma nova versão do RootFS:

1. Baixe a nova versão do .orfs
2. No GoWLauncher, vá em **Configurações** → **Importar RootFS**
3. Selecione o novo arquivo
4. Confirme a reinstalação
5. ⚠️ **Seus jogos salvos em `/home` serão preservados**

---

## Suporte

- **Issues**: [GitHub Issues](https://github.com/deivid22srk/Orion-RootFs/issues)
- **Discussões**: [GitHub Discussions](https://github.com/deivid22srk/Orion-RootFs/discussions)
- **App Principal**: [GoWLauncher](https://github.com/deivid22srk/GoWLauncher-Android)
