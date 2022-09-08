codeunit 50104 "Backup XML" implements Backup
{
    procedure Backup(MovieRec: Record Movie): Boolean;
    var
        MovieXmlDocument: XmlDocument;
        MoviesXmlElement: XmlElement;
        TempBlob: Codeunit "Temp Blob";
        FileName: Text;
        XmlOutStream: OutStream;
        XmlInStream: InStream;
        DialogTitleTok: Label 'Download Movies as Xml';
        XmlFilterTok: Label 'Xml Files (*.xml)|*.xml';
        FileNameTok: Label 'movies-%1.xml', Comment = '%1 = Current Date', Locked = true;
    begin
        MovieXmlDocument := XmlDocument.Create();
        MoviesXmlElement := XmlElement.Create('Movies');

        MovieRec.FindSet();
        repeat
            MoviesXmlElement.Add(GetMovieXmlElement(MovieRec));
        until MovieRec.Next() = 0;

        MovieXmlDocument.Add(MoviesXmlElement);

        TempBlob.CreateOutStream(XmlOutStream, TextEncoding::UTF8);
        MovieXmlDocument.WriteTo(XmlOutStream);
        TempBlob.CreateInStream(XmlInStream, TextEncoding::UTF8);

        FileName := StrSubstNo(FileNameTok, CurrentDateTime());
        exit(File.DownloadFromStream(XmlInStream, DialogTitleTok, '', XmlFilterTok, FileName));
    end;

    local procedure GetMovieXmlElement(MovieRec: Record Movie): XmlElement
    var
        MovieXmlElement: XmlElement;
    begin
        MovieXmlElement := XmlElement.Create('Movie');

        MovieXmlElement.Add(XmlElement.Create('No', '', MovieRec."No."));
        MovieXmlElement.Add(XmlElement.Create('Title', '', MovieRec.Title));
        MovieXmlElement.Add(XmlElement.Create('Year', '', MovieRec.Year));
        MovieXmlElement.Add(XmlElement.Create('Genre', '', MovieRec.Genre));
        MovieXmlElement.Add(XmlElement.Create('Actors', '', MovieRec.Actors));
        MovieXmlElement.Add(XmlElement.Create('Production', '', MovieRec.Production));
        MovieXmlElement.Add(XmlElement.Create('Description', '', MovieRec.Description));
        MovieXmlElement.Add(XmlElement.Create('Score', '', MovieRec.Score));
        MovieXmlElement.Add(XmlElement.Create('Image', '', MovieRec.GetImageAsBase64()));

        exit(MovieXmlElement);
    end;
}
