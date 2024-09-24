// Este script realiza as seguintes operações:
// 1. Faz a ordenação das colunas de texto pelas colunas numéricas
// 2. Organiza as colunas em pastas por granularidade
// 3. Aplica o formato short date para colunas do tipo data
// 4. Remove agregações das colunas numéricas
// 5. Marca a tabela como tabela de data

// Acessa a tabela dCalendario
var dcalendario = Model.Tables["dCalendario"];  

// Cria um mapeamento das colunas de texto e suas respectivas colunas numéricas para ordenação
var columnPairs = new Dictionary<string, string>
{
    {"AnoDecrescenteNome", "AnoDecrescenteNum"}, 
    {"AnoNomeAtual", "AnoNum"}, 
    {"BimestreAnoNome", "BimestreAnoNum"}, 
    {"BimestreAnoNomeAtual", "BimestreAnoNum"}, 
    {"DataNomeAtual", "Data"}, 
    {"DiaDaSemanaNome", "DiaDaSemanaNum"}, 
    {"DiaDaSemanaNomeAbrev", "DiaDaSemanaNum"}, 
    {"DiaDaSemanaNomeIniciais", "DiaDaSemanaNum"}, 
    {"DiaUtilNome", "DiaUtilNum"}, 
    {"EstacaoAnoNome", "EstacaoAnoNum"}, 
    {"MesAnoFechamentoNome", "MesAnoFechamentoNum"}, 
    {"MesAnoNome", "MesAnoNum"}, 
    {"MesAnoNomeAtual", "MesAnoNum"}, 
    {"MesAnoSemanalNome", "MesAnoSemanalNum"}, 
    {"MesDiaNome", "MesDiaNum"}, 
    {"MesFechamentoNome", "MesFechamentoNum"}, 
    {"MesFechamentoNomeAbrev", "MesFechamentoNum"}, 
    {"MesNome", "MesNum"}, 
    {"MesNomeAbrev", "MesNum"}, 
    {"MesNomeAbrevAtual", "MesNum"}, 
    {"MesNomeAtual", "MesNum"}, 
    {"MesNomeIniciais", "MesNum"}, 
    {"MesSemanalNome", "MesSemanalNum"}, 
    {"MesSemanalNomeAbrev", "MesSemanalNum"}, 
    {"QuinzenaMesAnoNome", "QuinzenaMesAnoNum"}, 
    {"QuinzenaMesAnoNomeAtual", "QuinzenaMesAnoNum"}, 
    {"QuinzenaMesNome", "QuinzenaMesNum"}, 
    {"QuinzenaPeriodo", "QuinzenaMesAnoNum"}, 
    {"SemanaAnoNome", "SemanaAnoNum"}, 
    {"SemanaAnoNomeAtual", "SemanaAnoNum"}, 
    {"SemanaDoMesAnoPadraoNome", "SemanaDoMesAnoPadraoNum"}, 
    {"SemanaIsoAnoNome", "SemanaIsoAnoNum"}, 
    {"SemanaIsoAnoNomeAtual", "SemanaIsoAnoNum"}, 
    {"SemanaPeriodo", "SemanaIndice"}, 
    {"SemestreAnoNome", "SemestreAnoNum"}, 
    {"SemestreAnoNomeAtual", "SemestreAnoNum"}, 
    {"TrimestreAnoNome", "TrimestreAnoNum"}, 
    {"TrimestreAnoNomeAtual", "TrimestreAnoNum"}
};

// Aplica a ordenação para cada coluna de texto
foreach (var pair in columnPairs)
{
    var textColumn = dcalendario.Columns[pair.Key];  // Coluna de texto
    var sortColumn = dcalendario.Columns[pair.Value];  // Coluna numérica correspondente

    // Verifica se ambas as colunas existem e aplica a ordenação
    if (textColumn != null && sortColumn != null)
    {
        textColumn.SortByColumn = sortColumn;  // Ordena a coluna de texto pela coluna numérica
    }
}

