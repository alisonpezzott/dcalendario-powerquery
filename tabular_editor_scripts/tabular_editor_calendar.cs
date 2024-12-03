// This script performs the following operations:
// 1. Sorts text columns by their corresponding numeric columns
// 2. Organizes columns into folders by granularity
// 3. Applies the short date format to date-type columns
// 4. Removes aggregations from numeric columns
// 5. Marks the table as a date table

// Define the language. Available: pt-BR, en-Us, es-ES
var language = "en-US";

// Access the table
var calendar_table = Model.Tables["Calendar"];

if (language == "en-US")
{
    // Create a mapping of text columns and their respective numeric columns for sorting
    var columnPairs = new Dictionary<string, string>
    {
        {"CurrentDate", "Date"},
        {"YearDescendingName", "YearDescendingNumber"},
        {"CurrentYear", "Year"},
        {"DayOfWeekName", "DayOfWeekNumber"},
        {"DayOfWeekNameShort", "DayOfWeekNumber"},
        {"MonthName", "MonthNumber"},
        {"MonthNameShort", "MonthNumber"},
        {"MonthYearName", "MonthYearNumber"},
        {"MonthDayName", "MonthDayNumber"},
        {"CurrentMonthName", "MonthNumber"},
        {"CurrentMonthNameShort", "MonthNumber"},
        {"CurrentMonthYearName", "MonthYearNumber"},
        {"QuarterName", "QuarterNumber"},
        {"QuarterYearName", "QuarterYearNumber"},
        {"CurrentQuarter", "QuarterNumber"},
        {"CurrentQuarterYear", "QuarterYearNumber"},
        {"WeekYearNameISO", "WeekYearNumberISO"},
        {"CurrentWeekISO", "WeekYearNumberISO"},
        {"WeekPeriodName", "WeekYearNumberISO"},
        {"HalfYearName", "HalfYearNumber"},
        {"CurrentHalf", "HalfYearNumber"},
        {"BimesterYearName", "BimesterYearNumber"},
        {"CurrentBimester", "BimesterYearNumber"},
        {"FortnightMonthName", "FortnightMonthNumber"},
        {"FortnightMonthYearName", "FortnightMonthYearNumber"},
        {"CurrentFortnight", "FortnightMonthYearNumber"},
        {"ClosingMonthName", "ClosingMonthNumber"},
        {"ClosingMonthNameShort", "ClosingMonthNumber"},
        {"ClosingMonthYearName", "ClosingMonthYearNumber"},
        {"SeasonNorthName", "SeasonNorthNumber"},
        {"SeasonSouthName", "SeasonSouthNumber"},
        {"CurrentFiscalYear", "FiscalYear"},
        {"FiscalMonthName", "FiscalMonthNumber"},
        {"FiscalMonthNameShort", "FiscalMonthNumber"},
        {"CurrentFiscalMonth", "FiscalMonthNumber"},
        {"FiscalYearMonthName", "FiscalYearMonthNumber"},
        {"FiscalYearMonthCurrent", "FiscalYearMonthNumber"},
        {"FiscalQuarterName", "FiscalQuarterNumber"},
        {"FiscalYearQuarterName", "FiscalYearQuarterNumber"},
        {"CurrentFiscalQuarter", "FiscalYearQuarterNumber"}
    };

    // Apply sorting for each text column
    foreach (var pair in columnPairs)
    {
        var textColumn = calendar_table.Columns[pair.Key];  // Text column
        var sortColumn = calendar_table.Columns[pair.Value];  // Corresponding numeric column

        // Check if both columns exist and apply sorting
        if (textColumn != null && sortColumn != null)
        {
            textColumn.SortByColumn = sortColumn;  // Sort text column by numeric column
        }
    }

    // Dictionary to associate columns with their respective folders
    var displayFolders = new Dictionary<string, string[]>
    {
        { "Bimester", new[] { "BimesterIndex", "BimesterNumber", "BimestersToToday", "BimesterYearName", "BimesterYearNumber", "CurrentBimester"} },
        { "BusinessDays_Holidays", new[] { "BusinessDayName", "BusinessDayNumber", "Holiday"} },
        { "Closing", new[] { "ClosingDateRef", "ClosingMonthName", "ClosingMonthNameShort", "ClosingMonthNumber", "ClosingMonthYearName", "ClosingMonthYearNumber", "ClosingYear"} },
        { "Date", new[] { "CurrentDate", "DateIndex", "DaysToToday"} },
        { "Day", new[] { "DayOfMonth", "DayOfWeekName", "DayOfWeekNameInitials", "DayOfWeekNameShort", "DayOfWeekNumber", "DayOfYear"} },
        { "FiscalMonth", new[] { "CurrentFiscalMonth", "FiscalMonthName", "FiscalMonthNameShort", "FiscalMonthNumber", "FiscalMonthsToToday", "FiscalYearMonthCurrent", "FiscalYearMonthName", "FiscalYearMonthNumber"} },
        { "FiscalQuarter", new[] { "CurrentFiscalQuarter", "DayOfFiscalQuarter", "FiscalMonthOfQuarterNumber", "FiscalQuarterEnd", "FiscalQuarterName", "FiscalQuarterNumber", "FiscalQuarterStart", "FiscalQuartersToToday", "FiscalYearQuarterName", "FiscalYearQuarterNumber"} },
        { "FiscalYear", new[] { "CurrentFiscalYear", "FiscalYear", "FiscalYearEnd", "FiscalYearEndNumber", "FiscalYearStart", "FiscalYearStartNumber", "FiscalYearsToToday"} },
        { "Fortnight", new[] { "CurrentFortnight", "FortnightIndex", "FortnightMonthName", "FortnightMonthNumber", "FortnightMonthYearName", "FortnightMonthYearNumber", "FortnightOfMonthNumber", "FortnightsToToday"} },
        { "Half", new[] { "CurrentHalf", "HalfIndex", "HalfNumber", "HalfsToToday", "HalfYearName", "HalfYearNumber"} },
        { "Month", new[] { "CurrentMonthName", "CurrentMonthNameShort", "CurrentMonthYearName", "MonthDayName", "MonthDayNumber", "MonthEnd", "MonthIndex", "MonthName", "MonthNameInitials", "MonthNameShort", "MonthNumber", "MonthOfQuarterNumber", "MonthStart", "MonthsToToday", "MonthYearName", "MonthYearNumber"} },
        { "Quarter", new[] { "CurrentQuarter", "CurrentQuarterYear", "QuarterEnd", "QuarterIndex", "QuarterName", "QuarterNumber", "QuarterStart", "QuartersToToday", "QuarterYearName", "QuarterYearNumber"} },
        { "Season", new[] { "SeasonNorthName", "SeasonNorthNumber", "SeasonSouthName", "SeasonSouthNumber"} },
        { "Week", new[] { "CurrentWeekISO", "WeekEndISO", "WeekIndexISO", "WeekOfMonthNumber", "WeekOfYearNumberISO", "WeekPeriodName", "WeekStartISO", "WeeksToTodayISO", "WeekYearNameISO", "WeekYearNumberISO", "YearISO"} },
        { "Year", new[] { "CurrentYear", "Year", "YearDescendingName", "YearDescendingNumber", "YearEnd", "YearIndex", "YearStart", "YearsToToday"} }
    };


    // Iterate through the folders and apply the DisplayFolder to each associated column
    foreach (var folder in displayFolders)
    {
        var folderName = folder.Key;
        var columns = folder.Value;

        foreach (var columnName in columns)
        {
            var column = calendar_table.Columns[columnName];
            if (column != null)
            {
                column.DisplayFolder = folderName; // Assign columns to the corresponding folder
            }
        }
    }

    // Disable aggregations for all columns in the table
    foreach (var column in calendar_table.Columns)
    {
        column.SummarizeBy = AggregateFunction.None;  // Disable aggregation
    }

    // Set the format for date-type columns
    var dateColumns = new[] { "ClosingDateRef", "Date", "FiscalQuarterEnd", "FiscalQuarterStart", "FiscalYearEnd", "FiscalYearStart", "MonthEnd", "MonthStart", "QuarterEnd", "QuarterStart", "WeekEndISO", "WeekStartISO", "YearEnd", "YearStart" };  // Columns containing dates
    foreach (var columnName in dateColumns)
    {
        var column = calendar_table.Columns[columnName];
        if (column != null)
        {
            column.FormatString = "Short Date";  // Apply short date format
        }
    }

    // Mark as a date table
    calendar_table.DataCategory = "Time";
    calendar_table.Columns["Date"].IsKey = true;
};

