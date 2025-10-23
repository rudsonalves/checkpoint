import '../lib/domain/entities/checkpoint/checkpoint_data.dart';
import '../lib/domain/entities/checkpoint/checkpoint_values/business_partners_values.dart';

/// Exemplo demonstrando o uso de múltiplos sócios empresariais.
void main() {
  print('🚀 Demonstração: Múltiplos Sócios Empresariais\n');

  // Inicializar checkpoint vazio
  var checkpoint = CheckpointData.empty();
  print(
    '📋 Checkpoint iniciado: ${checkpoint.businessPartnersValues.length} sócios',
  );

  // Adicionar primeiro sócio
  final socio1 = BusinessPartnerData(
    companyId: 'EMP001',
    fullName: 'João Silva',
    email: 'joao.silva@empresa.com',
    isPoliticallyExposed: false,
    zipCode: '01234-567',
    state: 'SP',
    city: 'São Paulo',
    district: 'Centro',
    street: 'Rua das Flores',
    number: '123',
    complement: 'Sala 45',
  );

  checkpoint = checkpoint.addBusinessPartner(socio1);
  print(
    '✅ Primeiro sócio adicionado: ${checkpoint.businessPartnersValues.length} sócios',
  );

  // Adicionar segundo sócio
  final socio2 = BusinessPartnerData(
    companyId: 'EMP002',
    fullName: 'Maria Santos',
    email: 'maria.santos@empresa.com',
    isPoliticallyExposed: true,
    zipCode: '04567-890',
    state: 'RJ',
    city: 'Rio de Janeiro',
    district: 'Copacabana',
    street: 'Av. Atlântica',
    number: '1000',
  );

  checkpoint = checkpoint.addBusinessPartner(socio2);
  print(
    '✅ Segundo sócio adicionado: ${checkpoint.businessPartnersValues.length} sócios',
  );

  // Adicionar terceiro sócio
  final socio3 = BusinessPartnerData(
    fullName: 'Carlos Oliveira',
    email: 'carlos.oliveira@empresa.com',
    isPoliticallyExposed: false,
  );

  checkpoint = checkpoint.addBusinessPartner(socio3);
  print(
    '✅ Terceiro sócio adicionado: ${checkpoint.businessPartnersValues.length} sócios',
  );

  // Listar todos os sócios
  print('\n📋 Lista de Sócios:');
  final socios = checkpoint.businessPartnersValues;
  for (int i = 0; i < socios.length; i++) {
    final socio = socios[i];
    print('${i + 1}. ${socio.fullName} (${socio.email})');
    print('   PEP: ${socio.isPoliticallyExposed ?? false ? "Sim" : "Não"}');
    if (socio.city != null) {
      print('   Local: ${socio.city}, ${socio.state}');
    }
    print('');
  }

  // Atualizar dados do primeiro sócio
  checkpoint = checkpoint.updateBusinessPartnerFields(
    0,
    email: 'joao.silva.novo@empresa.com',
    city: 'Campinas',
  );
  print('🔄 Dados do primeiro sócio atualizados');

  // Verificar alteração
  final socioAtualizado = checkpoint.businessPartnersValues[0];
  print('   Novo email: ${socioAtualizado.email}');
  print('   Nova cidade: ${socioAtualizado.city}');

  // Remover o segundo sócio (índice 1)
  checkpoint = checkpoint.removeBusinessPartner(1);
  print(
    '\n❌ Segundo sócio removido: ${checkpoint.businessPartnersValues.length} sócios restantes',
  );

  // Lista final
  print('\n📋 Lista Final de Sócios:');
  final sociosFinais = checkpoint.businessPartnersValues;
  for (int i = 0; i < sociosFinais.length; i++) {
    final socio = sociosFinais[i];
    print('${i + 1}. ${socio.fullName} (${socio.email})');
  }

  // Testar serialização
  final json = checkpoint.toJson();
  final checkpointFromJson = CheckpointData.fromJson(json);
  final sociosDeserializados = checkpointFromJson.businessPartnersValues;

  print('\n🔄 Teste de Serialização:');
  print('Sócios antes: ${sociosFinais.length}');
  print('Sócios depois: ${sociosDeserializados.length}');
  print(
    'Serialização funcionou: ${sociosFinais.length == sociosDeserializados.length}',
  );

  print('\n✅ Demonstração concluída com sucesso!');
}
