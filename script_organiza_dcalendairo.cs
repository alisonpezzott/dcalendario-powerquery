// Faz a ordenação e organiza as colunas em pastas
var tbcalendario = Model.Tables["dCalendario"];  // Acesse a tabela dCalendario

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
    var textColumn = tbcalendario.Columns[pair.Key];  // Coluna de texto
    var sortColumn = tbcalendario.Columns[pair.Value];  // Coluna numérica correspondente

    // Verifica se ambas as colunas existem e aplica a ordenação
    if (textColumn != null && sortColumn != null)
    {
        textColumn.SortByColumn = sortColumn;  // Ordena a coluna de texto pela coluna numérica
    }
}


// Colocar as colunas de ano na pasta "Ano"
var columnsAno = new[] { "AnoDecrescenteNome", "AnoDecrescenteNum", "AnoFim", "AnoFiscal", "AnoIndice", "AnoInicio", "AnoIsoNum", "AnoNomeAtual", "AnoNum", "AnoOffset" }
;
foreach (var columnName in columnsAno)
{
    var column = tbcalendario.Columns[columnName];
    if (column != null)
    {
        column.DisplayFolder = "Ano"; // Atribue as colunas a pasta
    }
}

// Colocar as colunas na pasta "Fechamento"
var columnsFechamento = new[] { "AnoFechamentoNum", "MesAnoFechamentoNome", "MesAnoFechamentoNum", "MesFechamentoNome", "MesFechamentoNomeAbrev", "MesFechamentoNum" };
foreach (var columnName in columnsFechamento)
{
    var column = tbcalendario.Columns[columnName];
    if (column != null)
    {
        column.DisplayFolder = "Fechamento"; // Atribue as colunas a pasta
    }
}

// Colocar as colunas na pasta "Semana do Mês (Completo)"
var columnsSemanaMesCompleto = new[] { "AnoSemanalNum", "MesAnoSemanalNome", "MesAnoSemanalNum", "MesSemanalNome", "MesSemanalNomeAbrev", "MesSemanalNum", "SemanaDoMesNum" };
foreach (var columnName in columnsSemanaMesCompleto)
{
    var column = tbcalendario.Columns[columnName];
    if (column != null)
    {
        column.DisplayFolder = "Semana do Mês (Completo)"; // Atribue as colunas a pasta
    }
}

// Colocar as colunas na pasta "Bimestre"
var columnsBimestre = new[] { "BimestreAnoNome", "BimestreAnoNomeAtual", "BimestreAnoNum", "BimestreDoAnoNum", "BimestreIndice", "BimestreOffset" };
foreach (var columnName in columnsBimestre)
{
    var column = tbcalendario.Columns[columnName];
    if (column != null)
    {
        column.DisplayFolder = "Bimestre"; // Atribue as colunas a pasta
    }
}

// Colocar as colunas na pasta "Dia"
var columnsDia = new[] { "DataFutura", "DataIndice", "DataNomeAtual", "DataOffset", "DiaDaSemanaNome", "DiaDaSemanaNomeAbrev", "DiaDaSemanaNomeIniciais", "DiaDaSemanaNum", "DiaDoAnoNum", "DiaDoMesNum" };
foreach (var columnName in columnsDia)
{
    var column = tbcalendario.Columns[columnName];
    if (column != null)
    {
        column.DisplayFolder = "Dia"; // Atribue as colunas a pasta
    }
}

// Colocar as colunas na pasta "Dias Úteis / Feriados"
var columnsDiasUteisFeriados = new[] { "DiaUtilDoMes", "DiaUtilNome", "DiaUtilNum", "FeriadoNome" }
;
foreach (var columnName in columnsDiasUteisFeriados)
{
    var column = tbcalendario.Columns[columnName];
    if (column != null)
    {
        column.DisplayFolder = "Dias Úteis / Feriados"; // Atribue as colunas a pasta
    }
}

// Colocar as colunas na pasta "Estações do Ano"
var columnsEstacoes = new[] { "EstacaoAnoNome", "EstacaoAnoNum" };
foreach (var columnName in columnsEstacoes)
{
    var column = tbcalendario.Columns[columnName];
    if (column != null)
    {
        column.DisplayFolder = "Estações do Ano"; // Atribue as colunas a pasta
    }
}