if (language == "pt-BR")
{
    // Create a mapping of text columns and their respective numeric columns for sorting
    var columnPairs = new Dictionary<string, string>
    {
        {"DataAtual", "Data"},
        {"AnoDecrescenteNome", "AnoDecrescenteNumero"},
        {"AnoAtual", "Ano"},
        {"DiaDaSemanaNome", "DiaDaSemanaNumero"},
        {"DiaDaSemanaNomeAbreviado", "DiaDaSemanaNumero"},
        {"MesNome", "MesNumero"},
        {"MesNomeAbreviado", "MesNumero"},
        {"MesAnoNome", "MesAnoNumero"},
        {"MesDiaNome", "MesDiaNumero"},
        {"MesAtualNome", "MesNumero"},
        {"MesAtualNomeAbreviado", "MesNumero"},
        {"MesAnoAtualNome", "MesAnoNumero"},
        {"TrimestreNome", "TrimestreNumero"},
        {"TrimestreAnoNome", "TrimestreAnoNumero"},
        {"TrimestreAtual", "TrimestreNumero"},
        {"TrimestreAnoAtual", "TrimestreAnoNumero"},
        {"SemanaAnoNomeISO", "SemanaAnoNumeroISO"},
        {"SemanaAtualISO", "SemanaAnoNumeroISO"},
        {"SemanaPeriodoNome", "SemanaAnoNumeroISO"},
        {"SemestreAnoNome", "SemestreAnoNumero"},
        {"SemestreAtual", "SemestreAnoNumero"},
        {"BimestreAnoNome", "BimestreAnoNumero"},
        {"BimestreAtual", "BimestreAnoNumero"},
        {"QuinzenaMesNome", "QuinzenaMesNumero"},
        {"QuinzenaMesAnoNome", "QuinzenaMesAnoNumero"},
        {"QuinzenaAtual", "QuinzenaMesAnoNumero"},
        {"MesFechamentoNome", "MesFechamentoNumero"},
        {"MesFechamentoNomeAbreviado", "MesFechamentoNumero"},
        {"MesAnoFechamentoNome", "MesAnoFechamentoNumero"},
        {"EstacaoNorteNome", "EstacaoNorteNumero"},
        {"EstacaoSulNome", "EstacaoSulNumero"},
        {"AnoFiscalAtual", "AnoFiscal"},
        {"MesFiscalNome", "MesFiscalNumero"},
        {"MesFiscalNomeAbreviado", "MesFiscalNumero"},
        {"MesFiscalAtual", "MesFiscalNumero"},
        {"MesAnoFiscalNome", "MesAnoFiscalNumero"},
        {"MesAnoFiscalAtual", "MesAnoFiscalNumero"},
        {"TrimestreFiscalNome", "TrimestreFiscalNumero"},
        {"AnoTrimestreFiscalNome", "AnoTrimestreFiscalNumero"},
        {"TrimestreFiscalAtual", "AnoTrimestreFiscalNumero"}
    };

    // Apply sorting for each text column
    foreach (var pair in columnPairs)
    {
        var textColumn = calendar_table.Columns[pair.Key];  // Text column
        var sortColumn = calendar_table.Columns[pair.Value];  // Corresponding numeric column

        // Check if both columns exist and apply sorting
        if (textColumn != null && sortColumn != null)
        {
            textColumn.SortByColumn = sortColumn;  // Sort text column by numeric column
        }
    }

    // Dictionary to associate columns with their respective folders
    var displayFolders = new Dictionary<string, string[]>
    {
        { "Ano", new[] { "Ano", "AnoInicio", "AnoFim", "AnoIndice", "AnoDecrescenteNome", "AnoDecrescenteNumero", "AnosParaHoje", "AnoAtual"} },
        { "AnoFiscal", new[] { "AnoFiscalInicialNumero", "AnoFiscalFinalNumero", "AnoFiscal", "AnoFiscalInicio", "AnoFiscalFim", "AnoFiscalAtual", "AnosFiscaisParaHoje", "MesFiscalNumero", "MesFiscalNome", "MesFiscalNomeAbreviado", "MesFiscalAtual", "MesAnoFiscalNome", "MesAnoFiscalNumero", "MesAnoFiscalAtual", "MesesFiscaisParaHoje"} },
        { "Bimestre", new[] { "BimestreNumero", "BimestreAnoNome", "BimestreAnoNumero", "BimestreIndice", "BimestresParaHoje", "BimestreAtual"} },
        { "Data", new[] { "DataIndice", "DiasParaHoje", "DataAtual"} },
        { "Dia", new[] { "DiaDoMes", "DiaDoAno", "DiaDaSemanaNumero", "DiaDaSemanaNome", "DiaDaSemanaNomeAbreviado", "DiaDaSemanaNomeIniciais"} },
        { "DiasUteis_Feriados", new[] { "Feriado", "DiaUtilNumero", "DiaUtilNome"} },
        { "Estacao", new[] { "EstacaoNorteNumero", "EstacaoNorteNome", "EstacaoSulNumero", "EstacaoSulNome"} },
        { "Fechamento", new[] { "DataDeFechamentoRef", "AnoFechamento", "MesFechamentoNome", "MesFechamentoNomeAbreviado", "MesFechamentoNumero", "MesAnoFechamentoNome", "MesAnoFechamentoNumero"} },
        { "Mes", new[] { "MesNumero", "MesNome", "MesNomeAbreviado", "MesNomeIniciais", "MesAnoNome", "MesAnoNumero", "MesDiaNumero", "MesDiaNome", "MesInicio", "MesFim", "MesIndice", "MesesParaHoje", "MesAtualNome", "MesAtualNomeAbreviado", "MesAnoAtualNome", "MesDoTrimestreNumero"} },
        { "Quinzena", new[] { "QuinzenaDoMesNumero", "QuinzenaMesNumero", "QuinzenaMesNome", "QuinzenaMesAnoNumero", "QuinzenaMesAnoNome", "QuinzenaIndice", "QuinzenasParaHoje", "QuinzenaAtual"} },
        { "Semana", new[] { "SemanaDoAnoNumeroISO", "AnoISO", "SemanaAnoNumeroISO", "SemanaAnoNomeISO", "SemanaInicioISO", "SemanaFimISO", "SemanaIndiceISO", "SemanasParaHojeISO", "SemanaAtualISO", "SemanaPeriodoNome", "SemanaDoMesNumero"} },
        { "Semestre", new[] { "SemestreNumero", "SemestreAnoNome", "SemestreAnoNumero", "SemestreIndice", "SemestresParaHoje", "SemestreAtual"} },
        { "Trimestre", new[] { "TrimestreNumero", "TrimestreNome", "TrimestreAnoNome", "TrimestreAnoNumero", "TrimestreInicio", "TrimestreFim", "TrimestreIndice", "TrimestresParaHoje", "TrimestreAtual", "TrimestreAnoAtual"} },
        { "TrimestreFiscal", new[] { "TrimestreFiscalNumero", "TrimestreFiscalNome", "MesDoTrimestreFiscalNumero", "AnoTrimestreFiscalNome", "AnoTrimestreFiscalNumero", "TrimestreFiscalInicio", "TrimestreFiscalFim", "TrimestresFiscaisParaHoje", "TrimestreFiscalAtual", "DiaDoTrimestreFiscal"} }

    };


    // Iterate through the folders and apply the DisplayFolder to each associated column
    foreach (var folder in displayFolders)
    {
        var folderName = folder.Key;
        var columns = folder.Value;

        foreach (var columnName in columns)
        {
            var column = calendar_table.Columns[columnName];
            if (column != null)
            {
                column.DisplayFolder = folderName; // Assign columns to the corresponding folder
            }
        }
    }

    // Disable aggregations for all columns in the table
    foreach (var column in calendar_table.Columns)
    {
        column.SummarizeBy = AggregateFunction.None;  // Disable aggregation
    }

    // Set the format for date-type columns
    var dateColumns = new[] { "AnoFim", "AnoFiscalFim", "AnoFiscalInicio", "AnoInicio", "Data", "DataDeFechamentoRef", "MesFim", "MesInicio", "SemanaFimISO", "SemanaInicioISO", "TrimestreFim", "TrimestreFiscalFim", "TrimestreFiscalInicio", "TrimestreInicio" };  // Columns containing dates
    foreach (var columnName in dateColumns)
    {
        var column = calendar_table.Columns[columnName];
        if (column != null)
        {
            column.FormatString = "Short Date";  // Apply short date format
        }
    }

    // Mark as a date table
    calendar_table.DataCategory = "Time";
    calendar_table.Columns["Data"].IsKey = true;
};

