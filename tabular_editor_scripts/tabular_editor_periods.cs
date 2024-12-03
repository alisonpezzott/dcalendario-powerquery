// This script performs the following operations:
// 1. Sorts text columns by their corresponding numeric columns
// 2. Applies the short date format to date-type columns
// 3. Removes aggregations from numeric columns
// 4. Creates a relationship between periods_table and calendar_table

// Variables
var calendar_table = Model.Tables["Calendar"];
var periods_table = Model.Tables["Periods"];

// Available: en-US, pt-BR, es-ES
var language = "en-US";

if (language == "en-US")
{

    // Create a mapping of text columns and their respective numeric columns for sorting
    var columnPairs = new Dictionary<string, string>
    {
        {"Period", "PeriodOrdinal"},
        {"PeriodGroup", "PeriodGroupOrdinal"}
    };

    // Apply sorting for each text column
    foreach (var pair in columnPairs)
    {
        var textColumn = periods_table.Columns[pair.Key];  // Text column
        var sortColumn = periods_table.Columns[pair.Value];  // Corresponding numeric column

        // Check if both columns exist and apply sorting
        if (textColumn != null && sortColumn != null)
        {
            textColumn.SortByColumn = sortColumn;  // Sort text column by numeric column
        }
    }

    // Disable aggregations for all columns in the table
    foreach (var column in periods_table.Columns)
    {
        column.SummarizeBy = AggregateFunction.None;  // Disable aggregation
    }

    // Set the format for date-type columns
    var dateColumns = new[] { "Date" };  // Columns that contain dates
    foreach (var columnName in dateColumns)
    {
        var column = periods_table.Columns[columnName];
        if (column != null)
        {
            column.FormatString = "Short Date";  // Apply short date format
        }
    }

    // Define the columns involved in the relationship
    var fromColumn = calendar_table.Columns["Date"];
    var toColumn = periods_table.Columns["Date"];

    // Check if the relationship already exists
    if (!Model.Relationships.Any(r => r.FromColumn == fromColumn && r.ToColumn == toColumn))
    {
        // Create a new relationship
        var rel = Model.AddRelationship();
            rel.FromColumn = fromColumn;  // Source column
            rel.ToColumn = toColumn;      // Target column

        // Set cross-filtering behavior to one-directional
        rel.CrossFilteringBehavior = CrossFilteringBehavior.OneDirection;
        
        // Set cardinality to many-to-many
        rel.FromCardinality = RelationshipEndCardinality.Many;
        rel.ToCardinality = RelationshipEndCardinality.Many;
        
        // Activate the relationship
        rel.IsActive = true;
    }
}

if (language == "pt-BR")
{

    // Create a mapping of text columns and their respective numeric columns for sorting
    var columnPairs = new Dictionary<string, string>
    {
        {"Periodo", "PeriodoOrdinal"},
        {"PeriodoGrupo", "PeriodoGrupoOrdinal"}
    };

    // Apply sorting for each text column
    foreach (var pair in columnPairs)
    {
        var textColumn = periods_table.Columns[pair.Key];  // Text column
        var sortColumn = periods_table.Columns[pair.Value];  // Corresponding numeric column

        // Check if both columns exist and apply sorting
        if (textColumn != null && sortColumn != null)
        {
            textColumn.SortByColumn = sortColumn;  // Sort text column by numeric column
        }
    }

    // Disable aggregations for all columns in the table
    foreach (var column in periods_table.Columns)
    {
        column.SummarizeBy = AggregateFunction.None;  // Disable aggregation
    }

    // Set the format for date-type columns
    var dateColumns = new[] { "Data" };  // Columns that contain dates
    foreach (var columnName in dateColumns)
    {
        var column = periods_table.Columns[columnName];
        if (column != null)
        {
            column.FormatString = "Short Date";  // Apply short date format
        }
    }

    // Define the columns involved in the relationship
    var fromColumn = calendar_table.Columns["Data"];
    var toColumn = periods_table.Columns["Data"];

    // Check if the relationship already exists
    if (!Model.Relationships.Any(r => r.FromColumn == fromColumn && r.ToColumn == toColumn))
    {
        // Create a new relationship
        var rel = Model.AddRelationship();
            rel.FromColumn = fromColumn;  // Source column
            rel.ToColumn = toColumn;      // Target column

        // Set cross-filtering behavior to one-directional
        rel.CrossFilteringBehavior = CrossFilteringBehavior.OneDirection;
        
        // Set cardinality to many-to-many
        rel.FromCardinality = RelationshipEndCardinality.Many;
        rel.ToCardinality = RelationshipEndCardinality.Many;
        
        // Activate the relationship
        rel.IsActive = true;
    }
}

if (language == "es-ES")
{

    // Create a mapping of text columns and their respective numeric columns for sorting
    var columnPairs = new Dictionary<string, string>
    {
        {"Periodo", "PeriodoOrdinal"},
        {"GrupoDelPeriodo", "GrupoDelPeriodoOrdinal"}
    };

    // Apply sorting for each text column
    foreach (var pair in columnPairs)
    {
        var textColumn = periods_table.Columns[pair.Key];  // Text column
        var sortColumn = periods_table.Columns[pair.Value];  // Corresponding numeric column

        // Check if both columns exist and apply sorting
        if (textColumn != null && sortColumn != null)
        {
            textColumn.SortByColumn = sortColumn;  // Sort text column by numeric column
        }
    }

    // Disable aggregations for all columns in the table
    foreach (var column in periods_table.Columns)
    {
        column.SummarizeBy = AggregateFunction.None;  // Disable aggregation
    }

    // Set the format for date-type columns
    var dateColumns = new[] { "Fecha" };  // Columns that contain dates
    foreach (var columnName in dateColumns)
    {
        var column = periods_table.Columns[columnName];
        if (column != null)
        {
            column.FormatString = "Short Date";  // Apply short date format
        }
    }

    // Define the columns involved in the relationship
    var fromColumn = calendar_table.Columns["Fecha"];
    var toColumn = periods_table.Columns["Fecha"];

    // Check if the relationship already exists
    if (!Model.Relationships.Any(r => r.FromColumn == fromColumn && r.ToColumn == toColumn))
    {
        // Create a new relationship
        var rel = Model.AddRelationship();
            rel.FromColumn = fromColumn;  // Source column
            rel.ToColumn = toColumn;      // Target column

        // Set cross-filtering behavior to one-directional
        rel.CrossFilteringBehavior = CrossFilteringBehavior.OneDirection;
        
        // Set cardinality to many-to-many
        rel.FromCardinality = RelationshipEndCardinality.Many;
        rel.ToCardinality = RelationshipEndCardinality.Many;
        
        // Activate the relationship
        rel.IsActive = true;
    }
}