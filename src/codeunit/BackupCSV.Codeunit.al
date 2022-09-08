codeunit 50101 "Backup CSV" implements Backup
{
    procedure Backup(MovieRec: Record Movie): Boolean;
    var
        TempBlob: Codeunit "Temp Blob";
        CsvTextBuilder: TextBuilder;
        FileName: Text;
        CsvOutStream: OutStream;
        CsvInStream: InStream;
        DialogTitleTok: Label 'Download Movies as csv';
        CsvFilterTok: Label 'CSV Files (*.csv)|*.csv';
        FileNameTok: Label 'movies-%1.csv', Comment = '%1 = Current Date', Locked = true;
    begin
        CreateHeader(MovieRec, CsvTextBuilder);

        MovieRec.FindSet();
        repeat
            CreateLine(MovieRec, CsvTextBuilder);
        until MovieRec.Next() = 0;

        TempBlob.CreateOutStream(CsvOutStream, TextEncoding::UTF8);
        CsvOutStream.WriteText(CsvTextBuilder.ToText());
        TempBlob.CreateInStream(CsvInStream, TextEncoding::UTF8);

        FileName := StrSubstNo(FileNameTok, CurrentDateTime());
        exit(File.DownloadFromStream(CsvInStream, DialogTitleTok, '', CsvFilterTok, FileName));
    end;

    local procedure CreateHeader(MovieRec: Record Movie; var CsvTextBuilder: TextBuilder)
    begin
        AppendWithComma(MovieRec.FieldCaption("No."), CsvTextBuilder);
        AppendWithComma(MovieRec.FieldCaption(Title), CsvTextBuilder);
        AppendWithComma(MovieRec.FieldCaption(Year), CsvTextBuilder);
        AppendWithComma(MovieRec.FieldCaption(Genre), CsvTextBuilder);
        AppendWithComma(MovieRec.FieldCaption(Actors), CsvTextBuilder);
        AppendWithComma(MovieRec.FieldCaption(Production), CsvTextBuilder);
        AppendWithComma(MovieRec.FieldCaption(Description), CsvTextBuilder);
        CsvTextBuilder.AppendLine(MovieRec.FieldCaption(Score));
    end;

    local procedure CreateLine(MovieRec: Record Movie; var CsvTextBuilder: TextBuilder)
    begin
        AppendWithComma(MovieRec."No.", CsvTextBuilder);
        AppendWithComma(MovieRec.Title, CsvTextBuilder);
        AppendWithComma(Format(MovieRec.Year), CsvTextBuilder);
        AppendWithComma(MovieRec.Genre.Replace(';', '-'), CsvTextBuilder);
        AppendWithComma(MovieRec.Actors.Replace(';', '-'), CsvTextBuilder);
        AppendWithComma(MovieRec.Production, CsvTextBuilder);
        AppendWithComma(MovieRec.Description, CsvTextBuilder);
        CsvTextBuilder.AppendLine(Format(MovieRec.Score));
    end;

    local procedure AppendWithComma(TextValue: Text; var CsvTextBuilder: TextBuilder)
    begin
        CsvTextBuilder.Append(TextValue);
        CsvTextBuilder.Append(';');
    end;
}
