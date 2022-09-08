page 50104 "Get Movie Details"
{
    Caption = 'Get Movie Details';
    PageType = StandardDialog;

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'Get movie details from OMDb';
                field(MovieTitle; MovieTitle)
                {
                    Caption = 'Movie Title';
                    ApplicationArea = All;
                }
            }
        }
    }

    var
        MovieTitle: Text;

    procedure GetMovieTitle(): Text
    begin
        exit(MovieTitle);
    end;
}
