
Este projeto ABAP é um report interativo desenvolvido para registrar e visualizar as preferências musicais de ouvintes, utilizando uma tabela Z (`ZHRTMUSIC`) como repositório de dados. O projeto foi criado com o objetivo de praticar manipulação de dados, uso de telas de seleção, ALV e lógica de validação no SAP ECC.

## Funcionalidades

- Tela de seleção com parâmetros para entrada de dados:
  - ID do ouvinte
  - Artista preferido
  - Música preferida
- Dois botões na tela de seleção:
  - `Confirmar envio de dados`: Grava os dados inseridos na tabela Z.
  - `Mostrar dados já salvos`: Exibe os registros da tabela `ZHRTMUSIC` em um relatório ALV.
- Validação de dados obrigatórios antes da gravação.
- Exibição de mensagens de sucesso ou erro.
- Utilização do `REUSE_ALV_GRID_DISPLAY` para visualização em grid.

## Estrutura da Tabela ZHRTMUSIC

A tabela personalizada `ZHRTMUSIC` deve conter os seguintes campos:

| Campo         | Tipo de Dado    | Descrição              |
|---------------|------------------|-------------------------|
| ID_OUVINTE    | `Z_ID_OUVINTE`   | Identificador do ouvinte |
| ARTISTA_PREF  | `Z_ARTISTA_PREF` | Nome do artista preferido |
| MUSIC_PREF    | `Z_MUSIC_PREF`   | Nome da música preferida |

## Execução

1. Acesse a transação `SE38` ou `SA38` no SAP.
2. Execute o report `ZHRRMUSIC`.
3. Preencha os campos com as preferências musicais e clique em **Confirmar envio de dados** para gravar.
4. Clique em **Mostrar dados já salvos** para visualizar todos os registros no ALV.

## Lógica do Report

- O botão **Confirmar envio de dados** simula o F8 e grava os dados caso todos os campos estejam preenchidos.
- O botão **Mostrar dados já salvos** executa diretamente a função de exibição ALV.
- O Field Catalog do ALV é montado dinamicamente.
- Os dados são gravados em memória interna e depois persistidos na tabela Z.

## Tecnologias Utilizadas

- ABAP procedural
- SELECTION-SCREEN
- ALV (`REUSE_ALV_GRID_DISPLAY`)
- Manipulação de tabelas internas
- Field Symbols

---


