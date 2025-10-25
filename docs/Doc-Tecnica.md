Perfeito.  
A seguir está a **documentação técnica de referência** do módulo **CheckpointData**, em formato de **manual de desenvolvedor** — detalhado, direto, e segmentado por classe, atributo e método.  
Todo o conteúdo está alinhado ao estado atual do código e ao comportamento real (classes mutáveis, persistência local, estrutura incremental).

---

# 🧾 Documentação Técnica – Módulo `CheckpointData`

---

## 📂 Visão Geral

O módulo `CheckpointData` implementa o controle persistente e incremental do fluxo de cadastro de contas empresariais.  
Ele armazena os dados parciais de cada etapa (pessoa física, empresa, sócios), além do estágio atual do processo.

### Dependências

- `package:result_dart/result_dart.dart` — para encapsulamento de sucesso/erro;

- `LocalSecureStorage` — serviço de armazenamento local seguro (criptografado).

### Estrutura Principal

```
domain/
 └── entities/checkpoint/
      ├── checkpoint_data.dart
      ├── checkpoint_section_data.dart
      └── checkpoint_values/
           ├── base_checkpoint_values.dart
           ├── personal_account_values.dart
           ├── business_account_values.dart
           └── business_partners_values.dart
data/
 └── repositories/checkpoint_data_repository_impl.dart
```

---

## 🧩 Classe: `CheckpointData`

**Arquivo:** `/domain/entities/checkpoint/checkpoint_data.dart`  
**Descrição:** Representa o estado completo e persistente do progresso de cadastro.

### Atributos

| Campo                    | Tipo                      | Descrição                 |
| ------------------------ | ------------------------- | ------------------------- |
| `stage`                  | `CheckpointStage`         | Etapa atual do cadastro.  |
| `sectionData`            | `CheckpointSectionData`   | Metadados da seção atual. |
| `personalAccountValues`  | `PersonalAccountValues?`  | Dados da pessoa física.   |
| `businessAccountValues`  | `BusinessAccountValues?`  | Dados da empresa.         |
| `businessPartnersValues` | `BusinessPartnersValues?` | Lista de sócios.          |

### Métodos

| Método                                   | Retorno                | Descrição                                     |
| ---------------------------------------- | ---------------------- | --------------------------------------------- |
| `toJson()`                               | `Map<String, dynamic>` | Converte o estado atual em JSON.              |
| `fromJson(Map<String, dynamic> json)`    | `CheckpointData`       | Reconstrói o objeto a partir de JSON.         |
| `updateStage(CheckpointStage nextStage)` | `void`                 | Atualiza a etapa atual do processo.           |
| `clear()`                                | `void`                 | Zera todos os valores e redefine o progresso. |

### Exemplo JSON

```json
{
  "stage": "registerBusinessPartners",
  "personalAccountValues": {
    "fullName": "João Silva",
    "birthDate": "1990-02-10",
    "email": "joao@email.com"
  },
  "businessAccountValues": {
    "businessName": "Tech Solutions LTDA",
    "cnpj": "12345678000199",
    "companyType": "LTDA",
    "averageMonthlyRevenue": 25000
  },
  "businessPartnersValues": {
    "partners": [
      { "name": "Maria Souza", "cpf": "98765432100", "sharePercentage": 60 },
      { "name": "Carlos Pereira", "cpf": "12312312399", "sharePercentage": 40 }
    ]
  }
}
```

---

## ⚙️ Enum: `CheckpointStage`

**Arquivo:** `/domain/enums/checkpoint_enum.dart`  
**Descrição:** Define os estágios de progresso no cadastro.

| Valor                      | Descrição                    |
| -------------------------- | ---------------------------- |
| `noExistAccount`           | Nenhum cadastro iniciado.    |
| `createPersonalAccount`    | Etapa de dados pessoais.     |
| `createBusinessAccount`    | Etapa de dados empresariais. |
| `registerBusinessPartners` | Etapa de sócios.             |
| `checkpointCompleted`      | Cadastro completo.           |

---

## 🧱 Classe: `CheckpointSectionData`

**Arquivo:** `/domain/entities/checkpoint/checkpoint_section_data.dart`  
**Descrição:** Armazena informações estruturais da seção atual (sem os dados de formulário).

### Atributos

