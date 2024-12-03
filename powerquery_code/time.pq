let

    #"-----PARAMETERS-----" = "",

    // Available: en-US, pt-BR, es-ES
    language = "en-US",

    #"-----INTERNAL USE-----" = "",

    // The table with auxiliary texts cross the languages
    auxiliaryPeriodTable = Table.UnpivotOtherColumns(
        #table(
            type table [Class=text, #"en-US"=text, #"pt-BR"=text, #"es-ES"=text],
            {
                  { "Dawn"     , "Dawn"     , "Madrugada", "Madrugada" }
                , { "Morning"  , "Morning"  , "Manhã"    , "Mañana"    }
                , { "Afternoon", "Afternoon", "Tarde"    , "Tarde"     }
                , { "Night"    , "Night"    , "Noite"    , "Noche"     }
            }
        ),
        {"Class"}, "Language", "Value"
    ),

    // Filtered table on selected language
    filteredAuxiliaryTableOnLanguage = Table.SelectRows(auxiliaryPeriodTable, each [Language] = language),

    // Texts on language
   dawn = filteredAuxiliaryTableOnLanguage{[Class="Dawn"]}[Value],
   morning = filteredAuxiliaryTableOnLanguage{[Class="Morning"]}[Value],
   afternoon = filteredAuxiliaryTableOnLanguage{[Class="Afternoon"]}[Value],
   night = filteredAuxiliaryTableOnLanguage{[Class="Night"]}[Value],

    // Special character to sort periods of the day
    zws = Character.FromNumber(8203),


    #"-----GENERATING DATA-----" = "",
    
    // List of indexes from 0 to 86399 (24 hours)
    indexesList = {0..86399},

    // Table with indexes
    initialTable = Table.FromList(indexesList, Splitter.SplitByNothing(), type table [Index = Int64.Type]),

    // Add column with time
    add_Time = Table.AddColumn(initialTable, "Time", each #time(0, 0, 0) + #duration(0, 0, 0, [Index]), type time),
    add_Time12 = Table.AddColumn(add_Time, "Time12", each Time.ToText([Time], [Format = "hh:mm:ss tt", Culture = "en-US"]), type text),
    add_Hour = Table.AddColumn(add_Time12, "Hour", each Time.Hour([Time]), Int64.Type),
    add_Minute = Table.AddColumn(add_Hour, "Minute", each Time.Minute([Time]), Int64.Type),
    add_Second = Table.AddColumn(add_Minute, "Second", each Time.Second([Time]), Int64.Type),
    add_HourStart = Table.AddColumn(add_Second, "HourStart", each Time.StartOfHour([Time]), type time),
    add_MinuteStart = Table.AddColumn(add_HourStart, "MinuteStart", each #time([Hour], [Minute], 0), type time),
    add_DayPeriod = Table.AddColumn(
        add_MinuteStart, 
        "DayPeriod", 
        each if [Hour] < 6 then Text.Repeat(zws, 3) & dawn 
            else if [Hour] < 12 then Text.Repeat(zws, 2) & morning
            else if [Hour] < 18 then Text.Repeat(zws, 1) & afternoon 
            else night  
        , type text
    ),

    add_Shift = Table.AddColumn(
        add_DayPeriod,
        "ShiftNumber",
        each if [Time] >= #time( 5,  0, 0) and [Time] <= #time(13, 29, 59) then 1 else
             if [Time] >= #time(11, 30, 0) and [Time] <= #time(21, 59, 59) then 2 else
             if [Time] >= #time(22, 00, 0) or  [Time] <= #time( 4, 59, 59) then 3 else null,
        Int64.Type
    ),

    transformTimeToText = Table.TransformColumns(add_Shift,{
        {"Time", each Time.ToText(_,"hh:mm:ss"), type text},
        {"HourStart", each Time.ToText(_,"hh:mm:ss"), type text},
        {"MinuteStart", each Time.ToText(_,"hh:mm:ss"), type text}
    }),

    #"-----RENAME COLUMNS-----" = "",

    columnNamesDictionary = Table.FromRows(Json.Document(Binary.Decompress(Binary.FromText("ZY/BCsIwDIbfpeddtmfoYQMVobuNHeoWXcA1UFrQt7dZW1r1lC9/fvIn0yQGs8JLNFxxgQJzM4kRd1Z6stoiVZSHbVfEttu+Gzb15G1Sc2H5jMY7Xn0AFeChgoXMGjQFD29WqiivVE5blxYOBpfjuAgSTvonJ7tjxp//WWVL/b5CuJ/jJerIbE4U3EGOZ254dxe/34A/HL01FDqw7I4QzIcs5vkD", BinaryEncoding.Base64), Compression.Deflate)), let _t = ((type nullable text) meta [Serialized.Text = true]) in type table [#"en-US" = _t, #"pt-BR" = _t, #"es-ES" = _t]),
    
    fromToColumnNames = if language <> "en-US" then List.Zip(Table.ToColumns(Table.SelectColumns(columnNamesDictionary, {"en-US", language}))) else null,
    renamedTable = if language <> "en-US" then Table.RenameColumns(transformTimeToText, fromToColumnNames) else add_Shift
in
    renamedTable
