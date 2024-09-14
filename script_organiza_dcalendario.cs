// Faz a ordenação e organiza as colunas em pastas
var tb = Model.Tables["dCalendario"];  // Acesse a tabela dCalendario

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
    var textColumn = tb.Columns[pair.Key];  // Coluna de texto
    var sortColumn = tb.Columns[pair.Value];  // Coluna numérica correspondente

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
        var column = tb.Columns[columnName];
        if (column != null)
        {
            column.DisplayFolder = folderName; // Atribue as colunas à pasta correspondente
        }
    }
}

// Desabilitar agregações para todas as colunas da tabela
foreach (var column in tb.Columns)
{
    column.SummarizeBy = AggregateFunction.None;  // Desabilitar agregação
}

// Definir o formato para as colunas do tipo Data
var dateColumns = new[] { "SemanaFim", "SemanaInicio", "AnoFim", "AnoInicio", "Data", "MesFim", "MesInicio", "SemanaIsoFim", "SemanaIsoInicio", "TrimestreFim", "TrimestreInicio" };  // Colunas que contêm datas
foreach (var columnName in dateColumns)
{
    var column = tb.Columns[columnName];
    if (column != null)
    {
        column.FormatString = "Short Date";  // Aplica o formato de data curta
    }
}