if (language == "es-ES")
{
    // Create a mapping of text columns and their respective numeric columns for sorting
    var columnPairs = new Dictionary<string, string>
    {
        {"FechaActual", "Fecha"},
        {"AnoDescendenteNombre", "AnoDecrecienteNumero"},
        {"AnoActual", "Ano"},
        {"DiaDeLaSemanaNombre", "DiaDeLaSemanaNumero"},
        {"DiaDeLaSemanaNombreCorto", "DiaDeLaSemanaNumero"},
        {"MesNombre", "MesNumero"},
        {"MesNombreCorto", "MesNumero"},
        {"MesAnoNombre", "MesAnoNumero"},
        {"MesDiaNombre", "MesDiaNumero"},
        {"MesActualNombre", "MesNumero"},
        {"MesActualNombreCorto", "MesNumero"},
        {"MesAnoActualNombre", "MesAnoNumero"},
        {"TrimestreNome", "TrimestreNumero"},
        {"TrimestreAnoNombre", "TrimestreAnoNumero"},
        {"TrimestreActual", "TrimestreNumero"},
        {"TrimestreAnoActual", "TrimestreAnoNumero"},
        {"SemanaAnoNombreISO", "SemanaAnoNumeroISO"},
        {"SemanaActualISO", "SemanaAnoNumeroISO"},
        {"SemanaPeriodoNombre", "SemanaAnoNumeroISO"},
        {"SemestreAnoNombre", "SemestreAnoNumero"},
        {"SemestreActual", "SemestreAnoNumero"},
        {"BimestreAnoNombre", "BimestreAnoNumero"},
        {"BimestreActual", "BimestreAnoNumero"},
        {"QuincenaMesNombre", "QuincenaMesNumero"},
        {"QuincenaMesAnoNombre", "QuincenaMesAnoNumero"},
        {"QuincenaActual", "QuincenaMesAnoNumero"},
        {"MesCierreNombre", "MesCierreNumero"},
        {"MesCierreNombreCorto", "MesCierreNumero"},
        {"MesAnoCierreNombre", "MesAnoCierreNumero"},
        {"EstacaoNorteNombre", "EstacaoNorteNumero"},
        {"EstacaoSulNombre", "EstacaoSulNumero"},
        {"AnoFiscalActual", "Anofiscal"},
        {"MesFiscalNombre", "MesFiscalNumero"},
        {"MesFiscalNombreCorto", "MesFiscalNumero"},
        {"MesFiscalActual", "MesFiscalNumero"},
        {"MesAnoFiscalNombre", "MesAnoFiscalNumero"},
        {"MesAnoFiscalActual", "MesAnoFiscalNumero"},
        {"TrimestreFiscalNombre", "TrimestreFiscalNumero"},
        {"AnoTrimestreFiscalNombre", "AnoTrimestreFiscalNumero"},
        {"TrimestreFiscalActual", "AnoTrimestreFiscalNumero"}
    };

    // Apply sorting for each text column
    foreach (var pair in columnPairs)
    {
        var textColumn = calendar_table.Columns[pair.Key];  // Text column
        var sortColumn = calendar_table.Columns[pair.Value];  // Corresponding numeric column

        // Check if both columns exist and apply sorting
        if (textColumn != null && sortColumn != null)
        {
            textColumn.SortByColumn = sortColumn;  // Sort text column by numeric column
        }
    }

    // Dictionary to associate columns with their respective folders
    var displayFolders = new Dictionary<string, string[]>
    {
        { "Ano", new[] { "Ano", "AnoActual", "AnoDecrecienteNumero", "AnoDescendenteNombre", "AnoFin", "AnoIndice", "AnoInicio", "AnosHastaHoy"} },
        { "AnoFiscal", new[] { "Anofiscal", "AnoFiscalActual", "AnoFiscalFin", "AnoFiscalFinalNumero", "AnoFiscalInicialNumero", "AnoFiscalInicio", "AnosFiscalesHastaHoy", "MesAnoFiscalActual", "MesAnoFiscalNombre", "MesAnoFiscalNumero", "MesesFiscalesHastaHoy", "MesFiscalActual", "MesFiscalNombre", "MesFiscalNombreCorto", "MesFiscalNumero"} },
        { "Cierre", new[] { "AnoCierre", "FechaDeCierreRef", "MesAnoCierreNombre", "MesAnoCierreNumero", "MesCierreNombre", "MesCierreNombreCorto", "MesCierreNumero"} },
        { "Dia", new[] { "DiaDelAno", "DiaDeLaSemanaNombre", "DiaDeLaSemanaNombreCorto", "DiaDeLaSemanaNombreIniciales", "DiaDeLaSemanaNumero", "DiaDelMes"} },
        { "DiaLaborable_Festivo", new[] { "DiaFestivo", "DiaLaborableNombre", "DiaLaborableNumero"} },
        { "Estacion", new[] { "EstacaoNorteNombre", "EstacaoNorteNumero", "EstacaoSulNombre", "EstacaoSulNumero"} },
        { "Fecha", new[] { "DiasHastaHoy", "FechaActual", "FechaIndice"} },
        { "Mes", new[] { "MesActualNombre", "MesActualNombreCorto", "MesAnoActualNombre", "MesAnoNombre", "MesAnoNumero", "MesDelTrimestreNumero", "MesDiaNombre", "MesDiaNumero", "MesesHastaHoy", "MesFin", "MesIndice", "MesInicio", "MesNombre", "MesNombreCorto", "MesNombreIniciales", "MesNumero"} },
        { "Quincena", new[] { "QuincenaActual", "QuincenaDelMesNumero", "QuincenaIndice", "QuincenaMesAnoNombre", "QuincenaMesAnoNumero", "QuincenaMesNombre", "QuincenaMesNumero", "QuincenasHastaHoy"} },
        { "Semana", new[] { "AnoISO", "SemanaActualISO", "SemanaAnoNombreISO", "SemanaAnoNumeroISO", "SemanaDelAnoNumeroISO", "SemanaDelMesNumero", "SemanaFinISO", "SemanaindiceISO", "SemanaInicioISO", "SemanaPeriodoNombre", "SemanasHastaHoyISO"} },
        { "Semestre", new[] { "BimestreActual", "BimestreAnoNombre", "BimestreAnoNumero", "BimestreIndice", "BimestreNumero", "BimestresHastaHoy", "SemestreActual", "SemestreAnoNombre", "SemestreAnoNumero", "SemestreIndice", "SemestreNumero", "SemestresHastaHoy"} },
        { "Trimestre", new[] { "TrimesteIndice", "TrimestreActual", "TrimestreAnoActual", "TrimestreAnoNombre", "TrimestreAnoNumero", "TrimestreFin", "TrimestreInicio", "TrimestreNome", "TrimestreNumero", "TrimestresHastaHoy"} },
        { "TrimestreFiscal", new[] { "AnoTrimestreFiscalNombre", "AnoTrimestreFiscalNumero", "DiaDelTrimestreFiscal", "MesDelTrimestreFiscalNumero", "TrimestralFiscalInicio", "TrimestreFiscalActual", "TrimestreFiscalFin", "TrimestreFiscalNombre", "TrimestreFiscalNumero", "TrimestresFiscalesHastaHoy"} }
    };


    // Iterate through the folders and apply the DisplayFolder to each associated column
    foreach (var folder in displayFolders)
    {
        var folderName = folder.Key;
        var columns = folder.Value;

        foreach (var columnName in columns)
        {
            var column = calendar_table.Columns[columnName];
            if (column != null)
            {
                column.DisplayFolder = folderName; // Assign columns to the corresponding folder
            }
        }
    }

    // Disable aggregations for all columns in the table
    foreach (var column in calendar_table.Columns)
    {
        column.SummarizeBy = AggregateFunction.None;  // Disable aggregation
    }

    // Set the format for date-type columns
    var dateColumns = new[] { "AnoFin", "AnoFiscalFin", "AnoFiscalInicio", "AnoInicio", "Fecha", "FechaDeCierreRef", "MesFin", "MesInicio", "SemanaFinISO", "SemanaInicioISO", "TrimestralFiscalInicio", "TrimestreFin", "TrimestreFiscalFin", "TrimestreInicio" };  // Columns containing dates
    foreach (var columnName in dateColumns)
    {
        var column = calendar_table.Columns[columnName];
        if (column != null)
        {
            column.FormatString = "Short Date";  // Apply short date format
        }
    }

    // Mark as a date table
    calendar_table.DataCategory = "Time";
    calendar_table.Columns["Fecha"].IsKey = true;
};