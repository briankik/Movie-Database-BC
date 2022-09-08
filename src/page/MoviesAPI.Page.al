page 50103 "Movies API"
{
    APIGroup = 'movieGroup';
    APIPublisher = 'solutizeBrian';
    APIVersion = 'v1.0';
    Caption = 'moviesAPI';
    DelayedInsert = true;
    EntityName = 'movie';
    EntitySetName = 'movies';
    ODataKeyFields = SystemId;
    PageType = API;
    SourceTable = Movie;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field(id; Rec.SystemId)
                {
                    Caption = 'SystemId';
                }
                field(no; Rec."No.")
                {
                    Caption = 'No.';
                }
                field(title; Rec.Title)
                {
                    Caption = 'Title';
                }
                field(description; Rec.Description)
                {
                    Caption = 'Description';
                }
                field(year; Rec.Year)
                {
                    Caption = 'Year';
                }
                field(actors; Rec.Actors)
                {
                    Caption = 'Actors';
                }
                field(genre; Rec.Genre)
                {
                    Caption = 'Genre';
                }
                field(production; Rec.Production)
                {
                    Caption = 'Production';
                }
                field(score; Rec.Score)
                {
                    Caption = 'Score';
                }
            }
        }
    }
}
