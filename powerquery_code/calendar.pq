let

    #"-----PARAMETERS-----" = "",

    // Specify the start date 
    startDate = #date(2020, 1, 1),

    // Years ahead today
    yearsAhead = 1,
            
    // Specify the start of the week. Default: Day.Monday 
    startOfWeek = Day.Monday,
    
    // Specify the month of the fiscal year end. Default: 3 (March)
    monthOfFiscalYearEnd = 3,
    
    /* Start day of the closing month. 
       Default: 16 (it means the closing month goes from the 16th of the current month 
       to the 15th of the next month) */
    closingMonthStartDay = 16,
    
    // Available: "en-US", "pt-BR", "es-ES"
    language = "en-US",

    #"-----INTERNAL USE-----" = "",
  
    endDate = Date.AddYears(Date.EndOfYear(Date.From(DateTime.LocalNow())), yearsAhead),
    currentDate = Date.From(DateTime.LocalNow()),
	currentYear = Date.Year(currentDate),
	currentMonth = Date.Month(currentDate),  
    startYear = Date.Year(startDate),
	startMonth = Date.Month(startDate),
    currentFiscalYear = Date.Year(Date.AddMonths(currentDate, 12-monthOfFiscalYearEnd)), 
    

    // The table with auxiliary texts cross the languages
    auxiliaryTextTable = Table.UnpivotOtherColumns(
        #table(
            type table [Class=text, #"en-US"=text, #"pt-BR"=text, #"es-ES"=text],
            {
                  { "current"        , "Current"        , "Atual"       , "Actual"              }
                , { "quarter"        , "Q"              , "T"           , "T"                   }
                , { "week"           , "W"              , "S"           , "S"                   }
                , { "half"           , "H"              , "S"           , "S"                   }
                , { "bimester"       , "B"              , "B"           , "B"                   }
                , { "fortnight"      , "FN"             , "Q"           , "Q"                   }
                , { "summer"         , "Summer"         , "Verão"       , "Verano"              }
                , { "spring"         , "Spring"         , "Primavera"   , "Primavera"           }
                , { "autumn"         , "Autumn"         , "Outono"      , "Otoño"               }
                , { "winter"         , "Winter"         , "Inverno"     , "Invierno"            }
                , { "businessDay"    , "BusinessDay"    , "Dia Útil"    , "Dia Laborable"       }
                , { "non-businessDay", "Non-BusinessDay", "Dia Não Útil", "Dia No Laborable"    }
            }
        ),
        {"Class"}, "Language", "Value"
    ),
    
    // Filtered table on selected language
    auxiliaryTextTableOnLanguage = Table.Buffer(Table.SelectRows(auxiliaryTextTable, each [Language]=language)),
    currentText = auxiliaryTextTableOnLanguage{[Class="current"]}[Value], 
    quarterPrefix = auxiliaryTextTableOnLanguage{[Class="quarter"]}[Value], 
    weekPrefix = auxiliaryTextTableOnLanguage{[Class="week"]}[Value],
    halfPrefix = auxiliaryTextTableOnLanguage{[Class="half"]}[Value],
    bimesterPrefix = auxiliaryTextTableOnLanguage{[Class="bimester"]}[Value],
    fortnightPrefix = auxiliaryTextTableOnLanguage{[Class="fortnight"]}[Value],
    summerText = auxiliaryTextTableOnLanguage{[Class="summer"]}[Value],
    springText = auxiliaryTextTableOnLanguage{[Class="spring"]}[Value],
    autumnText = auxiliaryTextTableOnLanguage{[Class="autumn"]}[Value],
    winterText = auxiliaryTextTableOnLanguage{[Class="winter"]}[Value],
    businessDayText = auxiliaryTextTableOnLanguage{[Class="businessDay"]}[Value],
    nonBusinessDayText = auxiliaryTextTableOnLanguage{[Class="non-businessDay"]}[Value],
    
    // Invisible character (zero-width spacing)
    zws = Character.FromNumber(8203),  

    // List with all dates 
    datesList = List.Dates(startDate, Duration.Days(endDate-startDate)+1, #duration(1, 0, 0, 0)),

    // List with all years 
    yearRange = List.Buffer({Date.Year(startDate)..Date.Year(endDate)}),
            

    #"-----GENERATE HOLIDAYS-----" = "", 

    // Fixed holidays that occur every year 
    fixedHolidaysList = #table(
        type table [Day=Int64.Type, Month=Int64.Type, Holiday=text],
        
        if language="pt-BR" then
            {
                // Day, Month, Holiday
                  { 01, 01, "Confraternização Universal"   }
                , { 25, 01, "Aniversário da Cidade"        } 
                , { 21, 04, "Tiradentes"                   } 
                , { 01, 05, "Dia do Trabalhador"           } 
                , { 09, 07, "Revolução Constitucionalista" } 
                , { 07, 09, "Independência do Brasil"      } 
                , { 12, 10, "N. Srª Aparecida"             } 
                , { 02, 11, "Finados"                      } 
                , { 15, 11, "Proclamação da República"     } 
                , { 20, 11, "Consciência Negra"            } 
                , { 24, 12, "Véspera de Natal"             } 
                , { 25, 12, "Natal"                        } 
                , { 31, 12, "Véspera de Ano Novo"          } 
            }

        else if language="en-US" then
            {
                // Day, Month, Holiday
                  { 1,  1, "New Year's Day"}
                , { 4,  7, "Independence Day"}
                , {11, 11, "Veterans Day"}
                , {25, 12, "Christmas Day"}
            }

        else if language="es-ES" then
            {
                // Day, Month, Holiday
                  { 1, 1, "Año Nuevo"}
                , { 1, 5, "Día del Trabajo" } 
            }
        else null
    ),

    // Function that generates the fixed holidays for all years 
    fxGenerateFixedHolidays = (year)=>
        Table.AddColumn(
            fixedHolidaysList,
            "Date",
            each #date(year, [Month], [Day]),
            type date
        )[[Date], [Holiday]],
            
    // Generate the fixed holiday table 
    fixedHolidays = Table.Combine(List.Transform(yearRange, fxGenerateFixedHolidays)),
    
    // Function that generates the moving holidays 
    fxGenerateMovingHolidays = (year) =>
    let
        modExcel = (x, y) =>
            let
                m = Number.Mod(x, y)
            in
                if m < 0 then m + y else m,
        easter = Date.From(
            Number.Round(
                Number.From(#date(year, 4, 1))
                    / 7
                    + modExcel(19 * modExcel(year, 19) - 7, 30) * 0.14,
                0,
                RoundingMode.Up
            )
                * 7
                - 6
        ),
        movingHolidays = #table(
            type table [Date = date, Holiday = text],
            {
                  { Date.AddDays(easter, -2  ), if language = "pt-BR" then "Sexta-Feira Santa" else if language = "en-US" then "Good Friday" else if language = "es-ES" then "Viernes Santo" else null } 
                , { easter                    , if language = "pt-BR" then "Páscoa" else if language = "en-US" then "Easter" else if language = "es-ES" then "Pascua" else null }
                , { Date.AddDays(easter, 60  ), "Corpus Christi"             }
            //  , { Date.AddDays(easter, -48 ), "Segunda-feira de Carnaval"  }
            //  , { Date.AddDays(easter, -47 ), "Terça-feira de Carnaval"    }
            //  , { Date.AddDays(easter, -46 ), "Quarta-feira de Cinzas"     }
            }
        )
    in
        movingHolidays,
            
    // Generate the moving holiday table 
    movingHolidays = Table.Combine(List.Transform(yearRange, fxGenerateMovingHolidays)),
            
    // Table containing all holidays 
    holidays = Table.Group(Table.Combine({fixedHolidays, movingHolidays}), {"Date"}, {{"Holiday", each Text.Combine(_[Holiday], "/"), type text}}),
    
    #"-----GENERATE DATA-----" = "",

    #"-----DATE-----" = "",
    datesTable = Table.FromList(datesList, Splitter.SplitByNothing(), type table [ Date = date ]),
    add_DateIndex = Table.AddIndexColumn(datesTable, "DateIndex", 1, 1, Int64.Type),
    add_DaysToToday = Table.AddColumn(add_DateIndex, "DaysToToday", each Number.From([Date] - currentDate), Int64.Type),
    add_CurrentDate = Table.AddColumn(add_DaysToToday, "CurrentDate", each if [DaysToToday] = 0 then currentText else Date.ToText([Date], "dd/MM/yyyy"), type text),

    #"-----YEAR-----" = "",    
    add_Year = Table.AddColumn(add_CurrentDate, "Year", each Date.Year([Date]), Int64.Type),
    add_YearStart = Table.AddColumn(add_Year, "YearStart", each Date.StartOfYear([Date]), type date),
    add_YearEnd = Table.AddColumn(add_YearStart, "YearEnd", each Date.EndOfYear([Date]), type date),
    add_YearIndex = Table.AddColumn(add_YearEnd, "YearIndex", each [Year] - startYear + 1, Int64.Type),
    add_YearDescendingName = Table.AddColumn(add_YearIndex, "YearDescendingName", each [Year], Int64.Type),
    add_YearDescendingNumber = Table.AddColumn(add_YearDescendingName, "YearDescendingNumber", each [Year] * -1, Int64.Type),
    add_YearsToToday = Table.AddColumn(add_YearDescendingNumber, "YearsToToday", each [Year] - Date.Year(currentDate), Int64.Type),
    add_CurrentYear = Table.AddColumn(add_YearsToToday, "CurrentYear", each if [YearsToToday] = 0 then currentText else Text.From([Year]), type text),

    #"-----DAY-----" = "",
    add_DayOfMonth = Table.AddColumn(add_CurrentYear, "DayOfMonth", each Date.Day([Date]), Int64.Type),
    add_DayOfYear = Table.AddColumn(add_DayOfMonth, "DayOfYear", each Date.DayOfYear([Date]), Int64.Type),
    add_DayOfWeekNumber = Table.AddColumn(add_DayOfYear, "DayOfWeekNumber", each Date.DayOfWeek([Date], startOfWeek), Int64.Type),
    add_DayOfWeekName = Table.AddColumn(add_DayOfWeekNumber, "DayOfWeekName", each Text.Proper(Date.DayOfWeekName([Date], language)), type text),
    add_DayOfWeekNameShort = Table.AddColumn(add_DayOfWeekName, "DayOfWeekNameShort", each Text.Start([DayOfWeekName], 3), type text),
    add_DayOfWeekNameInitials = Table.AddColumn(add_DayOfWeekNameShort, "DayOfWeekNameInitials", each Text.Repeat(zws, 7-[DayOfWeekNumber]) & Text.Start([DayOfWeekName], 1), type text),

    #"-----MONTH-----" = "",
    add_MonthNumber = Table.AddColumn(add_DayOfWeekNameInitials, "MonthNumber", each Date.Month([Date]), Int64.Type),
    add_MonthName = Table.AddColumn(add_MonthNumber, "MonthName", each Text.Proper(Date.MonthName([Date], language)), type text), 
    add_MonthNameShort = Table.AddColumn(add_MonthName, "MonthNameShort", each Text.Start([MonthName], 3), type text), 
    add_MonthNameInitials = Table.AddColumn(add_MonthNameShort, "MonthNameInitials", each Text.Repeat(zws, 12-[MonthNumber]) & Text.Start([MonthName], 1), type text),
    add_MonthYearName = Table.AddColumn(add_MonthNameInitials, "MonthYearName", each Text.Proper(Date.ToText([Date], [Format="MMM/yy", Culture=language])), type text),
    add_MonthYearNumber = Table.AddColumn(add_MonthYearName, "MonthYearNumber", each [Year] * 100 + [MonthNumber], Int64.Type),
    add_MonthDayNumber = Table.AddColumn(add_MonthYearNumber, "MonthDayNumber", each [MonthNumber] * 100 + [DayOfMonth], Int64.Type),
    add_MonthDayName = Table.AddColumn(add_MonthDayNumber, "MonthDayName", each [MonthNameShort] & " " & Text.From([DayOfMonth]), type text), 
    add_MonthStart = Table.AddColumn(add_MonthDayName, "MonthStart", each Date.StartOfMonth([Date]), type date),
    add_MonthEnd = Table.AddColumn(add_MonthStart, "MonthEnd", each Date.EndOfMonth([Date]), type date),
    add_MonthIndex = Table.AddColumn(add_MonthEnd, "MonthIndex", each 12 * ([Year]-Date.Year(startDate)) + [MonthNumber], Int64.Type),
    add_MonthsToToday = Table.AddColumn(add_MonthIndex, "MonthsToToday", each ([Year] * 12 - 1 + [MonthNumber]) - (currentYear * 12 - 1 + Date.Month(currentDate)), Int64.Type),
    add_CurrentMonthName = Table.AddColumn(add_MonthsToToday, "CurrentMonthName", each if currentMonth = [MonthNumber] then currentText else [MonthName], type text),
    add_CurrentMonthNameShort = Table.AddColumn(add_CurrentMonthName, "CurrentMonthNameShort", each if currentMonth = [MonthNumber] then currentText else [MonthNameShort], type text),
    add_CurrentMonthYearName = Table.AddColumn(add_CurrentMonthNameShort, "CurrentMonthYearName", each if [MonthsToToday] = 0 then currentText else [MonthYearName], type text),

    #"-----QUARTER-----" = "",
    add_QuarterNumber = Table.AddColumn(add_CurrentMonthYearName, "QuarterNumber", each Date.QuarterOfYear([Date]), Int64.Type), 
    add_QuarterName = Table.AddColumn(add_QuarterNumber, "QuarterName", each quarterPrefix & Text.From([QuarterNumber]), type text),
    add_QuarterYearName = Table.AddColumn(add_QuarterName, "QuarterYearName", each [QuarterName] & " " & Text.End(Text.From([Year]), 2), type text),
    add_QuarterYearNumber = Table.AddColumn(add_QuarterYearName, "QuarterYearNumber", each [Year] * 100 + [QuarterNumber], Int64.Type), 
    add_QuarterStart = Table.AddColumn(add_QuarterYearNumber, "QuarterStart", each Date.StartOfQuarter([Date]), type date),
    add_QuarterEnd = Table.AddColumn(add_QuarterStart, "QuarterEnd", each Date.EndOfQuarter([Date]), type date),
    add_QuarterIndex = Table.AddColumn(add_QuarterEnd, "QuarterIndex", each 4 * ([Year] - Date.Year(startDate)) + [QuarterNumber], Int64.Type),
    add_QuartersToToday = Table.AddColumn(add_QuarterIndex, "QuartersToToday", each ([Year] * 4 - 1 + [QuarterNumber]) - (currentYear * 4 - 1 + Date.QuarterOfYear(currentDate)), Int64.Type),
    add_CurrentQuarter = Table.AddColumn(add_QuartersToToday, "CurrentQuarter", each if Date.QuarterOfYear(currentDate) = [QuarterNumber] then currentText else [QuarterName], type text),
    add_CurrentQuarterYear = Table.AddColumn(add_CurrentQuarter, "CurrentQuarterYear", each if [QuartersToToday] = 0 then currentText else [QuarterYearName], type text),
    add_MonthOfQuarterNumber = Table.AddColumn(add_CurrentQuarterYear, "MonthOfQuarterNumber", each Number.Mod([MonthNumber] - 1, 3) + 1, Int64.Type),

    #"-----WEEK-----" = "",
    add_WeekOfYearNumberISO = Table.AddColumn(
        add_MonthOfQuarterNumber, 
        "WeekOfYearNumberISO", 
        each let
            thursdayInWeek = Date.AddDays(
                [Date],
                3 - Date.DayOfWeek([Date], Day.Monday)
            ),
            startYearThursdayInWeek = #date(Date.Year(thursdayInWeek), 1, 1),
            diffDays = Duration.Days(thursdayInWeek - startYearThursdayInWeek)
        in
            Number.IntegerDivide(diffDays, 7, 0) + 1,
        Int64.Type
    ),

    add_YearISO = Table.AddColumn(add_WeekOfYearNumberISO, "YearISO", each Date.Year(Date.AddDays([Date], 26 - [WeekOfYearNumberISO])), Int64.Type),
    add_WeekYearNumberISO = Table.AddColumn(add_YearISO, "WeekYearNumberISO", each [YearISO] * 100 + [WeekOfYearNumberISO], Int64.Type),
    add_WeekYearNameISO = Table.AddColumn(add_WeekYearNumberISO, "WeekYearNameISO", each weekPrefix & Text.PadStart(Text.From([WeekOfYearNumberISO]), 2, "0") & " " & Text.From([YearISO]), type text),
    add_WeekStartISO = Table.AddColumn(add_WeekYearNameISO, "WeekStartISO", each Date.StartOfWeek([Date], Day.Monday), type date), 
    add_WeekEndISO = Table.AddColumn(add_WeekStartISO, "WeekEndISO", each Date.EndOfWeek([Date], Day.Monday), type date), 
    add_WeekIndexISO = Table.AddColumn(add_WeekEndISO, "WeekIndexISO", each Number.From([WeekStartISO] - Date.StartOfWeek(startDate, Day.Monday)) / 7 + 1, Int64.Type),
    add_WeeksToTodayISO = Table.AddColumn(add_WeekIndexISO, "WeeksToTodayISO", each Number.From([WeekStartISO] - Date.StartOfWeek(currentDate, Day.Monday)) / 7, Int64.Type),
    add_CurrentWeekISO = Table.AddColumn(add_WeeksToTodayISO, "CurrentWeekISO", each if [WeeksToTodayISO] = 0 then currentText else [WeekYearNameISO], type text),
    add_WeekPeriodName = Table.AddColumn(add_CurrentWeekISO, "WeekPeriodName", each [WeekYearNameISO] & ": " & Date.ToText([WeekStartISO], [Format="dd/MM/yyyy"]) & "~" & Date.ToText([WeekEndISO], [Format="dd/MM/yyyy"]), type text),
    add_WeekOfMonthNumber = Table.AddColumn(add_WeekPeriodName, "WeekOfMonthNumber", each Date.WeekOfMonth([Date], startOfWeek), Int64.Type),
    
    #"-----HALF-----" = "",
    add_HalfNumber = Table.AddColumn(add_WeekOfMonthNumber, "HalfNumber", each if [MonthNumber] <= 6 then 1 else 2, Int64.Type),
    add_HalfYearName = Table.AddColumn(add_HalfNumber, "HalfYearName", each halfPrefix & Text.From([HalfNumber]) & " " & Text.From([Year]), type text),
    add_HalfYearNumber = Table.AddColumn(add_HalfYearName, "HalfYearNumber", each [Year] * 100 + [HalfNumber], Int64.Type),
    add_HalfIndex = Table.AddColumn(add_HalfYearNumber, "HalfIndex", each (2*([Year] - Date.Year(startDate))) + [HalfNumber], Int64.Type),
    add_HalfsToToday = Table.AddColumn(add_HalfIndex, "HalfsToToday", each [HalfIndex] - ( 2 * ( currentYear - startYear ) + ( if currentMonth <= 6 then 1 else 2 )), Int64.Type),
    add_CurrentHalf = Table.AddColumn(add_HalfsToToday, "CurrentHalf", each if [HalfsToToday] = 0 then currentText else [HalfYearName], type text), 

    #"-----BIMESTER-----" = "",
    add_BimesterNumber = Table.AddColumn(add_CurrentHalf, "BimesterNumber", each Number.RoundUp([MonthNumber]/ 2), Int64.Type),
    add_BimesterYearName = Table.AddColumn(add_BimesterNumber, "BimesterYearName", each bimesterPrefix & Text.From([BimesterNumber]) & " " & Text.From([Year]), type text),
    add_BimesterYearNumber = Table.AddColumn(add_BimesterYearName, "BimesterYearNumber", each [Year] * 100 + [BimesterNumber], Int64.Type),
    add_BimesterIndex = Table.AddColumn(add_BimesterYearNumber, "BimesterIndex", each (6*([Year] - Date.Year(startDate))) + [BimesterNumber], Int64.Type),
    add_BimestersToToday = Table.AddColumn(add_BimesterIndex, "BimestersToToday", each ( 6 * ( [Year] - startYear ) + [BimesterNumber])  - (( 6 * ( currentYear - startYear ) ) + Number.RoundUp ( currentMonth / 2, 0 )), Int64.Type),
    add_CurrentBimester = Table.AddColumn(add_BimestersToToday, "CurrentBimester", each if [BimestersToToday] = 0 then currentText else [BimesterYearName], type text),

    #"-----FORTNIGHT-----" = "",
    add_FortnightOfMonthNumber = Table.AddColumn(add_CurrentBimester, "FortnightOfMonthNumber", each if [DayOfMonth] <= 15 then 1 else 2, Int64.Type),
    add_FortnightMonthNumber = Table.AddColumn(add_FortnightOfMonthNumber, "FortnightMonthNumber", each [MonthNumber] * 10 + [FortnightOfMonthNumber], Int64.Type),
    add_FortnightMonthName = Table.AddColumn(add_FortnightMonthNumber, "FortnightMonthName", each [MonthNameShort] & " " & Text.From([FortnightOfMonthNumber]), type text),
    add_FortnightMonthYearNumber = Table.AddColumn(add_FortnightMonthName, "FortnightMonthYearNumber", each [Year] * 10000 + [MonthNumber] * 100 + [FortnightMonthNumber], Int64.Type),
    add_FortnightMonthYearName = Table.AddColumn(add_FortnightMonthYearNumber, "FortnightMonthYearName", each fortnightPrefix & Text.From([FortnightOfMonthNumber]) & " " & [MonthNameShort] & " " & Text.From([Year]), type text),
    add_FortnightIndex = Table.AddColumn(add_FortnightMonthYearName, "FortnightIndex", each 24 * ([Year] - Date.Year(startDate)) + 2 * ([MonthNumber]-Date.Month(startDate)) + [FortnightOfMonthNumber] , Int64.Type),
    add_FortnightsToToday = Table.AddColumn(add_FortnightIndex, "FortnightsToToday", each [FortnightIndex] - ( (24 * (currentYear - Date.Year(startDate))) + (2 * (Date.Month(currentDate)-Date.Month(startDate))) + (if Date.Day(currentDate) <= 15 then 1 else 2)), Int64.Type),
    add_CurrentFortnight = Table.AddColumn(add_FortnightsToToday, "CurrentFortnight", each if [FortnightsToToday] = 0 then currentText else [FortnightMonthName], type text),
    
    #"-----CLOSING-----" = "",
    add_ClosingDateRef = Table.AddColumn(add_CurrentFortnight, "ClosingDateRef", each if [DayOfMonth] <= closingMonthStartDay then [Date] else Date.AddMonths([Date], 1), type date),
    add_ClosingYear = Table.AddColumn(add_ClosingDateRef, "ClosingYear", each Date.Year([ClosingDateRef]), Int64.Type),
    add_ClosingMonthName = Table.AddColumn(add_ClosingYear, "ClosingMonthName", each Text.Proper(Date.MonthName([ClosingDateRef], language)), type text),
    add_ClosingMonthNameShort = Table.AddColumn(add_ClosingMonthName, "ClosingMonthNameShort", each Text.Start([ClosingMonthName], 3), type text), 
    add_ClosingMonthNumber = Table.AddColumn(add_ClosingMonthNameShort, "ClosingMonthNumber", each Date.Month([ClosingDateRef]), Int64.Type),
    add_ClosingMonthYearName = Table.AddColumn(add_ClosingMonthNumber, "ClosingMonthYearName", each [ClosingMonthNameShort] & "/" & Text.End(Text.From([ClosingYear]), 2), type text), 
    add_ClosingMonthYearNumber = Table.AddColumn(add_ClosingMonthYearName, "ClosingMonthYearNumber", each [ClosingYear] * 100 + [ClosingMonthNumber], Int64.Type),

    #"-----SEASONS-----" = "",
    add_SeasonNorthNumber = Table.AddColumn(
        add_ClosingMonthYearNumber, 
        "SeasonNorthNumber", 
        each if [MonthDayNumber] >= 321 and [MonthDayNumber] <= 620  then 1 else 
             if [MonthDayNumber] >= 621 and [MonthDayNumber] <= 921  then 2 else 
             if [MonthDayNumber] >= 922 and [MonthDayNumber] <= 1221 then 3 else 4,
        Int64.Type
    ),

    add_SeasonNorthName = Table.AddColumn(
        add_SeasonNorthNumber, 
        "SeasonNorthName", 
        each if [SeasonNorthNumber] = 1 then springText else 
             if [SeasonNorthNumber] = 2 then summerText else 
             if [SeasonNorthNumber] = 3 then autumnText else winterText, 
        type text
    ),

    add_SeasonSouthNumber = Table.AddColumn(
        add_SeasonNorthName, 
        "SeasonSouthNumber", 
        each if [MonthDayNumber] >= 321 and [MonthDayNumber] <= 620  then 1 else 
             if [MonthDayNumber] >= 621 and [MonthDayNumber] <= 921  then 2 else 
             if [MonthDayNumber] >= 922 and [MonthDayNumber] <= 1221 then 3 else 4,
        Int64.Type
    ),

    add_SeasonSouthName = Table.AddColumn(
        add_SeasonSouthNumber, 
        "SeasonSouthName", 
        each if [SeasonNorthNumber] = 1 then autumnText else 
             if [SeasonNorthNumber] = 2 then winterText else 
             if [SeasonNorthNumber] = 3 then springText else summerText, 
        type text
    ),

    #"-----BUSINESS-----" = "",
    add_Holiday = Table.RenameColumns(Table.RemoveColumns(Table.Join(add_SeasonSouthName, "Date", Table.PrefixColumns(holidays, "h"), "h.Date", JoinKind.LeftOuter, JoinAlgorithm.LeftIndex), "h.Date"), {{"h.Holiday", "Holiday"}}),
    add_BusinessDayNumber = Table.AddColumn(add_Holiday, "BusinessDayNumber", each if [Holiday] <> null or Date.DayOfWeek([Date], Day.Monday) > 4 then 0 else 1, Int64.Type),
    add_BusinessDayName = Table.AddColumn(add_BusinessDayNumber, "BusinessDayName", each if [BusinessDayNumber] = 1 then businessDayText else nonBusinessDayText, type text),


    #"-----FISCAL COLUMNS-----" = "", 
    #"-----FISCAL YEAR-----" = "", 
    add_FiscalYearStartNumber = Table.AddColumn(add_BusinessDayName, "FiscalYearStartNumber", each Date.Year(Date.AddMonths([Date], 12 - monthOfFiscalYearEnd)), Int64.Type),
    add_FiscalYearEndNumber = Table.AddColumn(add_FiscalYearStartNumber, "FiscalYearEndNumber", each [FiscalYearStartNumber] + 1, Int64.Type),
    add_FiscalYear = Table.AddColumn(add_FiscalYearEndNumber, "FiscalYear", each "FY " & Text.From([FiscalYearStartNumber]) & "-" &Text.From([FiscalYearEndNumber]), type text),
    add_FiscalYearStart = Table.AddColumn( add_FiscalYear, "FiscalYearStart", each #date( [FiscalYearStartNumber], if monthOfFiscalYearEnd = 12 then 1 else  monthOfFiscalYearEnd + 1 , 1), type date ),
    add_FiscalYearEnd = Table.AddColumn( add_FiscalYearStart, "FiscalYearEnd", each Date.EndOfMonth(#date([FiscalYearEndNumber], monthOfFiscalYearEnd, 1)), type date),
    add_CurrentFiscalYear = Table.AddColumn(add_FiscalYearEnd, "CurrentFiscalYear", each if [FiscalYearStartNumber] = currentFiscalYear then currentText else [FiscalYear], type text),
    add_FiscalYearsToToday = Table.AddColumn(add_CurrentFiscalYear, "FiscalYearsToToday", each [FiscalYearStartNumber] - currentFiscalYear, Int64.Type),
    
    #"-----FISCAL MONTH-----" = "", 
    add_FiscalMonthNumber = Table.AddColumn(add_FiscalYearsToToday, "FiscalMonthNumber", each Date.Month( Date.AddMonths([Date], - monthOfFiscalYearEnd ) ), Int64.Type),
    add_FiscalMonthName = Table.AddColumn( add_FiscalMonthNumber, "FiscalMonthName", each Text.Proper(Date.ToText([Date], [Format="MMMM", Culture = language])), type text ),
    add_FiscalMonthNameShort = Table.AddColumn(add_FiscalMonthName, "FiscalMonthNameShort", each Text.Start([FiscalMonthName], 3), type text),
    add_CurrentFiscalMonth = Table.AddColumn( add_FiscalMonthNameShort, "CurrentFiscalMonth", each if Date.IsInCurrentMonth([Date]) then currentText else [FiscalMonthName], Text.Type),
    add_FiscalYearMonthName = Table.AddColumn(add_CurrentFiscalMonth, "FiscalYearMonthName", each [FiscalMonthNameShort] & " " & [FiscalYear], type text),
    add_FiscalYearMonthNumber = Table.AddColumn( add_FiscalYearMonthName, "FiscalYearMonthNumber", each [FiscalYearStartNumber] * 100 + [FiscalMonthNumber], Int64.Type ),
    add_FiscalYearMonthCurrent = Table.AddColumn( add_FiscalYearMonthNumber, "FiscalYearMonthCurrent", each if [CurrentFiscalYear] = currentText and [CurrentFiscalMonth] = currentText then currentText else [FiscalYearMonthName], type text),
    add_FiscalMonthsToToday = Table.AddColumn(add_FiscalYearMonthCurrent, "FiscalMonthsToToday", each [ CurrentFiscalMonth = Date.Month( Date.AddMonths( currentDate, - monthOfFiscalYearEnd ) ), FiscalQuartersToToday = (([FiscalYearStartNumber] - currentFiscalYear) * 12) + ([FiscalMonthNumber] - CurrentFiscalMonth)][FiscalQuartersToToday], Int64.Type ),
    
    #"-----FISCAL QUARTER-----" = "", 
    add_FiscalQuarterNumber = Table.AddColumn(add_FiscalMonthsToToday, "FiscalQuarterNumber", each Number.RoundUp( [FiscalMonthNumber] / 3), Int64.Type),
    add_FiscalQuarterName = Table.AddColumn(add_FiscalQuarterNumber, "FiscalQuarterName", each "FQ " & Text.From([FiscalQuarterNumber]), Text.Type),
    add_FiscalMonthOfQuarterNumber = Table.AddColumn(add_FiscalQuarterName, "FiscalMonthOfQuarterNumber", each [FiscalMonthNumber] - 3 * ([FiscalQuarterNumber] - 1) , Int64.Type ),
    add_FiscalYearQuarterName = Table.AddColumn(add_FiscalMonthOfQuarterNumber, "FiscalYearQuarterName", each [FiscalQuarterName] & " | " & [FiscalYear], type text),
    add_FiscalYearQuarterNumber = Table.AddColumn(add_FiscalYearQuarterName, "FiscalYearQuarterNumber", each [FiscalYearStartNumber] * 100 + [FiscalQuarterNumber], Int64.Type),
    add_FiscalQuarterStart = Table.AddColumn(add_FiscalYearQuarterNumber, "FiscalQuarterStart", each Date.StartOfMonth( Date.AddMonths( [Date] , 1-[FiscalMonthOfQuarterNumber] )), Date.Type),
    add_FiscalQuarterEnd = Table.AddColumn(add_FiscalQuarterStart, "FiscalQuarterEnd", each Date.EndOfMonth( Date.AddMonths( [Date] , 3-[FiscalMonthOfQuarterNumber] )), Date.Type),
    add_FiscalQuartersToToday = Table.AddColumn(
        add_FiscalQuarterEnd, 
        "FiscalQuartersToToday", 
        each [
            CurrentFiscalMonth = Date.Month(Date.AddMonths(currentDate, - monthOfFiscalYearEnd)),  
            CurrentFiscalQuarter = Number.RoundUp(CurrentFiscalMonth / 3),
            FiscalQuartersToToday = (([FiscalYearStartNumber] - currentFiscalYear) * 4) + ([FiscalQuarterNumber] - CurrentFiscalQuarter)
        ][FiscalQuartersToToday], 
        Int64.Type 
    ),
    add_CurrentFiscalQuarter = Table.AddColumn(add_FiscalQuartersToToday, "CurrentFiscalQuarter", each if [FiscalQuartersToToday] = 0 then currentText else [FiscalYearQuarterName], type text),
    add_DayOfFiscalQuarter = Table.AddColumn(add_CurrentFiscalQuarter, "DayOfFiscalQuarter", each Number.From( [Date] - [FiscalQuarterStart] ) + 1, Int64.Type ),

    #"-----RENAME COLUMNS----" = "",
    columnNamesDictionary = Table.FromRows(Json.Document(Binary.Decompress(Binary.FromText("jVjbbtw4DP2XPPcnMpkGCdAm7U6KYlHkQXGUxrseC7A9xWa/fnUjeURx0n2ZkY54aIo6omz9+HGxd5u/+JD+XPy79sOru3j8UPDb+dn/Uwdjexw8mdReMXxbH8JDeHZvyXR06xe3uJvwl6/dG7dusf+Wra9Oy+LnDZ56uZ3cRH4vh9xLln96t0T4cg71l8DD5patYLfzOIyhaZPVx/m54NfjkRozj9LMMq9OTNpktffr4CM0/7xzx2qy98OS4c3fBQGzYQWfFtPF6fjkl97J6eiXAPAwAkxuIMPRDjOculaGJX2U4NSU9MZlu3/5HObttSzTPnz2a236KbXZqrrKRmU5ihEtSjb67v3fPMU07g7+6GbH88ucTy3askuOkRsYEabkt2EeXkNWhaJfRuNfo3vuI8h+riLJCCNqaRvdtPb+ssrcuNruyuhUk5ezyzmJKeVcSFvsyuzTSIAWzZVtaJ7VEOfHDJkV02BGlQkzYaIRf1p8iS0uuYRXOk2E2RpmnExg0tJlRsw7EmJSkSDdhsDxpPHQdpp4qFbEUa4V0mazUiziQCkWuTHLMFWLzKzVQtpsBps0jnrcpblvbVO19nmvQoaH2qdJaRaogalKEuhDhIGOuiXWUVDhgEC+nmJivaz1wzIe/botUs80gqzyMLEIRh/sIUC2ESUqSEXYKLIx7QJt1Vn5pCC2Yh1pBEhFT2xQVAXdGY1JXeCvaqwiHoRWOSA1pqHeBLREV500c6+HhAByVLSsehpg1npyc9Rkkd2/aMmkHRt63STYT5Z6UnUup1HxcXu4j/al/uaTqdg2cD6lBOfzP9ukEx8b9BD7EeYDOu/MT0VXGQYLSmUXuFlvaFXUZSNEinpDg6i3tjujcdZb6y/JC5GRESKR4NCKBdeAJDhiV/XkJ+PkkzwaYCCEnvnFL2N4rhu/GBWIdr7GaOsXobTHL8kEj2HWSHse37jpBXmtPhVABKhRZCElqkUoTKbpZ2F16jGiUt0gCy4bCiB7qBlkgSWDMatiJD4GUzc892Wz70rJkknt9Abf9TubSJDEXVfnd2aZb6j6mZjIHkM6JXOna7ACkAMJ3Rk1ePdeCSYfGFhN6q6vwNfx3J7Hn6+bVvXX0zj/67WuEzp4Q9nsx/Zi+XjXQVkqpAdGBkZoqVpys2DgAtcM/LTLZrjqYhHlKDdGRLT8ROflJyosP5Ng/YmH609Uc/3ZCZBJAETEI3gKa/yGTJ/Nf/i0E9OX897nb+ZjdBcKmvt7fzX6+JAEAVc+CIVV+sUcbdVbqRDkpbCQ8NVUUeHVtOWr91N0BO+n6A3eGMAVvDBUH6IPpHevt9Z0OA1nZmR82NihiCOJ5uDdGua7ODmZy8eoicGFBEppNEDNLxNpDIMF0SQK9xBO/bMPp0k/WSDNbZ6bzEIP8MEWprHsi+t4NvPH93Usa+OvWndPMbV+XfHzL5p820aJKfY/uaewuKepOSyAylcGmcjXBUKDvT6ug5v4AgmvY8pQ/fjFCxlroPUV37x6T/GFy/KDcOsFrUr7pbSNwLvI+liNINs4jiqspjKZUcElUgXgdGKGuqbKA6O+rSrm6lgsYL/dM4z7q0E0UypWsQpdv1WDWayYqgoV+ug+pMEfWlPaBLDSpi8BKMdNeTozBeGr6tRlToOGjzoZZQ+TOL/85g1ILwCBbQWcvVdQ87Hx3o+6NWjy2qOGOn733drnGb9e30l4G2FMrB2kOdBLQAdp0KAe/c/sdXcfquoQnmqIWXzOXYdIFerAuaeblx29tNSY1lezUY0bkFbrGlYX59pLvhtXnAu6J9f44+N/", BinaryEncoding.Base64), Compression.Deflate)), let _t = ((type nullable text) meta [Serialized.Text = true]) in type table [#"en-US" = _t, #"pt-BR" = _t, #"es-ES" = _t]),
    
    fromToColumnNames = if language <> "en-US" then List.Zip(Table.ToColumns(Table.SelectColumns(columnNamesDictionary, {"en-US", language}))) else null,
    renamedColumns = if language <> "en-US" then Table.RenameColumns(add_DayOfFiscalQuarter, fromToColumnNames) else add_DayOfFiscalQuarter
in
    renamedColumns