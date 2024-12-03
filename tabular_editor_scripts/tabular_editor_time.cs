// Access the table
var time_table = Model.Tables["Time"];

// Disable aggregations for all columns in the table
foreach (var column in time_table.Columns)
{
    column.SummarizeBy = AggregateFunction.None;
};