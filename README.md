# 📱 Desafio Técnico: App de Anúncios (OLX)

Este projeto é um **aplicativo Flutter** que simula a tela de **listagem de anúncios da OLX**, consumindo uma API (real ou mockada) e exibindo anúncios com **filtros por categoria** e **scroll infinito com paginação**.

O objetivo é demonstrar o uso de **gerenciamento de estado complexo**, combinando filtros + paginação de forma **reativa e performática**, seguindo princípios de Clean Architecture.

---

## 🚀 Funcionalidades

### 📄 Listagem Inicial
- Ao abrir o app, é carregada automaticamente a **primeira página de anúncios**.
- Os resultados iniciais listam **todas as categorias**.

### 🏷️ Filtro de Categoria
- Exibe opções como:
  - Carros  
  - Imóveis  
  - Eletrônicos  
- Ao selecionar uma categoria:
  - A lista recarrega automaticamente.
  - Apenas anúncios daquela categoria são exibidos.
  - A paginação é reiniciada.

### 🔄 Paginação (Scroll Infinito)
- Quando o usuário chega perto do fim da lista:
  - A próxima página de resultados é buscada automaticamente.
  - Os novos itens são **adicionados** (append), sem perder os anteriores.
- Exibe indicador de carregamento no final da lista.

---

## 🛠️ Tecnologias Utilizadas

| Tecnologia | Descrição |
|-----------|-----------|
| **Flutter (SDK)** | Framework principal |
| **Provider** | Gerenciamento reativo do estado |
| **http** | Comunicação com APIs |
| **cached_network_image** | Carregamento e cache de imagens |
| **intl** | Formatação de moeda e textos |

---

## 🎯 Objetivos de Aprendizado (Clean Architecture)

### 🧠 Gerenciamento de Estado Complexo
- Manipular múltiplos parâmetros dentro de um único provider:
  - `page`
  - `selectedCategory`
  - `isLoading`
  - `hasMoreData`
  - `items`

### 📜 Paginação (Scroll Infinito)
- Implementação de `ScrollController` para detectar final da lista.
- Disparo automático de requisição da próxima página.

### 📌 Lógica de "Append"
- Em vez de substituir, novos resultados são **adicionados ao final da lista**.

### 🎚️ Reatividade a Filtros
- Ao alterar o filtro:
  - Zera a paginação.
  - Limpa a lista atual.
  - Recarrega resultados.
  - Atualiza a UI de forma automática.

---

## 🌐 API Utilizada (Mock — DummyJSON)

Para este desafio foi utilizada a API pública de testes **DummyJSON**, ideal para simulação de:

- Listagem com paginação  
- Filtros por categoria  
- Detalhes de produtos

### 📦 Endpoints Usados

| Função | Endpoint |
|--------|----------|
| Listar produtos (geral) | `https://dummyjson.com/products?limit=10&skip={offset}` |
| Listar por categoria | `https://dummyjson.com/products/category/{categoryName}?limit=10&skip={offset}` |
| Categorias | `https://dummyjson.com/products/categories` |
