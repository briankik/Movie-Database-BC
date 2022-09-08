table 50100 "Movie"
{
    Caption = 'Movie';
    DataClassification = CustomerContent;
    DrillDownPageId = "Movies List";
    LookupPageId = "Movies List";
    DataCaptionFields = "No.", "Title";

    fields
    {
        field(1; "No."; Code[20])
        {
            Caption = 'No.';
            DataClassification = CustomerContent;
        }
        field(2; Title; Text[50])
        {
            Caption = 'Title';
            DataClassification = CustomerContent;
        }
        field(3; Year; Integer)
        {
            Caption = 'Year';
            DataClassification = CustomerContent;
        }
        field(4; Genre; Text[50])
        {
            Caption = 'Genre';
            DataClassification = CustomerContent;
        }
        field(5; Actors; Text[250])
        {
            Caption = 'Actors';
            DataClassification = CustomerContent;
        }
        field(6; Production; Text[250])
        {
            Caption = 'Production';
            DataClassification = CustomerContent;
        }
        field(7; Description; Text[250])
        {
            Caption = 'Description';
            DataClassification = CustomerContent;
        }
        field(8; Score; Decimal)
        {
            Caption = 'Score';
            DataClassification = CustomerContent;
        }
        field(9; Image; Media)
        {
            Caption = 'Image';
            DataClassification = CustomerContent;
        }
    }
    keys
    {
        key(PK; "No.")
        {
            Clustered = true;
        }
    }
    fieldgroups
    {
        fieldgroup(Brick; "No.", Title, Year, Genre, Score, Image)
        {
        }
        fieldgroup(DropDown; "No.", Title, Year)
        {
        }
    }

    procedure GetImageAsBase64() Base64Txt: Text
    var
        Base64Conv: Codeunit "Base64 Convert";
        TempBlob: Codeunit "Temp Blob";
        TenantMedia: Record "Tenant Media";
        ImgInstream: InStream;
        ImgOutstream: OutStream;
    begin
        if Image.HasValue then begin
            if TenantMedia.Get(Image.MediaId) then begin
                TenantMedia.CalcFields(Content);
                if TenantMedia.Content.HasValue() then begin
                    TenantMedia.Content.CreateInStream(ImgInstream);
                    Base64Txt := Base64Conv.ToBase64(ImgInstream);
                end;
            end;
        end;

        exit(Base64Txt);
    end;
}
