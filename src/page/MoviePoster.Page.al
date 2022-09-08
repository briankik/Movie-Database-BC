page 50102 "Movie Poster"
{
    Caption = 'Movie Poster';
    PageType = CardPart;
    SourceTable = Movie;

    layout
    {
        area(content)
        {
            group(General)
            {
                ShowCaption = false;
                field(Image; Rec.Image)
                {
                    ToolTip = 'Specifies the value of the Image field.';
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(Upload)
            {
                ApplicationArea = All;
                Caption = 'Upload Poster';
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                Image = Picture;

                trigger OnAction()
                begin
                    UploadImage();
                end;
            }
        }
    }

    local procedure UploadImage()
    var
        ImgIns: InStream;
        ImgFileName: Text;
        ConfrimMsg: Label 'The existing image will be overwritten, do you want to proceed?';
    begin
        if Rec.Image.HasValue then
            if not Confirm(ConfrimMsg) then
                exit;

        if UploadIntoStream('Upload Movie Poster', '', 'All Files (*.*)|*.*', ImgFileName, ImgIns) then begin
            Clear(Rec.Image);
            ImgFileName := Rec.Title;
            Rec.Image.ImportStream(ImgIns, ImgFileName);
            Rec.Modify(true);
        end;
    end;
}
