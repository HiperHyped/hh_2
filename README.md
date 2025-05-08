# HiperHyped

> **HiperHyped** é um aplicativo Flutter multiplataforma para navegação, busca e gerenciamento de produtos, receitas e categorias, com integração a serviços de AI e backend PHP/MySQL.

---

## Índice

- [Visão Geral](#visão-geral)  
- [Funcionalidades Principais](#funcionalidades-principais)  
- [Arquitetura e Estrutura](#arquitetura-e-estrutura)  
- [Pré-requisitos](#pré-requisitos)  
- [Instalação](#instalação)  
- [Configuração](#configuração)  
- [Execução Local](#execução-local)  
- [Testes](#testes)  
- [Build e Deploy](#build-e-deploy)  
- [Como Contribuir](#como-contribuir)  
- [Licença](#licença)  

---

## Visão Geral

O **HiperHyped** é um app desenvolvido em Flutter que roda em Android, iOS, web e desktop (Windows, Linux, macOS). Ele oferece:

- **Navegação por categorias** via XML (HH_CAT.xml) e barras de seleção verticais/horizontais  
- **Busca inteligente** com autocomplete (TypeAheadField) e integração com OpenAI API  
- **Carrinho de compras** (Basket) e gerenciamento de histórico  
- **Módulos temáticos**: livros, receitas, dimensões, periodicidade, imagens, pagamentos (cartão, PIX, QR Code)  
- **Autenticação e backend**: AWS Amplify (Cognito) para auth; API RESTful em PHP/MySQL para dados  

---

## Funcionalidades Principais

- **Multiplataforma**: suporte a Android, iOS, Web e Desktop  
- **Autenticação**: via AWS Amplify/Cognito  
- **Backend PHP/MySQL**: scripts em `api/` (e.g., `db_handler.php`) para CRUD e buscas avançadas  
- **Busca em tempo real**: TypeAhead com debounce e filtragem local via SQLite/DBService  
- **Categorias**: árvore hierárquica de materiais/serviços, carregada de XML em `assets/xml/HH_CAT.xml`  
- **Carrinho e Pagamentos**: gerenciamento de cestas, cálculo de valores, interface para Pix, cartão e QR Code  
- **Histórico e Estatísticas**: páginas de histórico (`history/`) e dashboards (`summary/`) com histogramas  
- **Módulos adicionais**: livros, receitas, periodicidade, dimensões e upload/exibição de fotos  

---

## Arquitetura e Estrutura

```
├── amplify/                # Configuração AWS Amplify (auth, storage…)
├── api/                    # API PHP / MySQL (db_handler.php, search_v*.php…)
├── assets/                 # Imagens, XML, configurações de UI
│   ├── images/
│   └── xml/HH_CAT.xml
├── lib/
│   ├── src/
│   │   ├── config/         # Cores, dimensões, AI e helpers
│   │   ├── models/         # Modelos de dados (SearchModel, BasketModel…)
│   │   ├── pages/          # Widgets de tela (basket, book, cat, grid, pay…)
│   │   └── services/       # Integrações HTTP, OpenAI, DB
├── android/                # Projeto Android nativo
├── ios/                    # Projeto iOS nativo
├── web/                    # Web build + service worker
├── linux/, macos/, windows/ # Suporte desktop via Flutter
├── pubspec.yaml            # Dependências Flutter/Dart
└── manifest.json           # PWA meta (nome: “Hiper Hyped”)
```

---

## Pré-requisitos

- Flutter SDK (>= 3.0) e Dart  
- Node.js + npm (para o AWS Amplify CLI)  
- AWS CLI configurado com credenciais válidas  
- PHP >= 7.4 e MySQL para rodar a pasta `api/`  
- Chave de API OpenAI (se for usar funcionalidades de AI)  

---

## Instalação

1. **Clone o repositório**  
   ```bash
   git clone https://github.com/seu-usuario/hiperhyped.git
   cd hiperhyped
   ```

2. **Dependências Flutter**  
   ```bash
   flutter pub get
   ```

3. **Configurar Amplify**  
   ```bash
   amplify pull --sandbox-id your-sandbox-id  # ou amplify init, amplify push
   ```

4. **Configurar variáveis de ambiente**  
   - Crie um arquivo `.env` na raiz contendo:  
     ```
     OPENAI_API_KEY=...
     AWS_REGION=...
     AWS_USER_POOL_ID=...
     AWS_APP_CLIENT_ID=...
     ```
   - No PHP (`api/db_handler.php`), ajuste `host`, `db`, `user` e `pass`.

---

## Execução Local

- **Web**  
  ```bash
  flutter run -d chrome
  ```
- **Mobile**  
  ```bash
  flutter run -d <device-id>
  ```
- **Desktop**  
  ```bash
  flutter run -d windows      # ou macos, linux
  ```

---

## Testes

Execute todos os testes de unidade e widget:
```bash
flutter test
```

---

## Build e Deploy

- **Web PWA**  
  ```bash
  flutter build web
  # Hospede o conteúdo de build/web em um servidor estático
  ```
- **Android APK**  
  ```bash
  flutter build apk --release
  ```
- **iOS**  
  ```bash
  flutter build ios --release
  ```
- **Desktop**  
  ```bash
  flutter build windows   # macos, linux
  ```

---

## Como Contribuir

1. Faça um _fork_ do projeto  
2. Crie uma **branch** para sua feature ou correção  
3. Implemente e documente suas alterações  
4. Abra um **Pull Request** descrevendo o que foi feito  

---

## Licença

Este projeto está licenciado sob a **MIT License**. Veja o arquivo [LICENSE](./LICENSE) para mais detalhes.
