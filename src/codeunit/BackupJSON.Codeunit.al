codeunit 50103 "Backup JSON" implements Backup
{
    procedure Backup(MovieRec: Record Movie): Boolean;
    var
        MovieJsonArray: JsonArray;
        TempBlob: Codeunit "Temp Blob";
        FileName: Text;
        JsonOutStream: OutStream;
        JsonInStream: InStream;
        DialogTitleTok: Label 'Download Movies as Json';
        JsonFilterTok: Label 'Json Files (*.json)|*.json';
        FileNameTok: Label 'movies-%1.json', Comment = '%1 = Current Date', Locked = true;
    begin
        MovieRec.FindSet();
        repeat
            MovieJsonArray.Add(GetMovieJsonObject(MovieRec));
        until MovieRec.Next() = 0;

        TempBlob.CreateOutStream(JsonOutStream, TextEncoding::UTF8);
        MovieJsonArray.WriteTo(JsonOutStream);
        TempBlob.CreateInStream(JsonInStream, TextEncoding::UTF8);

        FileName := StrSubstNo(FileNameTok, CurrentDateTime());
        exit(File.DownloadFromStream(JsonInStream, DialogTitleTok, '', JsonFilterTok, FileName));
    end;

    local procedure GetMovieJsonObject(MovieRec: Record Movie): JsonObject
    var
        MovieJsonObject: JsonObject;
    begin
        MovieJsonObject.Add('no', MovieRec."No.");
        MovieJsonObject.Add('title', MovieRec.Title);
        MovieJsonObject.Add('year', MovieRec.Year);
        MovieJsonObject.Add('genre', MovieRec.Genre);
        MovieJsonObject.Add('actors', MovieRec.Actors);
        MovieJsonObject.Add('production', MovieRec.Production);
        MovieJsonObject.Add('description', MovieRec.Description);
        MovieJsonObject.Add('score', MovieRec.Score);
        MovieJsonObject.Add('image', MovieRec.GetImageAsBase64());

        exit(MovieJsonObject);
    end;
}
