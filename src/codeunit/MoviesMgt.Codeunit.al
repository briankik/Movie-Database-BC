codeunit 50110 "Movies Mgt"
{
    procedure RetrieveMoviesFromOMDb(SearchValue: Text)
    var
        OMDbUri: Label 'http://www.omdbapi.com/?apikey=%1&s=%2', Comment = '%1 = Api key, %2 = Title', Locked = true;
        InvalidJsonObjectErr: Label 'Invalid response from the web service. Invalide Json object';
        ApiKey: Label 'f4067e8f';
        MovieJsonToken: JsonToken;
        MovieList: Text;
        MovieListIds: List of [Code[20]];
        SelectedMovieIndex: Integer;
    begin
        if StrLen(SearchValue) = 0 then
            exit;

        if not DownloandContentFromURl(StrSubstNo(OMDbUri, ApiKey, SearchValue), MovieJsonToken) then
            exit;

        if not MovieJsonToken.SelectToken('$.Search', MovieJsonToken) then begin
            SendErrorNotification(InvalidJsonObjectErr);
            exit;
        end;

        if not (MovieJsonToken.IsArray()) then begin
            SendErrorNotification(InvalidJsonObjectErr);
            exit;
        end;

        BuildMovieList(MovieJsonToken.AsArray(), MovieListIds, MovieList);
        SelectedMovieIndex := StrMenu(MovieList);

        if (SelectedMovieIndex = 0) then
            exit;

        CreateNewMovie(MovieListIds.Get(SelectedMovieIndex));
    end;

    local procedure DownloandContentFromURl(Url: Text; var JsonToken: JsonToken): Boolean
    var
        OmdbHttpClient: HttpClient;
        OmdbHttpResponseMessage: HttpResponseMessage;
        OmdbHttpContent: HttpContent;
        JsonContent: Text;
        InvalidJsonObjectErr: Label 'Invalid response from the web service. Invalide Json object';
        CallToWebServiceFailedErr: Label 'The call to the web service failed';
        WebServiceReturnedErr: Label 'The web service returned an error message:\\Status code: %1\Description: %2', Comment = '%1 = Status Code, %2 = Description';
    begin
        if not (OmdbHttpClient.Get(Url, OmdbHttpResponseMessage)) then begin
            SendErrorNotification(CallToWebServiceFailedErr);
            exit(false);
        end;

        if not (OmdbHttpResponseMessage.IsSuccessStatusCode()) then begin
            SendErrorNotification(StrSubstNo(WebServiceReturnedErr, OmdbHttpResponseMessage.HttpStatusCode(), OmdbHttpResponseMessage.ReasonPhrase()));
            exit(false);
        end;

        OmdbHttpContent := OmdbHttpResponseMessage.Content();
        OmdbHttpContent.ReadAs(JsonContent);

        if not (JsonToken.ReadFrom(JsonContent)) then begin
            SendErrorNotification(InvalidJsonObjectErr);
            exit(false);
        end;

        exit(true);
    end;

    internal procedure BuildMovieList(JArray: JsonArray; var MovieListIds: List of [Code[20]]; var MovieList: Text)
    var
        Counter: Integer;
        ImdbId: Code[20];
        MovieTitle: Text;
        JsonToken: JsonToken;
        JsonObject: JsonObject;
        MovieListTextBuilder: TextBuilder;
    begin
        for Counter := 0 to JArray.Count() - 1 do begin
            JArray.Get(Counter, JsonToken);
            JsonObject := JsonToken.AsObject();

            if (JsonObject.Get('imdbID', JsonToken)) then begin
                ImdbId := CopyStr(JsonToken.AsValue().AsCode(), 1, MaxStrLen(ImdbId));

                if (JsonObject.Get('Title', JsonToken)) then begin
                    MovieTitle := CopyStr(JsonToken.AsValue().AsText(), 1, MaxStrLen(MovieTitle));

                    MovieListIds.Add(ImdbId);

                    if Counter > 0 then
                        MovieListTextBuilder.Append(',');

                    MovieListTextBuilder.Append(MovieTitle.Replace(',', '.'));
                end;
            end;

            MovieList := MovieListTextBuilder.ToText();
        end;
    end;

    internal procedure CreateNewMovie(Id: Code[20])
    var
        MovieRec: Record Movie;
        OmdbJsonToken: JsonToken;
        OmdbJsonObject: JsonObject;
        PosterUrl: Text;
    begin
        if not GetMovieDetailsFromOmdb(Id, OmdbJsonObject) then
            exit;

        if OmdbJsonObject.Get('imdbID', OmdbJsonToken) then
            MovieRec."No." := CopyStr(OmdbJsonToken.AsValue().AsCode(), 1, MaxStrLen(MovieRec."No."));

        if OmdbJsonObject.Get('Year', OmdbJsonToken) then
            MovieRec.Year := OmdbJsonToken.AsValue().AsInteger();

        if OmdbJsonObject.Get('imdbRating', OmdbJsonToken) then
            MovieRec.Score := OmdbJsonToken.AsValue().AsDecimal();

        if OmdbJsonObject.Get('Title', OmdbJsonToken) then
            MovieRec.Title := CopyStr(OmdbJsonToken.AsValue().AsText(), 1, MaxStrLen(MovieRec.Title));

        if OmdbJsonObject.Get('Actors', OmdbJsonToken) then
            MovieRec.Actors := CopyStr(OmdbJsonToken.AsValue().AsText(), 1, MaxStrLen(MovieRec.Actors));

        if OmdbJsonObject.Get('Plot', OmdbJsonToken) then
            MovieRec.Description := CopyStr(OmdbJsonToken.AsValue().AsText(), 1, MaxStrLen(MovieRec.Description));

        if OmdbJsonObject.Get('Genre', OmdbJsonToken) then
            MovieRec.Genre := CopyStr(OmdbJsonToken.AsValue().AsText(), 1, MaxStrLen(MovieRec.Genre));

        if OmdbJsonObject.Get('Production', OmdbJsonToken) then
            MovieRec.Production := CopyStr(OmdbJsonToken.AsValue().AsText(), 1, MaxStrLen(MovieRec.Production));

        if OmdbJsonObject.Get('Poster', OmdbJsonToken) then begin
            PosterUrl := OmdbJsonToken.AsValue().AsText();
            GetMoviePoster(PosterUrl, MovieRec);
        end;

        MovieRec.Insert();
        Page.Run(Page::"Movies Card", MovieRec);
    end;

    local procedure GetMovieDetailsFromOmdb(Id: Text[20]; var OmdbJsonObject: JsonObject): Boolean
    var
        JsonToken: JsonToken;
        OMDbUri: Label 'http://www.omdbapi.com/?apikey=%1&i=%2', Comment = '%1 = Api key, %2 = Id', Locked = true;
        InvalidJsonObjectErr: Label 'Invalid response from the web service. Invalide Json object';
        ApiKey: Label 'f4067e8f';
    begin
        if not DownloandContentFromURl(StrSubstNo(OMDbUri, ApiKey, LowerCase(Id)), JsonToken) then
            exit(false);

        if not (JsonToken.IsObject()) then begin
            SendErrorNotification(InvalidJsonObjectErr);
            exit(false);
        end;

        OmdbJsonObject := JsonToken.AsObject();
        exit(true);
    end;

    local procedure GetMoviePoster(PosterUrl: Text; var MovieRec: Record Movie): Boolean
    var
        PosterInstream: InStream;
        OmdbHttpClient: HttpClient;
        OmdbHttpResponseMessage: HttpResponseMessage;
        OmdbHttpContent: HttpContent;
        CallToWebServiceFailedErr: Label 'The call to the web service failed';
        WebServiceReturnedErr: Label 'The web service returned an error message:\\Status code: %1\Description: %2', Comment = '%1 = Status Code, %2 = Description';
    begin
        if (PosterUrl = '') then
            exit(false);

        if not (OmdbHttpClient.Get(PosterUrl, OmdbHttpResponseMessage)) then begin
            SendErrorNotification(CallToWebServiceFailedErr);
            exit(false);
        end;

        if not (OmdbHttpResponseMessage.IsSuccessStatusCode()) then begin
            SendErrorNotification(StrSubstNo(WebServiceReturnedErr, OmdbHttpResponseMessage.HttpStatusCode(), OmdbHttpResponseMessage.ReasonPhrase()));
            exit(false);
        end;

        OmdbHttpResponseMessage.Content.ReadAs(PosterInstream);
        MovieRec.Image.ImportStream(PosterInstream, MovieRec.Title);
        exit(true);
    end;

    local procedure SendErrorNotification(Message: Text)
    var
        ErrorNotification: Notification;
    begin
        ErrorNotification.Scope(NotificationScope::LocalScope);
        ErrorNotification.Message(Message);
        ErrorNotification.Send();
    end;

    /* procedure RetrieveMoviesFromOMDb(SearchValue: Text)
    var
        OMDbHttpClient: HttpClient;
        OMDbHttpResponseMessage: HttpResponseMessage;
        OMDbHttpRequestMessage: HttpRequestMessage;
        OMDbUri: Label 'http://www.omdbapi.com/?apikey=%1&s=%2';
        apiKey, ContentString, MovieTitle : Text;
        MovieJsonToken, MovieTitleToken : JsonToken;
        MovieJsonObject: JsonObject;
        MovieJsonArray: JsonArray;
        ErrorBuilder: TextBuilder;
    begin
        apiKey := 'f4067e8f';
        OMDbHttpRequestMessage.SetRequestUri(StrSubstNo(OMDbUri, apiKey, SearchValue));
        OMDbHttpRequestMessage.Method('GET');

        if not OMDbHttpClient.Send(OMDbHttpRequestMessage, OMDbHttpResponseMessage) then
            Error('The call to Http Client failed');

        if not OMDbHttpResponseMessage.IsSuccessStatusCode() then begin
            ErrorBuilder.AppendLine('The web service returned an error message');
            ErrorBuilder.Append('Status code: ');
            ErrorBuilder.AppendLine(Format(OMDbHttpResponseMessage.HttpStatusCode));
            ErrorBuilder.Append('Description: ');
            ErrorBuilder.AppendLine(OMDbHttpResponseMessage.ReasonPhrase());

            Error(ErrorBuilder.ToText());
        end;

        OMDbHttpResponseMessage.Content.ReadAs(ContentString);

        // Getting error JSON tokens of type 'Object' are not supported by this implementation.
        MovieJsonArray.ReadFrom(ContentString);

        foreach MovieJsonToken in MovieJsonArray do begin
            MovieJsonObject := MovieTitleToken.AsObject();
            if MovieJsonObject.Get('Title', MovieTitleToken) then
                MovieTitle := MovieTitleToken.AsValue().AsText();
            Message(MovieTitle);
        end;
    end; */
}
