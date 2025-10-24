# Documentação da Classe `CheckpointData`

## Visão Geral
A classe `CheckpointData` representa o estado completo do processo de checkpoint de abertura de conta. Ela gerencia o estágio atual, status de completude e os dados de todas as seções já preenchidas.

---

## Principais Responsabilidades
- **Estágio Atual:** Indica em qual etapa do processo o usuário está.
- **Status de Completude:** Informa se o processo foi finalizado.
- **Dados das Seções:** Armazena os dados preenchidos em cada etapa do fluxo.

---

## Propriedades
- `currentStage`: Estágio atual do processo (`CheckpointStage`).
- `isCompleted`: Indica se o checkpoint foi concluído (`bool`).
- `sections`: Mapeamento dos estágios para seus respectivos dados (`Map<CheckpointStage, CheckpointSectionData>`).

---

## Principais Métodos
- `toMap()`: Serializa os dados para um `Map<String, dynamic>`.
- `fromMap(Map<String, dynamic>)`: Cria uma instância a partir de um mapa.
- `toJson()`: Serializa para JSON.
- `fromJson(String)`: Cria uma instância a partir de uma string JSON.
- `hasSectionData(CheckpointStage)`: Verifica se há dados para um estágio específico.
- `markAsCompleted()`: Marca o checkpoint como concluído.
- `moveToStage(CheckpointStage)`: Move para um estágio específico.
- `copyWith(...)`: Cria uma cópia alterando campos específicos.

---

## Extensões
### `CheckpointDataExtensions`
- Getters para acessar dados específicos das seções:
  - `personalAccountValues`: Dados da conta pessoal.
  - `businessAccountValues`: Dados da conta empresarial.
  - `businessPartnersValues`: Lista de sócios empresariais.
  - `businessPartnersCollection`: Coleção completa de sócios.

### `CheckpointDataUpdateExtensions`
- Métodos para atualizar campos específicos das seções:
  - `updatePersonalAccount(...)`: Atualiza dados da conta pessoal.
  - `updateBusinessAccount(...)`: Atualiza dados da conta empresarial.
  - `addBusinessPartner(BusinessPartnerData)`: Adiciona um sócio empresarial.
  - `removeBusinessPartner(int)`: Remove um sócio pelo índice.
  - `updateBusinessPartner(int, BusinessPartnerData)`: Atualiza um sócio pelo índice.
  - `updateBusinessPartnerFields(...)`: Atualiza campos específicos de um sócio.

---

## Padrão de Imutabilidade
A classe utiliza o padrão `copyWith` para garantir que as alterações gerem novas instâncias, mantendo a imutabilidade dos dados.

---

## Exemplo de Uso
```dart
final checkpoint = CheckpointData.empty()
  .updatePersonalAccount(name: 'João', cpf: '123.456.789-00')
  .moveToStage(CheckpointStage.createBusinessAccount);
```

---

## Observações
- O fluxo de estágios é definido na lógica interna e pode ser customizado conforme necessidade.
- As extensões facilitam o acesso e atualização dos dados sem expor detalhes internos da estrutura.

---

## Referências
- [checkpoint_enum.dart](../../lib/domain/enums/checkpoint_enum.dart)
- [checkpoint_section_data.dart](../../lib/domain/entities/checkpoint/checkpoint_section_data.dart)
- [business_account_values.dart](../../lib/domain/entities/checkpoint/checkpoint_values/business_account_values.dart)
- [business_partners_values.dart](../../lib/domain/entities/checkpoint/checkpoint_values/business_partners_values.dart)
- [personal_account_values.dart](../../lib/domain/entities/checkpoint/checkpoint_values/personal_account_values.dart)