// Dicionário para associar as colunas às pastas correspondentes
var displayFolders = new Dictionary<string, string[]>
{
    { "Ano", new[] { "AnoDecrescenteNome", "AnoDecrescenteNum", "AnoFim", "AnoFiscal", "AnoIndice", "AnoInicio", "AnoIsoNum", "AnoNomeAtual", "AnoNum", "AnoOffset" } },
    { "Fechamento", new[] { "AnoFechamentoNum", "MesAnoFechamentoNome", "MesAnoFechamentoNum", "MesFechamentoNome", "MesFechamentoNomeAbrev", "MesFechamentoNum" } },
    { "Semana do Mês (Completo)", new[] { "AnoSemanalNum", "MesAnoSemanalNome", "MesAnoSemanalNum", "MesSemanalNome", "MesSemanalNomeAbrev", "MesSemanalNum", "SemanaDoMesNum" } },
    { "Bimestre", new[] { "BimestreAnoNome", "BimestreAnoNomeAtual", "BimestreAnoNum", "BimestreDoAnoNum", "BimestreIndice", "BimestreOffset" } },
    { "Dia", new[] { "DataFutura", "DataIndice", "DataNomeAtual", "DataOffset", "DiaDaSemanaNome", "DiaDaSemanaNomeAbrev", "DiaDaSemanaNomeIniciais", "DiaDaSemanaNum", "DiaDoAnoNum", "DiaDoMesNum" } },
    { "Dias Úteis / Feriados", new[] { "DiaUtilDoMes", "DiaUtilNome", "DiaUtilNum", "FeriadoNome" } },
    { "Estações do Ano", new[] { "EstacaoAnoNome", "EstacaoAnoNum" } },
    { "Meses", new[] { "MesAnoNome", "MesAnoNomeAtual", "MesAnoNum", "MesDiaNome", "MesDiaNum", "MesFim", "MesIndice", "MesInicio", "MesNome", "MesNomeAbrev", "MesNomeAbrevAtual", "MesNomeAtual", "MesNomeIniciais", "MesNum", "MesOffset" } },
    { "Quinzenas", new[] { "QuinzenaDoMesNum", "QuinzenaIndice", "QuinzenaMesAnoNome", "QuinzenaMesAnoNomeAtual", "QuinzenaMesAnoNum", "QuinzenaMesNome", "QuinzenaMesNum", "QuinzenaOffset", "QuinzenaPeriodo" } },
    { "Semana do Ano (Padrão)", new[] { "SemanaAnoNome", "SemanaAnoNomeAtual", "SemanaAnoNum", "SemanaFim", "SemanaIndice", "SemanaInicio", "SemanaNum", "SemanaOffset", "SemanaPeriodo" } },
    { "Semana do Mês (Padrão)", new[] { "SemanaDoMesAnoPadraoNome", "SemanaDoMesAnoPadraoNum", "SemanaDoMesPadraoNum" } },
    { "Semana do Ano (ISO)", new[] { "SemanaIsoAnoNome", "SemanaIsoAnoNomeAtual", "SemanaIsoAnoNum", "SemanaIsoFim", "SemanaIsoIndice", "SemanaIsoInicio", "SemanaIsoNum", "SemanaIsoOffset" } },
    { "Semestres", new[] { "SemestreAnoNome", "SemestreAnoNomeAtual", "SemestreAnoNum", "SemestreDoAnoNum", "SemestreIndice", "SemestreOffset" } },
    { "Trimestres", new[] { "TrimestreAnoNome", "TrimestreAnoNomeAtual", "TrimestreAnoNum", "TrimestreFim", "TrimestreIndice", "TrimestreInicio", "TrimestreNum", "TrimestreOffset" } }
};

// Itera sobre as pastas e aplica o DisplayFolder a cada coluna associada
foreach (var folder in displayFolders)
{
    var folderName = folder.Key;
    var columns = folder.Value;

    foreach (var columnName in columns)
    {
        var column = dcalendario.Columns[columnName];
        if (column != null)
        {
            column.DisplayFolder = folderName; // Atribue as colunas à pasta correspondente
        }
    }
}

// Desabilitar agregações para todas as colunas da tabela
foreach (var column in dcalendario.Columns)
{
    column.SummarizeBy = AggregateFunction.None;  // Desabilitar agregação
}

// Definir o formato para as colunas do tipo Data
var dateColumns = new[] { "SemanaFim", "SemanaInicio", "AnoFim", "AnoInicio", "Data", "MesFim", "MesInicio", "SemanaIsoFim", "SemanaIsoInicio", "TrimestreFim", "TrimestreInicio" };  // Colunas que contêm datas
foreach (var columnName in dateColumns)
{
    var column = dcalendario.Columns[columnName];
    if (column != null)
    {
        column.FormatString = "Short Date";  // Aplica o formato de data curta
    }
}

// Marcar como uma tabela de data
dcalendario.DataCategory = "Time";
dcalendario.Columns["Data"].IsKey = true; 




