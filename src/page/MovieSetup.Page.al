page 50105 "Movie Setup"
{
    Caption = 'Movie Setup';
    PageType = Card;
    SourceTable = "Movie Setup";
    ApplicationArea = All;
    UsageCategory = Administration;
    InsertAllowed = false;
    DeleteAllowed = false;

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field("Backup Type"; Rec."Backup Type")
                {
                    ToolTip = 'Specifies the value of the Backup Type field.';
                    ApplicationArea = All;
                    Caption = 'Backup Type';
                }
            }
        }
    }

    trigger OnOpenPage()
    begin
        if not Rec.Get() then begin
            Rec.Init();
            Rec.Insert();
        end;
    end;
}
