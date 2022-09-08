codeunit 50102 "Backup XLSX" implements Backup
{
    procedure Backup(MovieRec: Record Movie): Boolean;
    var
        TempExcelBuffer: Record "Excel Buffer" temporary;
        TempBlob: Codeunit "Temp Blob";
        FileName: Text;
        XlsxOutStream: OutStream;
        XlsxInStream: InStream;
        DialogTitleTok: Label 'Download Movies as Xlsx';
        XlsxFilterTok: Label 'Xlsx Files (*.xlsx)|*.xlsx';
        FileNameTok: Label 'movies-%1.xlsx', Comment = '%1 = Current Date', Locked = true;
    begin
        CreateHeader(MovieRec, TempExcelBuffer);

        MovieRec.FindSet();
        repeat
            CreateLine(MovieRec, TempExcelBuffer);
        until MovieRec.Next() = 0;

        TempExcelBuffer.CreateNewBook(MovieRec.TableCaption());
        TempExcelBuffer.WriteSheet(MovieRec.TableCaption(), CompanyName(), UserId());
        TempExcelBuffer.CloseBook();

        TempBlob.CreateOutStream(XlsxOutStream, TextEncoding::UTF8);
        TempExcelBuffer.SaveToStream(XlsxOutStream, true);
        TempBlob.CreateInStream(XlsxInStream, TextEncoding::UTF8);

        FileName := StrSubstNo(FileNameTok, CurrentDateTime());
        exit(File.DownloadFromStream(XlsxInStream, DialogTitleTok, '', XlsxFilterTok, FileName));
    end;

    local procedure CreateHeader(MovieRec: Record Movie; var TempExcelBuffer: Record "Excel Buffer")
    begin
        TempExcelBuffer.Reset();
        TempExcelBuffer.NewRow();
        TempExcelBuffer.AddColumn(MovieRec.FieldCaption("No."), false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(MovieRec.FieldCaption(Title), false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(MovieRec.FieldCaption(Year), false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(MovieRec.FieldCaption(Genre), false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(MovieRec.FieldCaption(Actors), false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(MovieRec.FieldCaption(Production), false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(MovieRec.FieldCaption(Description), false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(MovieRec.FieldCaption(Score), false, '', false, true, false, '', TempExcelBuffer."Cell Type"::Number);
    end;

    local procedure CreateLine(MovieRec: Record Movie; var TempExcelBuffer: Record "Excel Buffer")
    begin
        TempExcelBuffer.NewRow();
        TempExcelBuffer.AddColumn(MovieRec."No.", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(MovieRec.Title, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(MovieRec.Year, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(MovieRec.Genre, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(MovieRec.Actors, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(MovieRec.Production, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(MovieRec.Description, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(MovieRec.Score, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Number);
    end;
}
