let
    #"-----PARAMETERS-----" = "", 
    
    // Set the name of the calendar_table
    calendarTable = Table.Buffer(Calendar),
    
    // Set the same language of calendar table
    language = "en-US",
    
    #"-----GENERATE DATA-----" = "",

    // Generate a table of periods
    periods = #table (

        // Declaration of columns and types
        type table [
            Period = text,
            PeriodOrdinal = Int64.Type,
            PeriodGroup = text,
            PeriodGroupOrdinal = Int64.Type,
            Date = {date}
        ],

        if language = "en-US" then
        
        // List of lists of values for each field
        {

        // Entire period
            { "Entire period",         1, "Entire period",  1, calendarTable[Date]                                                                                },

        // Day
            { "Today",                 2, "Day",            2, Table.SelectRows ( calendarTable, each [DaysToToday] =     0                       )[Date]          },
            { "Yesterday",             3, "Day",            2, Table.SelectRows ( calendarTable, each [DaysToToday] =    -1                       )[Date]          },
            { "Day before yesterday",  4, "Day",            2, Table.SelectRows ( calendarTable, each [DaysToToday] =    -2                       )[Date]          },
            { "Last 7 days",           5, "Day",            2, Table.SelectRows ( calendarTable, each [DaysToToday] >=   -6 and [DaysToToday] <= 0 )[Date]          },
            { "Last 15 days",          6, "Day",            2, Table.SelectRows ( calendarTable, each [DaysToToday] >=  -14 and [DaysToToday] <= 0 )[Date]          },
            { "Last 30 days",          7, "Day",            2, Table.SelectRows ( calendarTable, each [DaysToToday] >=  -29 and [DaysToToday] <= 0 )[Date]          },
            { "Last 60 days",          8, "Day",            2, Table.SelectRows ( calendarTable, each [DaysToToday] >=  -59 and [DaysToToday] <= 0 )[Date]          },
            { "Last 90 days",          9, "Day",            2, Table.SelectRows ( calendarTable, each [DaysToToday] >=  -89 and [DaysToToday] <= 0 )[Date]          },
            { "Last 180 days",        10, "Day",            2, Table.SelectRows ( calendarTable, each [DaysToToday] >= -179 and [DaysToToday] <= 0 )[Date]          },
            { "Last 365 days",        11, "Day",            2, Table.SelectRows ( calendarTable, each [DaysToToday] >= -364 and [DaysToToday] <= 0 )[Date]          },

        // Week
            { "This week",            12, "Week",           3, Table.SelectRows ( calendarTable, each [WeeksToTodayISO] =    0  )[Date]                              },
            { "Last week",            13, "Week",           3, Table.SelectRows ( calendarTable, each [WeeksToTodayISO] =   -1  )[Date]                              },
            { "Week before last",     14, "Week",           3, Table.SelectRows ( calendarTable, each [WeeksToTodayISO] =   -2  )[Date]                              },
            { "Last 3 weeks",         15, "Week",           3, Table.SelectRows ( calendarTable, each [WeeksToTodayISO] >=  -2 and [WeeksToTodayISO] <= 0 )[Date]       },
            { "Last 6 weeks",         16, "Week",           3, Table.SelectRows ( calendarTable, each [WeeksToTodayISO] >=  -5 and [WeeksToTodayISO] <= 0 )[Date]       },
            { "Last 9 weeks",         17, "Week",           3, Table.SelectRows ( calendarTable, each [WeeksToTodayISO] >=  -8 and [WeeksToTodayISO] <= 0 )[Date]       },
            { "Last 12 weeks",        18, "Week",           3, Table.SelectRows ( calendarTable, each [WeeksToTodayISO] >= -11 and [WeeksToTodayISO] <= 0 )[Date]       },

        // Fortnight
            { "This fortnight",       19, "Fortnight",      4, Table.SelectRows ( calendarTable, each [FortnightsToToday] =    0 )[Date]                               },
            { "Last fortnight",       20, "Fortnight",      4, Table.SelectRows ( calendarTable, each [FortnightsToToday] =   -1 )[Date]                               },
            { "Fortnight before last",21, "Fortnight",      4, Table.SelectRows ( calendarTable, each [FortnightsToToday] =   -2 )[Date]                               },
            { "Last 3 fortnights",    22, "Fortnight",      4, Table.SelectRows ( calendarTable, each [FortnightsToToday] >=  -2 and [FortnightsToToday] <= 0 )[Date]     },
            { "Last 6 fortnights",    23, "Fortnight",      4, Table.SelectRows ( calendarTable, each [FortnightsToToday] >=  -5 and [FortnightsToToday] <= 0 )[Date]     },
            { "Last 9 fortnights",    24, "Fortnight",      4, Table.SelectRows ( calendarTable, each [FortnightsToToday] >=  -8 and [FortnightsToToday] <= 0 )[Date]     },
            { "Last 12 fortnights",   25, "Fortnight",      4, Table.SelectRows ( calendarTable, each [FortnightsToToday] >= -11 and [FortnightsToToday] <= 0 )[Date]     },

        // Month
            { "This month",           26, "Month",          5, Table.SelectRows ( calendarTable, each [MonthsToToday] =    0 )[Date]                                  },
            { "Last month",           27, "Month",          5, Table.SelectRows ( calendarTable, each [MonthsToToday] =   -1 )[Date]                                  },
            { "Month before last",    28, "Month",          5, Table.SelectRows ( calendarTable, each [MonthsToToday] =   -2 )[Date]                                  },
            { "Last 3 months",        29, "Month",          5, Table.SelectRows ( calendarTable, each [MonthsToToday] >=  -2 and [MonthsToToday] <= 0 )[Date]             },
            { "Last 6 months",        30, "Month",          5, Table.SelectRows ( calendarTable, each [MonthsToToday] >=  -5 and [MonthsToToday] <= 0 )[Date]             },
            { "Last 9 months",        31, "Month",          5, Table.SelectRows ( calendarTable, each [MonthsToToday] >=  -8 and [MonthsToToday] <= 0 )[Date]             },
            { "Last 12 months",       32, "Month",          5, Table.SelectRows ( calendarTable, each [MonthsToToday] >= -11 and [MonthsToToday] <= 0 )[Date]             },

        // Quarter
            { "This quarter",         33, "Quarter",        6, Table.SelectRows ( calendarTable, each [QuartersToToday] =    0 )[Date]                            },
            { "Last quarter",         34, "Quarter",        6, Table.SelectRows ( calendarTable, each [QuartersToToday] =   -1 )[Date]                            },
            { "Quarter before last",  35, "Quarter",        6, Table.SelectRows ( calendarTable, each [QuartersToToday] =   -2 )[Date]                            },
            { "Last 3 quarters",      36, "Quarter",        6, Table.SelectRows ( calendarTable, each [QuartersToToday] >=  -2 and [QuartersToToday] <= 0 )[Date] },
            { "Last 6 quarters",      37, "Quarter",        6, Table.SelectRows ( calendarTable, each [QuartersToToday] >=  -5 and [QuartersToToday] <= 0 )[Date] },
            { "Last 9 quarters",      38, "Quarter",        6, Table.SelectRows ( calendarTable, each [QuartersToToday] >=  -8 and [QuartersToToday] <= 0 )[Date] },
            { "Last 12 quarters",     39, "Quarter",        6, Table.SelectRows ( calendarTable, each [QuartersToToday] >= -11 and [QuartersToToday] <= 0 )[Date] },
            
        // Year    
            { "This year",            40, "Year",           7, Table.SelectRows ( calendarTable, each [YearsToToday] =    0 )[Date]                                  },
            { "Last year",            41, "Year",           7, Table.SelectRows ( calendarTable, each [YearsToToday] =   -1 )[Date]                                  },
            { "Year before last",     42, "Year",           7, Table.SelectRows ( calendarTable, each [YearsToToday] =   -2 )[Date]                                  },
            { "Last 2 years",         43, "Year",           7, Table.SelectRows ( calendarTable, each [YearsToToday] >=  -2 and [YearsToToday] <= 0 )[Date]             },
            { "Last 3 years",         44, "Year",           7, Table.SelectRows ( calendarTable, each [YearsToToday] >=  -5 and [YearsToToday] <= 0 )[Date]             },
            { "Last 4 years",         45, "Year",           7, Table.SelectRows ( calendarTable, each [YearsToToday] >=  -8 and [YearsToToday] <= 0 )[Date]             },
            { "Last 5 years",         46, "Year",           7, Table.SelectRows ( calendarTable, each [YearsToToday] >= -11 and [YearsToToday] <= 0 )[Date]             },

        // Up to             
            { "Up to today",          47, "Up to",           8, Table.SelectRows ( calendarTable, each [DaysToToday] <= 0 )[Date]                                   },
            { "Up to yesterday",      48, "Up to",           8, Table.SelectRows ( calendarTable, each [DaysToToday] <= -1 )[Date]                                  },
            { "Up to day before yesterday", 49, "Up to",     8, Table.SelectRows ( calendarTable, each [DaysToToday] <= -2 )[Date]                                  }
        }

        else if language = "pt-BR" then
        
        // List of lists of values for each field
        {

        // Entire period
            { "Todo período",              1, "Todo o período",  1, calendarTable[Data]                                                                                },

        // Day
            { "Hoje",                      2, "Dia",         2, Table.SelectRows ( calendarTable, each [DiasParaHoje] =     0                       )[Data]          },
            { "Ontem",                     3, "Dia",         2, Table.SelectRows ( calendarTable, each [DiasParaHoje] =    -1                       )[Data]          },
            { "Anteontem",                 4, "Dia",         2, Table.SelectRows ( calendarTable, each [DiasParaHoje] =    -2                       )[Data]          },
            { "Últimos 7 dias",            5, "Dia",         2, Table.SelectRows ( calendarTable, each [DiasParaHoje] >=   -6 and [DiasParaHoje] <= 0 )[Data]          },
            { "Últimos 15 dias",           6, "Dia",         2, Table.SelectRows ( calendarTable, each [DiasParaHoje] >=  -14 and [DiasParaHoje] <= 0 )[Data]          },
            { "Últimos 30 dias",           7, "Dia",         2, Table.SelectRows ( calendarTable, each [DiasParaHoje] >=  -29 and [DiasParaHoje] <= 0 )[Data]          },
            { "Últimos 60 dias",           8, "Dia",         2, Table.SelectRows ( calendarTable, each [DiasParaHoje] >=  -59 and [DiasParaHoje] <= 0 )[Data]          },
            { "Últimos 90 dias",           9, "Dia",         2, Table.SelectRows ( calendarTable, each [DiasParaHoje] >=  -89 and [DiasParaHoje] <= 0 )[Data]          },
            { "Últimos 180 dias",         10, "Dia",         2, Table.SelectRows ( calendarTable, each [DiasParaHoje] >= -179 and [DiasParaHoje] <= 0 )[Data]          },
            { "Últimos 365 dias",         11, "Dia",         2, Table.SelectRows ( calendarTable, each [DiasParaHoje] >= -364 and [DiasParaHoje] <= 0 )[Data]          },

        // Week
            { "Essa semana",              12, "Semana",      3, Table.SelectRows ( calendarTable, each [SemanasParaHojeISO] =    0  )[Data]                              },
            { "Última semana",            13, "Semana",      3, Table.SelectRows ( calendarTable, each [SemanasParaHojeISO] =   -1  )[Data]                              },
            { "Antepenúltima semana",     14, "Semana",      3, Table.SelectRows ( calendarTable, each [SemanasParaHojeISO] =   -2  )[Data]                              },
            { "Últimas  3 semanas",       15, "Semana",      3, Table.SelectRows ( calendarTable, each [SemanasParaHojeISO] >=  -2 and [SemanasParaHojeISO] <= 0 )[Data]       },
            { "Últimas  6 semanas",       16, "Semana",      3, Table.SelectRows ( calendarTable, each [SemanasParaHojeISO] >=  -5 and [SemanasParaHojeISO] <= 0 )[Data]       },
            { "Últimas  9 semanas",       17, "Semana",      3, Table.SelectRows ( calendarTable, each [SemanasParaHojeISO] >=  -8 and [SemanasParaHojeISO] <= 0 )[Data]       },
            { "Últimas 12 semanas",       18, "Semana",      3, Table.SelectRows ( calendarTable, each [SemanasParaHojeISO] >= -11 and [SemanasParaHojeISO] <= 0 )[Data]       },

        // Fortnight
            { "Essa quinzena",            19, "Quinzena",    4, Table.SelectRows ( calendarTable, each [QuinzenasParaHoje] =    0 )[Data]                               },
            { "Última quinzena",          20, "Quinzena",    4, Table.SelectRows ( calendarTable, each [QuinzenasParaHoje] =   -1 )[Data]                               },
            { "Antepenúltima quinzena",   21, "Quinzena",    4, Table.SelectRows ( calendarTable, each [QuinzenasParaHoje] =   -2 )[Data]                               },
            { "Últimas 3 quinzenas",      22, "Quinzena",    4, Table.SelectRows ( calendarTable, each [QuinzenasParaHoje] >=  -2 and [QuinzenasParaHoje] <= 0 )[Data]     },
            { "Últimas 6 quinzenas",      23, "Quinzena",    4, Table.SelectRows ( calendarTable, each [QuinzenasParaHoje] >=  -5 and [QuinzenasParaHoje] <= 0 )[Data]     },
            { "Últimas 9 quinzenas",      24, "Quinzena",    4, Table.SelectRows ( calendarTable, each [QuinzenasParaHoje] >=  -8 and [QuinzenasParaHoje] <= 0 )[Data]     },
            { "Últimas 12 quinzenas",     25, "Quinzena",    4, Table.SelectRows ( calendarTable, each [QuinzenasParaHoje] >= -11 and [QuinzenasParaHoje] <= 0 )[Data]     },

        // Month
            { "Esse mês",                 26, "Mês",         5, Table.SelectRows ( calendarTable, each [MesesParaHoje] =    0 )[Data]                                  },
            { "Último mês",               27, "Mês",         5, Table.SelectRows ( calendarTable, each [MesesParaHoje] =   -1 )[Data]                                  },
            { "Antepenúltimo mês",        28, "Mês",         5, Table.SelectRows ( calendarTable, each [MesesParaHoje] =   -2 )[Data]                                  },
            { "Últimos 3 meses",          29, "Mês",         5, Table.SelectRows ( calendarTable, each [MesesParaHoje] >=  -2 and [MesesParaHoje] <= 0 )[Data]             },
            { "Últimos 6 meses",          30, "Mês",         5, Table.SelectRows ( calendarTable, each [MesesParaHoje] >=  -5 and [MesesParaHoje] <= 0 )[Data]             },
            { "Últimos 9 meses",          31, "Mês",         5, Table.SelectRows ( calendarTable, each [MesesParaHoje] >=  -8 and [MesesParaHoje] <= 0 )[Data]             },
            { "Últimos 12 meses",         32, "Mês",         5, Table.SelectRows ( calendarTable, each [MesesParaHoje] >= -11 and [MesesParaHoje] <= 0 )[Data]             },

        // Quarter
            { "Esse trimestre",           33, "Trimestre",   6, Table.SelectRows ( calendarTable, each [TrimestresParaHoje] =    0 )[Data]                            },
            { "Último trimestre",         34, "Trimestre",   6, Table.SelectRows ( calendarTable, each [TrimestresParaHoje] =   -1 )[Data]                            },
            { "Antepenúltimo Trimestre",  35, "Trimestre",   6, Table.SelectRows ( calendarTable, each [TrimestresParaHoje] =   -2 )[Data]                            },
            { "Últimos 3 trimestres",     36, "Trimestre",   6, Table.SelectRows ( calendarTable, each [TrimestresParaHoje] >=  -2 and [TrimestresParaHoje] <= 0 )[Data] },
            { "Últimos 6 trimestres",     37, "Trimestre",   6, Table.SelectRows ( calendarTable, each [TrimestresParaHoje] >=  -5 and [TrimestresParaHoje] <= 0 )[Data] },
            { "Últimos 9 trimestres",     38, "Trimestre",   6, Table.SelectRows ( calendarTable, each [TrimestresParaHoje] >=  -8 and [TrimestresParaHoje] <= 0 )[Data] },
            { "Últimos 12 trimestres",    39, "Trimestre",   6, Table.SelectRows ( calendarTable, each [TrimestresParaHoje] >= -11 and [TrimestresParaHoje] <= 0 )[Data] },
            
        // Year    
            { "Esse ano",                 40, "Ano",           7, Table.SelectRows ( calendarTable, each [AnosParaHoje] =    0 )[Data]                                  },
            { "Último ano",               41, "Ano",           7, Table.SelectRows ( calendarTable, each [AnosParaHoje] =   -1 )[Data]                                  },
            { "Antepenúltimo ano",        42, "Ano",           7, Table.SelectRows ( calendarTable, each [AnosParaHoje] =   -2 )[Data]                                  },
            { "Últimos 2 anos",           43, "Ano",           7, Table.SelectRows ( calendarTable, each [AnosParaHoje] >=  -2 and [AnosParaHoje] <= 0 )[Data]             },
            { "Últimos 3 anos",           44, "Ano",           7, Table.SelectRows ( calendarTable, each [AnosParaHoje] >=  -5 and [AnosParaHoje] <= 0 )[Data]             },
            { "Últimos 4 anos",           45, "Ano",           7, Table.SelectRows ( calendarTable, each [AnosParaHoje] >=  -8 and [AnosParaHoje] <= 0 )[Data]             },
            { "Últimos 5 anos",           46, "Ano",           7, Table.SelectRows ( calendarTable, each [AnosParaHoje] >= -11 and [AnosParaHoje] <= 0 )[Data]             },

        // Up to             
            { "Até hoje",                 47, "Até",           8, Table.SelectRows ( calendarTable, each [DiasParaHoje] <= 0 )[Data]                                   },
            { "Até ontem",                48, "Até",           8, Table.SelectRows ( calendarTable, each [DiasParaHoje] <= -1 )[Data]                                  },
            { "Até anteontem",            49, "Até",           8, Table.SelectRows ( calendarTable, each [DiasParaHoje] <= -2 )[Data]                                  }
        }

        else if language = "es-ES" then
        
        // List of lists of values for each field
        {

        // Entire period
            { "Todo el período",              1, "Todo el período",  1, calendarTable[Fecha]                                                                                },

// Day
            { "Hoy",                       2, "Día",         2, Table.SelectRows ( calendarTable, each [DiasHastaHoy] =     0                       )[Fecha]          },
            { "Ayer",                      3, "Día",         2, Table.SelectRows ( calendarTable, each [DiasHastaHoy] =    -1                       )[Fecha]          },
            { "Antier",                    4, "Día",         2, Table.SelectRows ( calendarTable, each [DiasHastaHoy] =    -2                       )[Fecha]          },
            { "Últimos 7 Días",            5, "Día",         2, Table.SelectRows ( calendarTable, each [DiasHastaHoy] >=   -6 and [DiasHastaHoy] <= 0 )[Fecha]          },
            { "Últimos 15 Días",           6, "Día",         2, Table.SelectRows ( calendarTable, each [DiasHastaHoy] >=  -14 and [DiasHastaHoy] <= 0 )[Fecha]          },
            { "Últimos 30 Días",           7, "Día",         2, Table.SelectRows ( calendarTable, each [DiasHastaHoy] >=  -29 and [DiasHastaHoy] <= 0 )[Fecha]          },
            { "Últimos 60 Días",           8, "Día",         2, Table.SelectRows ( calendarTable, each [DiasHastaHoy] >=  -59 and [DiasHastaHoy] <= 0 )[Fecha]          },
            { "Últimos 90 Días",           9, "Día",         2, Table.SelectRows ( calendarTable, each [DiasHastaHoy] >=  -89 and [DiasHastaHoy] <= 0 )[Fecha]          },
            { "Últimos 180 Días",         10, "Día",         2, Table.SelectRows ( calendarTable, each [DiasHastaHoy] >= -179 and [DiasHastaHoy] <= 0 )[Fecha]          },
            { "Últimos 365 Días",         11, "Día",         2, Table.SelectRows ( calendarTable, each [DiasHastaHoy] >= -364 and [DiasHastaHoy] <= 0 )[Fecha]          },

        // Week
            { "Esta semana",              12, "Semana",      3, Table.SelectRows ( calendarTable, each [SemanasHastaHoyISO] =    0  )[Fecha]                              },
            { "Última semana",            13, "Semana",      3, Table.SelectRows ( calendarTable, each [SemanasHastaHoyISO] =   -1  )[Fecha]                              },
            { "Antepenúltima semana",     14, "Semana",      3, Table.SelectRows ( calendarTable, each [SemanasHastaHoyISO] =   -2  )[Fecha]                              },
            { "Últimas  3 semanas",       15, "Semana",      3, Table.SelectRows ( calendarTable, each [SemanasHastaHoyISO] >=  -2 and [SemanasHastaHoyISO] <= 0 )[Fecha]       },
            { "Últimas  6 semanas",       16, "Semana",      3, Table.SelectRows ( calendarTable, each [SemanasHastaHoyISO] >=  -5 and [SemanasHastaHoyISO] <= 0 )[Fecha]       },
            { "Últimas  9 semanas",       17, "Semana",      3, Table.SelectRows ( calendarTable, each [SemanasHastaHoyISO] >=  -8 and [SemanasHastaHoyISO] <= 0 )[Fecha]       },
            { "Últimas 12 semanas",       18, "Semana",      3, Table.SelectRows ( calendarTable, each [SemanasHastaHoyISO] >= -11 and [SemanasHastaHoyISO] <= 0 )[Fecha]       },


        // Fortnight
            { "Esta Quincena",            19, "Quincena",    4, Table.SelectRows ( calendarTable, each [QuincenasHastaHoy] =    0 )[Fecha]                               },
            { "Última Quincena",          20, "Quincena",    4, Table.SelectRows ( calendarTable, each [QuincenasHastaHoy] =   -1 )[Fecha]                               },
            { "Antepenúltima Quincena",   21, "Quincena",    4, Table.SelectRows ( calendarTable, each [QuincenasHastaHoy] =   -2 )[Fecha]                               },
            { "Últimas 3 quincenas",      22, "Quincena",    4, Table.SelectRows ( calendarTable, each [QuincenasHastaHoy] >=  -2 and [QuincenasHastaHoy] <= 0 )[Fecha]     },
            { "Últimas 6 quincenas",      23, "Quincena",    4, Table.SelectRows ( calendarTable, each [QuincenasHastaHoy] >=  -5 and [QuincenasHastaHoy] <= 0 )[Fecha]     },
            { "Últimas 9 quincenas",      24, "Quincena",    4, Table.SelectRows ( calendarTable, each [QuincenasHastaHoy] >=  -8 and [QuincenasHastaHoy] <= 0 )[Fecha]     },
            { "Últimas 12 quincenas",     25, "Quincena",    4, Table.SelectRows ( calendarTable, each [QuincenasHastaHoy] >= -11 and [QuincenasHastaHoy] <= 0 )[Fecha]     },


        // Month
            { "Este mes",                 26, "mes",         5, Table.SelectRows ( calendarTable, each [MesesHastaHoy] =    0 )[Fecha]                                  },
            { "Último mes",               27, "mes",         5, Table.SelectRows ( calendarTable, each [MesesHastaHoy] =   -1 )[Fecha]                                  },
            { "Antepenúltimo mes",        28, "mes",         5, Table.SelectRows ( calendarTable, each [MesesHastaHoy] =   -2 )[Fecha]                                  },
            { "Últimos 3 meses",          29, "mes",         5, Table.SelectRows ( calendarTable, each [MesesHastaHoy] >=  -2 and [MesesHastaHoy] <= 0 )[Fecha]             },
            { "Últimos 6 meses",          30, "mes",         5, Table.SelectRows ( calendarTable, each [MesesHastaHoy] >=  -5 and [MesesHastaHoy] <= 0 )[Fecha]             },
            { "Últimos 9 meses",          31, "mes",         5, Table.SelectRows ( calendarTable, each [MesesHastaHoy] >=  -8 and [MesesHastaHoy] <= 0 )[Fecha]             },
            { "Últimos 12 meses",         32, "mes",         5, Table.SelectRows ( calendarTable, each [MesesHastaHoy] >= -11 and [MesesHastaHoy] <= 0 )[Fecha]             },

        // Quarter
            { "Este trimestre",           33, "Trimestre",   6, Table.SelectRows ( calendarTable, each [TrimestresHastaHoy] =    0 )[Fecha]                            },
            { "Último trimestre",         34, "Trimestre",   6, Table.SelectRows ( calendarTable, each [TrimestresHastaHoy] =   -1 )[Fecha]                            },
            { "Antepenúltimo trimestre",  35, "Trimestre",   6, Table.SelectRows ( calendarTable, each [TrimestresHastaHoy] =   -2 )[Fecha]                            },
            { "Últimos 3 trimestres",     36, "Trimestre",   6, Table.SelectRows ( calendarTable, each [TrimestresHastaHoy] >=  -2 and [TrimestresHastaHoy] <= 0 )[Fecha] },
            { "Últimos 6 trimestres",     37, "Trimestre",   6, Table.SelectRows ( calendarTable, each [TrimestresHastaHoy] >=  -5 and [TrimestresHastaHoy] <= 0 )[Fecha] },
            { "Últimos 9 trimestres",     38, "Trimestre",   6, Table.SelectRows ( calendarTable, each [TrimestresHastaHoy] >=  -8 and [TrimestresHastaHoy] <= 0 )[Fecha] },
            { "Últimos 12 trimestres",    39, "Trimestre",   6, Table.SelectRows ( calendarTable, each [TrimestresHastaHoy] >= -11 and [TrimestresHastaHoy] <= 0 )[Fecha] },
            
        // Year    
            { "Este año",                 40, "Año",         7, Table.SelectRows ( calendarTable, each [AnosHastaHoy] =    0 )[Fecha]                                  },
            { "Último año",               41, "Año",         7, Table.SelectRows ( calendarTable, each [AnosHastaHoy] =   -1 )[Fecha]                                  },
            { "Antepenúltimo año",        42, "Año",         7, Table.SelectRows ( calendarTable, each [AnosHastaHoy] =   -2 )[Fecha]                                  },
            { "Últimos 2 años",           43, "Año",         7, Table.SelectRows ( calendarTable, each [AnosHastaHoy] >=  -2 and [AnosHastaHoy] <= 0 )[Fecha]             },
            { "Últimos 3 años",           44, "Año",         7, Table.SelectRows ( calendarTable, each [AnosHastaHoy] >=  -5 and [AnosHastaHoy] <= 0 )[Fecha]             },
            { "Últimos 4 años",           45, "Año",         7, Table.SelectRows ( calendarTable, each [AnosHastaHoy] >=  -8 and [AnosHastaHoy] <= 0 )[Fecha]             },
            { "Últimos 5 años",           46, "Año",         7, Table.SelectRows ( calendarTable, each [AnosHastaHoy] >= -11 and [AnosHastaHoy] <= 0 )[Fecha]             },

        // Up to             
            { "Hasta hoy",                47, "Hasta",           8, Table.SelectRows ( calendarTable, each [DiasHastaHoy] <= 0 )[Fecha]                                   },
            { "Hasta Ayer",               48, "Hasta",           8, Table.SelectRows ( calendarTable, each [DiasHastaHoy] <= -1 )[Fecha]                                  },
            { "Hasta Antier",             49, "Hasta",           8, Table.SelectRows ( calendarTable, each [DiasHastaHoy] <= -2 )[Fecha]                                  }
        }

        else null
    ),

    // Expand the Date list column
    expandedPeriodDates = Table.ExpandListColumn(periods, "Date"),


    #"-----RENAME COLUMNS-----" = "", 
    
    columnNamesDictionary = Table.FromRows(Json.Document(Binary.Decompress(Binary.FromText("i45WCkgtysxPUdKBMvKRWLE6MGn/opTMvMQchBxOAYQe96L80gKEAvei0gKQ4WDaJTUH0xKwBgyDweoRomjaka11SSxJBaoAUolAyi01OSNRKTYWAA==", BinaryEncoding.Base64), Compression.Deflate)), let _t = ((type nullable text) meta [Serialized.Text = true]) in type table [#"en-US" = _t, #"pt-BR" = _t, #"es-ES" = _t]),

    fromToColumnNames = if language <> "en-US" then List.Zip(Table.ToColumns(Table.SelectColumns(columnNamesDictionary, {"en-US", language}))) else null,
    renamedColumns = if language <> "en-US" then Table.RenameColumns(expandedPeriodDates, fromToColumnNames) else expandedPeriodDates
in
    renamedColumns