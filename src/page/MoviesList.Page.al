page 50100 "Movies List"
{
    ApplicationArea = All;
    Caption = 'Movies List';
    PageType = List;
    SourceTable = Movie;
    UsageCategory = Lists;
    CardPageId = "Movies Card";
    Editable = false;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                Caption = 'General';
                field("No."; Rec."No.")
                {
                    ToolTip = 'Specifies the value of the No. field.';
                    ApplicationArea = All;
                    Caption = 'No.';
                }
                field(Title; Rec.Title)
                {
                    ToolTip = 'Specifies the value of the Title field.';
                    ApplicationArea = All;
                    Caption = 'Title';
                }
                field(Description; Rec.Description)
                {
                    ToolTip = 'Specifies the value of the Description field.';
                    ApplicationArea = All;
                    Caption = 'Description';
                }
                field(Year; Rec.Year)
                {
                    ToolTip = 'Specifies the value of the Year field.';
                    ApplicationArea = All;
                    Caption = 'Year';
                }
                field(Genre; Rec.Genre)
                {
                    ToolTip = 'Specifies the value of the Genre field.';
                    ApplicationArea = All;
                    Caption = 'Genre';
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(Search)
            {
                Caption = 'Search on OMDb';
                Image = Find;
                ApplicationArea = all;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                ToolTip = 'Executes the Search on OMDb action.';

                trigger OnAction()
                begin
                    Clear(MovieDetails);

                    if MovieDetails.RunModal() = Action::OK then begin
                        MovieTitle := MovieDetails.GetMovieTitle();
                        if MovieTitle = '' then
                            exit;

                        MoviesMgt.RetrieveMoviesFromOMDb(MovieTitle);
                    end;
                end;
            }

            action(Backup)
            {
                Caption = 'Backup Movies';
                Image = ExportDatabase;
                ApplicationArea = all;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                ToolTip = 'Executes the Backup Movies action.';

                trigger OnAction()
                begin
                    BackupMovies();
                end;
            }
        }
    }

    var
        MoviesMgt: Codeunit "Movies Mgt";
        MovieDetails: Page "Get Movie Details";
        MovieTitle: Text;

    local procedure BackupMovies()
    var
        MovieRec: Record Movie;
        MovieSetup: Record "Movie Setup";
        Backup: Interface Backup;
    begin
        if MovieSetup.Get() then;

        Backup := MovieSetup."Backup Type";
        Backup.Backup(Rec);
    end;
}