| Campo         | Tipo        | Descrição                        |
| ------------- | ----------- | -------------------------------- |
| `id`          | `String`    | Identificador da seção.          |
| `name`        | `String`    | Nome amigável da seção.          |
| `isCompleted` | `bool`      | Indica se a seção foi concluída. |
| `updatedAt`   | `DateTime?` | Última atualização da seção.     |

### Métodos

| Método                                | Retorno                 | Descrição            |
| ------------------------------------- | ----------------------- | -------------------- |
| `toJson()`                            | `Map<String, dynamic>`  | Serializa os dados.  |
| `fromJson(Map<String, dynamic> json)` | `CheckpointSectionData` | Reconstrói o objeto. |

### Exemplo JSON

```json
{
  "id": "section-01",
  "name": "Cadastro de Pessoa Física",
  "isCompleted": true,
  "updatedAt": "2025-10-24T12:15:30Z"
}
```

---

## 🧩 Classe: `BaseCheckpointValues`

**Arquivo:** `/domain/entities/checkpoint/checkpoint_values/base_checkpoint_values.dart`  
**Descrição:** Classe base para todas as seções de valores do checkpoint.

### Métodos esperados

| Método                           | Retorno                | Descrição                           |
| -------------------------------- | ---------------------- | ----------------------------------- |
| `toJson()`                       | `Map<String, dynamic>` | Serializa os valores.               |
| `fromJson(Map<String, dynamic>)` | `BaseCheckpointValues` | Constrói o objeto a partir de JSON. |
| `validate()`                     | `bool`                 | Retorna se os valores são válidos.  |

---

## 👤 Classe: `PersonalAccountValues`

**Arquivo:** `/domain/entities/checkpoint/checkpoint_values/personal_account_values.dart`  
**Descrição:** Representa os dados da pessoa física vinculada ao cadastro empresarial.

### Atributos

| Campo       | Tipo     | Descrição                        |
| ----------- | -------- | -------------------------------- |
| `fullName`  | `String` | Nome completo do titular.        |
| `birthDate` | `String` | Data de nascimento (AAAA-MM-DD). |
| `email`     | `String` | E-mail de contato.               |

### Exemplo JSON

```json
{
  "fullName": "João Silva",
  "birthDate": "1990-02-10",
  "email": "joao@email.com"
}
```

---

## 🏢 Classe: `BusinessAccountValues`

**Arquivo:** `/domain/entities/checkpoint/checkpoint_values/business_account_values.dart`  
**Descrição:** Contém os dados da empresa a ser cadastrada.

### Atributos

| Campo                   | Tipo                   | Descrição                        |
| ----------------------- | ---------------------- | -------------------------------- |
| `businessName`          | `String`               | Razão social da empresa.         |
| `cnpj`                  | `String`               | CNPJ completo (14 dígitos).      |
| `companyType`           | `String`               | Tipo jurídico (LTDA, MEI, etc.). |
| `foundedDate`           | `String`               | Data de fundação (AAAA-MM-DD).   |
| `averageMonthlyRevenue` | `double`               | Faturamento médio mensal.        |
| `address`               | `Map<String, dynamic>` | Endereço da sede da empresa.     |

### Exemplo JSON

```json
{
  "businessName": "Tech Solutions LTDA",
  "cnpj": "12345678000199",
  "companyType": "LTDA",
  "foundedDate": "2018-06-20",
  "averageMonthlyRevenue": 25000.00,
  "address": {
    "cep": "29100000",
    "street": "Rua Central",
    "number": "123",
    "city": "Vitória",
    "uf": "ES"
  }
}
```

---

## 👥 Classe: `BusinessPartnersValues`

**Arquivo:** `/domain/entities/checkpoint/checkpoint_values/business_partners_values.dart`  
**Descrição:** Lista de sócios vinculados à empresa.

### Atributos

| Campo      | Tipo            | Descrição                          |
| ---------- | --------------- | ---------------------------------- |
| `partners` | `List<Partner>` | Lista de sócios (objetos simples). |

Cada parceiro contém:

```json
{
  "name": "Maria Souza",
  "cpf": "98765432100",
  "sharePercentage": 60,
  "role": "Sócia Administradora"
}
```

### Exemplo JSON completo

```json
{
  "partners": [
    {
      "name": "Maria Souza",
      "cpf": "98765432100",
      "sharePercentage": 60,
      "role": "Sócia Administradora"
    },
    {
      "name": "Carlos Pereira",
      "cpf": "12312312399",
      "sharePercentage": 40,
      "role": "Sócio"
    }
  ]
}
```

