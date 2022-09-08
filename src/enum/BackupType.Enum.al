enum 50100 "Backup Type" implements Backup
{
    Extensible = true;

    value(0; CSV)
    {
        Caption = 'csv';
        Implementation = Backup = "Backup CSV";
    }
    value(1; XLSX)
    {
        Caption = 'xlsx';
        Implementation = Backup = "Backup XLSX";
    }
    value(2; JSON)
    {
        Caption = 'json';
        Implementation = Backup = "Backup JSON";
    }
    value(3; XML)
    {
        Caption = 'xml';
        Implementation = Backup = "Backup XML";
    }
}