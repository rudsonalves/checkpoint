Sempre que for pedido o commit a partir de um diff gerado por:

``` bash
git add .
git diff --cached
```

Proceda com as seguintes regras usando o commitName passado an instrução:

1. Inicie com o título com o formato: `## YYYY/MM/DD commitName - rudsonalves`
2. Todo o texto deve ser feito em inglês.
3. Não use emojis ou linha de separação ('---').
4. Inicie com um texto de introdução do commit com até 200 palavras.
5. Abra se seção '### Modified Files' e adicione como itens:
   - Apresente o path do arquivo em negrito para abrir a itemização
   - para acada alteração no arquivo adicione subitens
6. Se houver novos arqiuvos abra a seção '### New Files' e itemize os seus elementos e descrição.
7. Abra e seção '### Conclusions' e apresente uma breve conclusão do commit.
8. Em todo o processo ignore arquivos autogerados (*.g.dart, ...) nas itemizações.