---

## 💾 Classe: `CheckpointDataRepositoryImpl`

**Arquivo:** `/data/repositories/checkpoint_data_repository_impl.dart`  
**Descrição:** Implementa `CheckpointDataRepository`.  
Gerencia leitura, gravação e remoção do estado do checkpoint.

### Atributos

| Campo             | Tipo                 | Descrição                                 |
| ----------------- | -------------------- | ----------------------------------------- |
| `_secureStorage`  | `LocalSecureStorage` | Serviço de armazenamento criptografado.   |
| `_storageKey`     | `String`             | Chave fixa usada para gravar o estado.    |
| `_checkpointData` | `CheckpointData`     | Cache interno do último estado carregado. |

---

### Métodos

| Método                                                      | Retorno                                                                               | Descrição                                   |
| ----------------------------------------------------------- | ------------------------------------------------------------------------------------- | ------------------------------------------- |
| `AsyncResult<CheckpointData> getCheckpointData()`           | Carrega os dados do storage, converte para `CheckpointData` e atualiza o cache local. |                                             |
| `AsyncResult<Unit> saveCheckpointData(CheckpointData data)` | Converte os dados em JSON e salva no storage.                                         |                                             |
| `AsyncResult<Unit> clearCheckpointData()`                   | Remove os dados salvos e limpa o cache.                                               |                                             |
| `_handleError(String method, Object error)`                 | `Failure<GenericFailure>`                                                             | Loga e encapsula erros de leitura/gravação. |

---

### Exemplo de Fluxo Operacional

```dart
final repository = CheckpointDataRepositoryImpl(LocalSecureStorage());

// Ler dados salvos
final result = await repository.getCheckpointData();

// Atualizar e salvar
if (result.isSuccess()) {
  final data = result.getOrThrow();
  data.stage = CheckpointStage.createBusinessAccount;
  await repository.saveCheckpointData(data);
}
```

---

### Exemplo de Armazenamento (SecureStorage)

```json
{
  "stage": "createBusinessAccount",
  "personalAccountValues": {
    "fullName": "João Silva",
    "birthDate": "1990-02-10",
    "email": "joao@email.com"
  },
  "businessAccountValues": {
    "businessName": "Tech Solutions LTDA",
    "cnpj": "12345678000199"
  },
  "lastUpdate": "2025-10-24T12:00:00Z"
}
```

---

## 🔄 Fluxo Completo de Dados

```
[App iniciado]
     ↓
getCheckpointData()
     ↓
carrega JSON do SecureStorage
     ↓
monta CheckpointData
     ↓
usuário preenche etapa atual
     ↓
saveCheckpointData()
     ↓
dados são gravados incrementalmente
     ↓
fluxo avança para o próximo estágio
```

---

## 🧱 Padrões e Convenções

- **Mutabilidade controlada:** classes permitem alterações diretas em atributos, facilitando persistência incremental.

- **Serialização explícita:** todas as classes implementam seus próprios métodos `toJson` / `fromJson`.

- **Tratamento funcional de erros:** nenhuma exceção é propagada; o resultado é encapsulado em `Result<T>`.

- **Chave única de persistência:** `'checkpoint_data'`.

- **Compatibilidade com sincronização remota:** estrutura pronta para integração futura com API REST.

---

## ✅ Boas Práticas de Uso

1. Sempre salvar o estado após cada etapa:
   
   ```dart
   await repository.saveCheckpointData(currentData);
   ```

2. Ao iniciar o app, recuperar o último estado:
   
   ```dart
   final result = await repository.getCheckpointData();
   ```

3. Em caso de erro, o sistema deve retornar `CheckpointData.empty()` para recomeçar o fluxo.

---

## 🧩 Resumo

| Componente                     | Função Principal                |
| ------------------------------ | ------------------------------- |
| `CheckpointData`               | Estrutura central de progresso. |
| `CheckpointSectionData`        | Metadados de seção.             |
| `BaseCheckpointValues`         | Contrato das seções de valores. |
| `PersonalAccountValues`        | Dados da pessoa física.         |
| `BusinessAccountValues`        | Dados da empresa.               |
| `BusinessPartnersValues`       | Lista de sócios.                |
| `CheckpointDataRepositoryImpl` | Persistência local segura.      |

---

Deseja que eu converta esta versão para **Markdown estruturado (README.md)** com tabelas, blocos de código e índice automático para documentação no GitHub?