// Colocar as colunas na pasta "Meses"
var columnsMeses = new[] { "MesAnoNome", "MesAnoNomeAtual", "MesAnoNum", "MesDiaNome", "MesDiaNum", "MesFim", "MesIndice", "MesInicio", "MesNome", "MesNomeAbrev", "MesNomeAbrevAtual", "MesNomeAtual", "MesNomeIniciais", "MesNum", "MesOffset" }
;
foreach (var columnName in columnsMeses)
{
    var column = tbcalendario.Columns[columnName];
    if (column != null)
    {
        column.DisplayFolder = "Meses"; // Atribue as colunas a pasta
    }
}

// Colocar as colunas na pasta "Quinzenas"
var columnsQuinzenas = new[] { "QuinzenaDoMesNum", "QuinzenaIndice", "QuinzenaMesAnoNome", "QuinzenaMesAnoNomeAtual", "QuinzenaMesAnoNum", "QuinzenaMesNome", "QuinzenaMesNum", "QuinzenaOffset", "QuinzenaPeriodo" };
foreach (var columnName in columnsQuinzenas)
{
    var column = tbcalendario.Columns[columnName];
    if (column != null)
    {
        column.DisplayFolder = "Quinzenas"; // Atribue as colunas a pasta
    }
}

// Colocar as colunas na pasta "Semana do Ano (Padrão)"
var columnsSemanaAnoPadrao = new[] { "SemanaAnoNome", "SemanaAnoNomeAtual", "SemanaAnoNum", "SemanaFim", "SemanaIndice", "SemanaInicio", "SemanaNum", "SemanaOffset", "SemanaPeriodo" };
;
foreach (var columnName in columnsSemanaAnoPadrao)
{
    var column = tbcalendario.Columns[columnName];
    if (column != null)
    {
        column.DisplayFolder = "Semana do Ano (Padrão)"; // Atribue as colunas a pasta
    }
}

// Colocar as colunas na pasta "Semana do Mês (Padrão)"
var columnsSemanaMesPadrao = new[] { "SemanaDoMesAnoPadraoNome", "SemanaDoMesAnoPadraoNum", "SemanaDoMesPadraoNum" };
;
foreach (var columnName in columnsSemanaMesPadrao)
{
    var column = tbcalendario.Columns[columnName];
    if (column != null)
    {
        column.DisplayFolder = "Semana do Mês (Padrão)"; // Atribue as colunas a pasta
    }
}

// Colocar as colunas na pasta "Semana do Ano (ISO)"
var columnsSemanaAnoIso = new[] { "SemanaIsoAnoNome", "SemanaIsoAnoNomeAtual", "SemanaIsoAnoNum", "SemanaIsoFim", "SemanaIsoIndice", "SemanaIsoInicio", "SemanaIsoNum", "SemanaIsoOffset" };
;
foreach (var columnName in columnsSemanaAnoIso)
{
    var column = tbcalendario.Columns[columnName];
    if (column != null)
    {
        column.DisplayFolder = "Semana do Ano (ISO)"; // Atribue as colunas a pasta
    }
}

// Colocar as colunas na pasta "Semestres"
var columnsSemestres = new[] { "SemestreAnoNome", "SemestreAnoNomeAtual", "SemestreAnoNum", "SemestreDoAnoNum", "SemestreIndice", "SemestreOffset" };
;
foreach (var columnName in columnsSemestres)
{
    var column = tbcalendario.Columns[columnName];
    if (column != null)
    {
        column.DisplayFolder = "Semestres"; // Atribue as colunas a pasta
    }
}

// Colocar as colunas na pasta "Trimestres"
var columnsTrimestres = new[] { "TrimestreAnoNome", "TrimestreAnoNomeAtual", "TrimestreAnoNum", "TrimestreFim", "TrimestreIndice", "TrimestreInicio", "TrimestreNum", "TrimestreOffset" };
;
foreach (var columnName in columnsTrimestres)
{
    var column = tbcalendario.Columns[columnName];
    if (column != null)
    {
        column.DisplayFolder = "Trimestres"; // Atribue as colunas a pasta
    }
}
