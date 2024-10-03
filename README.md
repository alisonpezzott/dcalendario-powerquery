# dCalendario (Power Query M)

Essa é a versão oficial em português brasileiro "pt-BR".  
See [here](https://github.com/alisonpezzott/dcalendar-powerquery) for English Version "en-US".  

## Download PBIX pronto
[dcalendario-v6.0.pbix](https://github.com/alisonpezzott/dcalendario-powerquery/releases/tag/v6.0) 

Esta versão já inclui a tabela de [dPeriodos](https://github.com/alisonpezzott/dperiodos-powerquery) 

## Usando o código no Power Query + Script Tabular Editor
1. Copie o código em [dcalendario.pq](dcalendario.pq);
2. No Power Query crie uma nova consulta nula;
3. Abra o editor avançado e cole o código;
4. Ajuste as configurações nas etapas;
5. Renomeie a consulta para dCalendario;
6. Feche e aplique;
7. Clique no menu `Ferramentas Externas`;
8. Abra o [Tabular Editor](https://www.sqlbi.com/tools/tabular-editor) previamente instalado;
9. Vá em `File > Preferences > Features` e habilite `Allow unsupported Power BI features` e clique em `OK`;
10. Copie o código em [dcalendario-tabular-editor.cs](dcalendario-tabular-editor.cs) e cole na janela `C# Script` e clique em `Run` ou pressione `F5`;
11. Depois vá em `File > Save` ou pressione `Ctrl+S`;
12. Pronto, volte para o Power BI e sua tabela dCalendario estará completa, classificada e organizada.

## Usando o código no Power Query + Ordenação Manual
1. Copie o código em [dcalendario.pq](dcalendario.pq);
2. No Power Query crie uma nova consulta nula;
3. Abra o editor avançado e cole o código;
4. Ajuste as configurações nas etapas;
5. Renomeie a consulta para dCalendario;
6. Feche e aplique;
7. Com base no arquivo [dcalendario-ordenacao.xlsx](dcalendario-ordenacao.xlsx) faça a ordenação das colunas, pastas e marque a tabela como data.
