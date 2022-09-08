page 50101 "Movies Card"
{
    Caption = 'Movies Card';
    PageType = Card;
    SourceTable = Movie;
    
    layout
    {
        area(content)
        {
            group(General)
            {
                field("No."; Rec."No.")
                {
                    ToolTip = 'Specifies the value of the No. field.';
                    ApplicationArea = All;
                }
                field(Title; Rec.Title)
                {
                    ToolTip = 'Specifies the value of the Title field.';
                    ApplicationArea = All;
                }
                field(Year; Rec.Year)
                {
                    ToolTip = 'Specifies the value of the Year field.';
                    ApplicationArea = All;
                }
                field(Genre; Rec.Genre)
                {
                    ToolTip = 'Specifies the value of the Genre field.';
                    ApplicationArea = All;
                }
                field(Actors; Rec.Actors)
                {
                    ToolTip = 'Specifies the value of the Actors field.';
                    ApplicationArea = All;
                }
                field(Production; Rec.Production)
                {
                    ToolTip = 'Specifies the value of the Production field.';
                    ApplicationArea = All;
                }
                field(Description; Rec.Description)
                {
                    ToolTip = 'Specifies the value of the Description field.';
                    ApplicationArea = All;
                    MultiLine = true;
                }
                field(Score; Rec.Score)
                {
                    ToolTip = 'Specifies the value of the Score field.';
                    ApplicationArea = All;
                }
            }
        }

        area(FactBoxes)
        {
            part(Poster;"Movie Poster")
            {
                ApplicationArea = All;
                Caption = 'Movie Poster';
                SubPageLink = "No." = field("No.");
            }
        }
    }
}
