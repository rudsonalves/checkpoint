# Checkpoint - Sistema de Gestão de Dados de Abertura de Conta

[![Dart](https://img.shields.io/badge/Dart-3.9.2+-0175C2.svg)](https://dart.dev/)
[![License](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE)
[![Tests](https://img.shields.io/badge/tests-passing-brightgreen.svg)](test/)

Um sistema robusto e flexível para gerenciar dados de checkpoint durante o processo de abertura de contas, com suporte a persistência segura, cache em memória e atualizações granulares.

## 📋 Índice

- [Visão Geral](#-visão-geral)
- [Características](#-características)  
- [Instalação](#-instalação)
- [Uso Rápido](#-uso-rápido)
- [Arquitetura](#-arquitetura)
- [API Reference](#-api-reference)
- [Exemplos](#-exemplos)
- [Contribuindo](#-contribuindo)

## 🎯 Visão Geral

O **Checkpoint** é uma biblioteca Dart que facilita o gerenciamento de dados durante processos de abertura de contas multi-etapas. Ele oferece uma API limpa e type-safe para:

- **Gerenciar fluxos multi-etapas** de coleta de dados
- **Persistir dados com segurança** usando secure storage
- **Cache inteligente em memória** para acesso rápido
- **Atualizações granulares** sem recriar objetos inteiros
- **Serialização/Deserialização automática** JSON

### Fluxo de Checkpoint Suportado

```
noExistAccount → createPersonalAccount → createBusinessAccount → registerBusinessPartners
```

## ✨ Características

### 🏗️ Arquitetura Limpa
- **Domain-Driven Design** com separação clara de responsabilidades
- **Repository Pattern** para abstração de persistência
- **Result Pattern** para tratamento robusto de erros

### 🔒 Type Safety
- **Sealed classes** para garantia de completude em tempo de compilação
- **Generics** para acesso type-safe às seções
- **Immutable objects** com método copyWith

### 💾 Persistência Inteligente
- **Cache em memória** para acesso instantâneo
- **Secure storage** para persistência segura
- **Serialização automática** para JSON

### 🛠️ Facilidade de Uso  
- **Extensions** para acesso simplificado aos dados
- **Métodos de conveniência** para operações comuns
- **API fluente** para composição de operações

## 🚀 Instalação

Adicione ao seu `pubspec.yaml`:

```yaml
dependencies:
  checkpoint: ^1.0.0
  equatable: ^2.0.7
  result_dart: ^2.1.1
```

Execute:
```bash
dart pub get
```

## ⚡ Uso Rápido

### 1. Configuração Básica

```dart
import 'package:checkpoint/checkpoint.dart';

// Configurar storage seguro (implementação própria)
final secureStorage = YourSecureStorageImpl();
final repository = CheckpointDataRepositoryImpl(secureStorage);

// Carregar dados existentes
await repository.loadCheckpointData();
```

### 2. Adicionando Dados por Seção

```dart
// Dados pessoais
final personalData = PersonalAccountValues(
  name: 'João Silva',
  cpf: '12345678901',
  email: 'joao@email.com',
  phone: '11999999999',
  // ... outros campos
);

await repository.updateSection(
  stage: CheckpointStage.createPersonalAccount,
  sectionData: CheckpointSection(values: personalData),
);
```

### 3. Atualizações Granulares

```dart
// Obter dados atuais e aplicar alterações usando extensions
final currentData = repository.currentCheckpointData;

// Atualizar apenas email e telefone usando copyWith
final updatedData = currentData.updatePersonalContactInfo(
  email: 'novo@email.com',
  phone: '11888888888',
);

// Salvar as alterações
await repository.saveCheckpointData(updatedData);

// Atualizar campos específicos
final dataWithUpdates = currentData.updatePersonalAccount(
  name: 'João Santos Silva',
  rgNumber: '123456789',
);

await repository.saveCheckpointData(dataWithUpdates);
```

### 4. Acessando Dados

```dart
// Via repository
final currentData = repository.currentCheckpointData;

// Via getters convenientes (extension)
final personalValues = currentData.personalAccountValues;
final businessValues = currentData.businessAccountValues;
final partnersValues = currentData.businessPartnersValues;

// Verificar se seção existe
if (repository.hasSectionData(CheckpointStage.createPersonalAccount)) {
  print('Dados pessoais já foram preenchidos');
}
```

## 🏛️ Arquitetura

### Estrutura de Pastas

```
lib/
├── src/
│   ├── domain/
│   │   ├── entities/checkpoint/          # Entidades do domínio
│   │   │   ├── checkpoint_data.dart      # Classe principal
│   │   │   ├── checkpoint_section_data.dart
│   │   │   └── checkpoint_values/        # Classes de valores
│   │   ├── enum/                         # Enumerações
│   │   └── repositories/                 # Interfaces de repositório
│   ├── repository/                       # Implementações concretas
│   └── core/
│       └── services/                     # Serviços compartilhados
└── checkpoint.dart                       # Export público
```

### Classes Principais

#### `CheckpointData`
Classe principal que gerencia o estado completo do checkpoint:

```dart
class CheckpointData extends Equatable {
  final CheckpointStage currentStage;
  final bool isCompleted;
  final Map<CheckpointStage, CheckpointSectionData> sections;
  
  // Métodos: copyWith, toJson, fromJson, withSection...
}
```

#### `CheckpointSectionData` (Sealed Class)
Interface para dados de seções específicas:

```dart
sealed class CheckpointSectionData extends Equatable {
  // Implementações: CheckpointSection<T>, EmptySection
}
```

#### Classes de Valores
- `PersonalAccountValues` - Dados de conta pessoal
- `BusinessAccountValues` - Dados de conta empresarial  
- `BusinessPartnersValues` - Dados de sócios empresariais

Todas estendem `BaseCheckpointValues` e incluem:
- Método `copyWith` para atualizações imutáveis
- Serialização/Deserialização automática
- Implementação de `Equatable`

## 📚 API Reference

### CheckpointDataRepository

Interface principal para operações de persistência:

```dart
abstract interface class CheckpointDataRepository {
  // Propriedades
  CheckpointData get currentCheckpointData;
  
  // Operações básicas
  AsyncResult<CheckpointData> loadCheckpointData();
  AsyncResult<Unit> saveCheckpointData(CheckpointData data);
  AsyncResult<Unit> clearCheckpointData();
  
  // Manipulação de seções
  AsyncResult<CheckpointData> updateSection({
    required CheckpointStage stage,
    required CheckpointSectionData sectionData,
    CheckpointStage? nextStage,
  });
  
  // Navegação
  AsyncResult<CheckpointData> moveToNextStage(CheckpointStage nextStage);
  AsyncResult<CheckpointData> completeCheckpoint();
  
  // Acesso aos dados
  T? getSectionData<T extends CheckpointSectionData>(CheckpointStage stage);
  bool hasSectionData(CheckpointStage stage);
}
```

### Extensions

#### `CheckpointDataExtensions`
Getters convenientes para acesso aos dados:

```dart
extension CheckpointDataExtensions on CheckpointData {
  PersonalAccountValues? get personalAccountValues;
  BusinessAccountValues? get businessAccountValues;
  List<BusinessPartnersValues> get businessPartnersValues;
}
```

#### `CheckpointDataUpdateExtensions`  
Métodos para atualizações granulares usando `copyWith`:

```dart
extension CheckpointDataUpdateExtensions on CheckpointData {
  CheckpointData updatePersonalAccount({/* campos opcionais */});
  CheckpointData updateBusinessAccount({/* campos opcionais */});
  CheckpointData updateBusinessPartner({/* campos opcionais */});
  
  // Métodos de conveniência
  CheckpointData updatePersonalContactInfo({String? email, String? phone});
  CheckpointData updateBusinessContactInfo({String? email, String? phone});
  CheckpointData updateBusinessAddress({/* campos de endereço */});
  CheckpointData updatePersonalRgInfo({/* campos do RG */});
}
```

## 💡 Exemplos

### Exemplo Completo: Fluxo de Abertura de Conta

```dart
import 'package:checkpoint/checkpoint.dart';

Future<void> exemploCompleto() async {
  // 1. Configuração
  final repository = CheckpointDataRepositoryImpl(secureStorage);
  await repository.loadCheckpointData();
  
  // 2. Etapa 1 - Dados Pessoais
  final personalData = PersonalAccountValues(
    name: 'Maria Silva',
    cpf: '12345678901',
    email: 'maria@email.com',
    phone: '11999999999',
    password: 'senhaSegura123',
    rgNumber: '123456789',
    rgIssuer: 'SSP',
    rgIssuerStateId: 'SP',
    rgIssuerStateAbbreviation: 'SP',
    rgIssueDate: DateTime(2020, 1, 1),
  );
  
  var result = await repository.updateSection(
    stage: CheckpointStage.createPersonalAccount,
    sectionData: CheckpointSection(values: personalData),
  );
  
  result.fold(
    (error) => print('Erro: $error'),
    (checkpoint) => print('Pessoal salvo! Estágio: ${checkpoint.currentStage}'),
  );
  
  // 3. Etapa 2 - Dados Empresariais  
  final businessData = BusinessAccountValues(
    cnpj: '12345678000190',
    municipalRegistration: '123456',
    legalName: 'Empresa Exemplo LTDA',
    tradeName: 'Empresa Exemplo',
    phone: '1133334444',
    revenueOptionId: 'simples_nacional',
    zipCode: '01234567',
    state: 'SP',
    city: 'São Paulo',
    neighborhood: 'Centro',
    streetAddress: 'Rua das Flores, 123',
    number: '123',
    complement: 'Sala 456',
    addressStartDate: DateTime.now(),
    email: 'contato@empresa.com',
    openingDate: '2020-01-01',
  );
  
  result = await repository.updateSection(
    stage: CheckpointStage.createBusinessAccount,
    sectionData: CheckpointSection(values: businessData),
  );
  
  // 4. Etapa 3 - Sócios
  final partnerData = BusinessPartnersValues(
    companyId: 'empresa123',
    fullName: 'João Santos',
    email: 'joao@empresa.com',
    isPoliticallyExposed: false,
    zipCode: '01234567',
    state: 'SP',
    city: 'São Paulo',
    district: 'Vila Madalena',
    street: 'Rua dos Pinheiros',
    number: '456',
    complement: 'Apt 789',
  );
  
  result = await repository.updateSection(
    stage: CheckpointStage.registerBusinessPartners,
    sectionData: CheckpointSection(values: partnerData),
  );
  
  // 5. Finalizar processo
  final completeResult = await repository.completeCheckpoint();
  
  completeResult.fold(
    (error) => print('Erro ao completar: $error'),
    (checkpoint) => print('Checkpoint completo! ✅'),
  );
}
```

### Exemplo: Atualizações Dinâmicas

```dart
Future<void> atualizacoesDinamicas() async {
  final repository = CheckpointDataRepositoryImpl(secureStorage);
  
  // Carregar dados existentes
  await repository.loadCheckpointData();
  
  // Obter dados atuais
  var currentData = repository.currentCheckpointData;
  
  // Atualizar apenas email pessoal usando extension
  currentData = currentData.updatePersonalContactInfo(
    email: 'novo.email@exemplo.com',
  );
  
  // Atualizar endereço empresarial usando extension
  currentData = currentData.updateBusinessAddress(
    zipCode: '04567890',
    city: 'Rio de Janeiro',
    state: 'RJ',
    neighborhood: 'Copacabana',
    streetAddress: 'Av. Atlântica, 1000',
  );
  
  // Salvar todas as alterações
  await repository.saveCheckpointData(updatedData);
  
  // Verificar dados atuais
  final verifyData = repository.currentCheckpointData;
  
  if (verifyData.personalAccountValues != null) {
    print('Email atual: ${verifyData.personalAccountValues!.email}');
  }
  
  // Combinar múltiplas atualizações
  final checkpoint = repository.currentCheckpointData
      .updatePersonalContactInfo(phone: '11988887777')
      .updateBusinessContactInfo(email: 'suporte@empresa.com');
  
  // Salvar mudanças combinadas  
  await repository.saveCheckpointData(checkpoint);
}
```

### Exemplo: Validação e Fluxo Condicional

```dart
Future<void> fluxoComValidacao() async {
  final repository = CheckpointDataRepositoryImpl(secureStorage);
  
  // Verificar estado atual
  final current = repository.currentCheckpointData;
  
  switch (current.currentStage) {
    case CheckpointStage.noExistAccount:
      print('Iniciando processo de abertura de conta');
      break;
      
    case CheckpointStage.createPersonalAccount:
      if (repository.hasSectionData(CheckpointStage.createPersonalAccount)) {
        print('Dados pessoais já preenchidos, avançando...');
        await repository.moveToNextStage(CheckpointStage.createBusinessAccount);
      }
      break;
      
    case CheckpointStage.createBusinessAccount:
      // Lógica para dados empresariais
      break;
      
    case CheckpointStage.registerBusinessPartners:
      // Lógica para sócios
      break;
  }
  
  // Verificar completude
  if (current.isCompleted) {
    print('Processo já finalizado! ✅');
    return;
  }
  
  // Verificar quais seções estão preenchidas
  final sectionsStatus = {
    'Pessoal': repository.hasSectionData(CheckpointStage.createPersonalAccount),
    'Empresarial': repository.hasSectionData(CheckpointStage.createBusinessAccount),
    'Sócios': repository.hasSectionData(CheckpointStage.registerBusinessPartners),
  };
  
  print('Status das seções: $sectionsStatus');
}
```

## 🧪 Testes

Execute os testes:

```bash
dart test
```

Para executar com cobertura:

```bash
dart test --coverage=coverage
dart pub global activate coverage
dart pub global run coverage:format_coverage --lcov --in=coverage --out=coverage/lcov.info --report-on=lib
```

## 🤝 Contribuindo

1. Fork o projeto
2. Crie uma branch para sua feature (`git checkout -b feature/AmazingFeature`)
3. Commit suas mudanças (`git commit -m 'Add some AmazingFeature'`)
4. Push para a branch (`git push origin feature/AmazingFeature`)
5. Abra um Pull Request

### Guidelines de Desenvolvimento

- Siga as convenções de código Dart
- Adicione testes para novas funcionalidades
- Mantenha a cobertura de testes acima de 80%
- Documente APIs públicas
- Use conventional commits

## 📄 Licença

Este projeto está licenciado sob a MIT License - veja o arquivo [LICENSE](LICENSE) para detalhes.

## 📞 Suporte

- **Issues**: [GitHub Issues](https://github.com/rudsonalves/checkpoint/issues)
- **Discussões**: [GitHub Discussions](https://github.com/rudsonalves/checkpoint/discussions)
- **Email**: rudsonalves@exemplo.com

---

**Desenvolvido com ❤️ em Dart**