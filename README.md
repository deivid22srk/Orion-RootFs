# 🚀 Orion RootFS

Sistema de arquivos raiz para **GoWLauncher** - Um launcher otimizado para executar God of War e outros jogos Windows no Android via Wine/Proton.

## 📋 O que é?

O Orion RootFS é um pacote compilado contendo todos os arquivos de sistema necessários para o GoWLauncher funcionar:
- **ImageFS**: Sistema de arquivos Linux completo
- **Proton 9.0 ARM64EC**: Camada de compatibilidade Wine otimizada
- **Drivers Gráficos**: Turnip/Adreno drivers para Vulkan
- **DXVK/VKD3D**: Wrappers DirectX para Vulkan
- **Componentes Wine**: DirectX, DirectSound, etc.

## 📦 Estrutura

```
Orion-RootFs/
├── sources/              → Assets originais
│   ├── imagefs/          → Sistema base Linux
│   ├── proton/           → Wine/Proton binários
│   ├── graphics_driver/  → Drivers gráficos
│   ├── dxwrapper/        → DXVK, VKD3D
│   └── wincomponents/    → Componentes Wine
├── scripts/              → Scripts de automação
│   ├── download.sh       → Baixa assets externos
│   ├── compile.sh        → Compila RootFS
│   └── verify.sh         → Verifica integridade
└── .github/workflows/    → GitHub Actions
    └── build.yml         → Build automático
```

## 🔧 Como Usar

### Para Desenvolvedores

1. Clone o repositório:
```bash
git clone https://github.com/deivid22srk/Orion-RootFs.git
cd Orion-RootFs
```

2. Execute o build manual (opcional):
```bash
bash scripts/download.sh
bash scripts/compile.sh
```

3. O workflow GitHub Actions faz isso automaticamente a cada push!

### Para Usuários

1. Baixe o último **Orion RootFS** dos [Releases](https://github.com/deivid22srk/Orion-RootFs/releases)
2. Arquivo: `orion-rootfs-v1.0.orfs` (~500MB)
3. Abra o GoWLauncher
4. Clique em "Importar RootFS"
5. Selecione o arquivo baixado
6. Aguarde a instalação (~3-5 minutos)

## 📊 Especificações

| Componente | Versão | Tamanho |
|------------|--------|---------|
| ImageFS | v21 | ~300MB comprimido, ~2GB extraído |
| Proton | 9.0 ARM64EC | ~100MB comprimido, ~400MB extraído |
| Turnip Driver | 25.1.0 | ~20MB |
| DXVK | 2.6.2-1-arm64ec | ~15MB |
| **Total** | - | **~550MB comprimido, ~3GB extraído** |

## 🎮 Compatibilidade

- **Android**: 8.0+ (API 26+)
- **Arquitetura**: ARM64-v8a apenas
- **Espaço**: Mínimo 5GB livre
- **RAM**: Recomendado 4GB+

## 🔄 Atualizações

O RootFS pode ser atualizado independentemente do APK do GoWLauncher:
- **Versões**: Cada release tem um número de versão
- **Changelog**: Veja o que mudou em cada versão
- **Backward Compatible**: Geralmente compatível com versões antigas do app

## 📝 Changelog

### v1.0 (2026-01-09)
- 🎉 Release inicial
- ✅ ImageFS v21
- ✅ Proton 9.0 ARM64EC
- ✅ Turnip 25.1.0
- ✅ DXVK 2.6.2-1 com gplasync
- ✅ Preset otimizado para God of War

## 🤝 Contribuindo

Contribuições são bem-vindas! Se você quer adicionar novos drivers, otimizações ou componentes:

1. Fork o repositório
2. Crie uma branch (`git checkout -b feature/nova-otimizacao`)
3. Commit suas mudanças (`git commit -m 'Adiciona nova otimização'`)
4. Push para a branch (`git push origin feature/nova-otimizacao`)
5. Abra um Pull Request

## 📄 Licença

Este projeto contém componentes de software livre de várias fontes:
- **Wine/Proton**: LGPL 2.1+
- **DXVK**: Zlib License
- **Mesa/Turnip**: MIT License
- **GoWLauncher**: [Ver repositório principal]

## 🔗 Links

- [GoWLauncher App](https://github.com/deivid22srk/GoWLauncher-Android)
- [Reportar Bug](https://github.com/deivid22srk/Orion-RootFs/issues)
- [Discussões](https://github.com/deivid22srk/Orion-RootFs/discussions)

## ⚠️ Avisos

- O download e uso de RootFS requer conexão com internet estável
- Certifique-se de ter espaço suficiente antes de importar
- Não delete arquivos manualmente do sistema instalado
- Em caso de problemas, reimporte o RootFS

---

**Desenvolvido com ❤️ para a comunidade de gaming no Android**
