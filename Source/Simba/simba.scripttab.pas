unit simba.scripttab;

{$mode objfpc}{$H+}
{$i simba.inc}

interface

uses
  classes, sysutils, comctrls, controls, dialogs, lcltype, ExtCtrls,
  syneditmiscclasses, syneditkeycmds,
  simba.editor, simba.scriptinstance, simba.codeinsight, simba.codeparser, simba.parameterhint, simba.script_communication,
  simba.debuggerform, simba.functionlistform, simba.functionlistupdater;

type
  TSimbaScriptTab = class(TTabSheet)
  protected
    FEditor: TSimbaEditor;
    FSavedText: String;
    FScriptFileName: String;
    FScriptTitle: String;
    FScriptInstance: TSimbaScriptInstance;
    FScriptErrorLine: Int32;
    FFunctionList: TSimbaFunctionList;
    FFunctionListUpdater: TSimbaFunctionListUpdater;
    FFunctionListTimer: TTimer;
    FDebuggingForm: TSimbaDebuggerForm;

    procedure Notification(AComponent: TComponent; Operation: TOperation); override;

    procedure DoHide; override;
    procedure DoShow; override;

    procedure TimerExecute(Sender: TObject);

    procedure HandleEditorClick(Sender: TObject);
    procedure HandleEditorChange(Sender: TObject);
    procedure HandleEditorLinkClick(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure HandleEditorSpecialLine(Sender: TObject; Line: Integer; var Special: Boolean; AMarkup: TSynSelectedColor);
    procedure HandleEditorUserCommand(Sender: TObject; var Command: TSynEditorCommand; var AChar: TUTF8Char; Data: Pointer);

    procedure HandleAutoComplete;
    procedure HandleParameterHints;
    procedure HandleFindDeclaration(Data: PtrInt);

    procedure UpdateSavedText;

    function GetScript: String;
    function GetScriptChanged: Boolean;
  public
    property DebuggingForm: TSimbaDebuggerForm read FDebuggingForm;
    property FunctionList: TSimbaFunctionList read FFunctionList;
    property FunctionListUpdater: TSimbaFunctionListUpdater read FFunctionListUpdater;

    property ScriptInstance: TSimbaScriptInstance read FScriptInstance;
    property ScriptTitle: String read FScriptTitle;
    property ScriptFileName: String read FScriptFileName;

    property ScriptChanged: Boolean read GetScriptChanged;
    property Script: String read GetScript;
    property Editor: TSimbaEditor read FEditor;

    function SaveAsDialog: String;

    function Save(FileName: String): Boolean;
    function Load(FileName: String): Boolean; overload;
    function Load(FileName: String; AScriptFileName, AScriptTitle: String): Boolean; overload;

    function GetParser: TCodeInsight;
    function ParseScript: TCodeInsight;

    procedure SetError(Line, Col: Int32);

    procedure Undo;
    procedure Redo;

    function CanClose: Boolean;

    procedure Reset;
    function CreateDebuggingForm: TSimbaDebuggerForm;

    function ScriptState: ESimbaScriptState;
    function ScriptTimeRunning: UInt64;

    procedure Run(Target: THandle);
    procedure Compile;
    procedure Pause;
    procedure Stop;

    constructor Create(APageControl: TPageControl); reintroduce;
    destructor Destroy; override;
  end;

implementation

uses
  interfacebase, forms, lazfileutils, lazloggerbase,
  synedit, syneditmousecmds, SynEditTextBuffer,
  simba.scripttabsform, simba.autocomplete, simba.settings, simba.mufasatypes,
  simba.scripttabhistory, simba.main, simba.parser_misc, simba.files;

procedure TSimbaScriptTab.HandleAutoComplete;
var
  Expression, Filter: String;
  Declaration: TDeclaration;
  P: TPoint;
begin
  Filter := '';
  Expression := '';

  if FEditor.CaretX <= Length(FEditor.LineText) + 1 then
    Expression := GetExpression(FEditor.Text, FEditor.SelStart - 1);

  FEditor.AutoComplete.Parser := Self.ParseScript();

  if Expression.Contains('.') then
  begin
    if not Expression.EndsWith('.') then
    begin
      Filter := Copy(Expression, LastDelimiter('.', Expression) + 1, $FFFFFF);
      Expression := Copy(Expression, 1, LastDelimiter('.', Expression) - 1);
    end;

    Declaration := FEditor.AutoComplete.Parser.ParseExpression(Expression);
    if Declaration <> nil then
      FEditor.AutoComplete.FillTypeDeclarations(Declaration);
  end else
  begin
    Filter := Expression;

    FEditor.AutoComplete.FillGlobalDeclarations();
  end;

  if Filter = '' then
    P := FEditor.CaretXY
  else
    P := FEditor.CharIndexToRowCol(FEditor.SelStart - Length(Filter) - 1);

  P := FEditor.RowColumnToPixels(P);
  P := FEditor.ClientToScreen(P);

  FEditor.AutoComplete.Execute(Filter, P.X, P.Y + FEditor.LineHeight);
end;

procedure TSimbaScriptTab.HandleParameterHints;
var
  BracketPos, InParameters: Int32;
  Expression, ScriptText: String;
  Methods: TDeclarationArray;
begin
  ScriptText := Script;

  if (FEditor.SelStart <= Length(ScriptText)) then
  begin
    InParameters := 0;

    for BracketPos := FEditor.SelStart - 1 downto 1 do
    begin
      if (ScriptText[BracketPos] = ')') then
        Inc(InParameters);

      if (ScriptText[BracketPos] = '(') then
      begin
        if (InParameters = 0) then
          Break;

        Dec(InParameters);
      end;
    end;

    Expression := GetExpression(ScriptText, BracketPos - 1);
  end else
    Exit;

  FEditor.ParameterHint.Parser := Self.ParseScript();
  with FEditor.ParameterHint.Parser do
    Methods := FindMethods(Expression);

  FEditor.ParameterHint.Execute(FEditor.CharIndexToRowCol(BracketPos - 1), Methods);
end;

procedure TSimbaScriptTab.HandleFindDeclaration(Data: PtrInt);
var
  Expression: String;
  Parser: TCodeInsight;
  Declarations: TDeclarationArray;
  Buttons: TDialogButtons;
  i: Int32;
begin
  try
    Expression := FEditor.Expression[PPoint(Data)^.X, PPoint(Data)^.Y];
    if (Expression = '') then
      Exit;

    Parser := Self.ParseScript();
    Declarations := Parser.FindDeclarations(Expression);

    if Length(Declarations) = 1 then
      SimbaScriptTabsForm.OpenDeclaration(Declarations[0])
    else
    if Length(Declarations) > 1 then
    begin
      Buttons := TDialogButtons.Create(TDialogButton);

      for i := 0 to High(Declarations) do
      begin
        with Buttons.Add() do
        begin
          Caption := ExtractFileName(Declarations[i].Lexer.FileName) + ' (Line ' + IntToStr(Declarations[i].Line + 1) + ')';
          ModalResult := 1000 + i;
        end;
      end;

      i := DefaultQuestionDialog('Multiple declarations found', 'Choose the declaration to show', Ord(mtInformation), Buttons , 0);
      if (i >= 1000) then
        SimbaScriptTabsForm.OpenDeclaration(Declarations[i - 1000]);

      Buttons.Free();
    end;

    Parser.Free();
  finally
    FreeMem(Pointer(Data));
  end;
end;

function TSimbaScriptTab.GetScript: String;
begin
  Result := FEditor.Text;
end;

function TSimbaScriptTab.GetScriptChanged: Boolean;
begin
  Result := FEditor.Text <> FSavedText;
end;

procedure TSimbaScriptTab.UpdateSavedText;
begin
  FSavedText := FEditor.Text;

  FEditor.MarkTextAsSaved();
  FEditor.ModifiedLinesGutter.ReCalc();
  if (FEditor.OnChange <> nil) then
    FEditor.OnChange(FEditor);
end;

procedure TSimbaScriptTab.Notification(AComponent: TComponent; Operation: TOperation);
begin
  if (Operation = opRemove) and (AComponent = FScriptInstance) then
  begin
    DebugLn('TSimbaScriptTab.Notification :: FScriptInstance = nil');

    FScriptInstance := nil;
  end;

  inherited Notification(AComponent, Operation);
end;

procedure TSimbaScriptTab.DoHide;
begin
  inherited DoHide();

  if (FFunctionList <> nil) then
  begin
    FFunctionListTimer.Enabled := False;
    FFunctionList.Hide();
  end;
end;

procedure TSimbaScriptTab.DoShow;
begin
  inherited DoShow();

  if (FFunctionList <> nil) then
  begin
    FFunctionListUpdater.ChangeStamp := 0; // Force update
    FFunctionListTimer.Enabled := True;
    FFunctionList.Show();
  end;

  if (SimbaScriptTabHistory <> nil) then
    SimbaScriptTabHistory.Add(Self);

  if (FEditor <> nil) and FEditor.CanSetFocus then
    FEditor.SetFocus();
end;

procedure TSimbaScriptTab.TimerExecute(Sender: TObject);
begin
  if (FFunctionListUpdater = nil) then
    Exit;

  if (FEditor.ChangeStamp <> FFunctionListUpdater.ChangeStamp) then
    FFunctionListUpdater.Update(Self.GetParser(), FEditor.ChangeStamp);
end;

procedure TSimbaScriptTab.HandleEditorClick(Sender: TObject);
begin
  if (SimbaScriptTabHistory <> nil) then
    SimbaScriptTabHistory.Add(Self);

  if (FScriptErrorLine > -1) then
  begin
    FScriptErrorLine := -1;

    FEditor.Invalidate();
  end;
end;

procedure TSimbaScriptTab.HandleEditorChange(Sender: TObject);
begin
  if ScriptChanged then
  begin
    Caption := '*' + FScriptTitle;

    SimbaForm.MenuItemSave.Enabled := True;
    SimbaForm.ToolbarButtonSave.Enabled := True;
  end else
  begin
    Caption := FScriptTitle;

    SimbaForm.MenuItemSave.Enabled := False;
    SimbaForm.ToolbarButtonSave.Enabled := False;
  end;

  if (FScriptErrorLine > -1) then
  begin
    FScriptErrorLine := -1;

    FEditor.Invalidate();
  end;
end;

procedure TSimbaScriptTab.HandleEditorLinkClick(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  CaretPos: PPoint;
begin
  CaretPos := GetMem(SizeOf(TPoint));
  if (Sender = FEditor) then
    CaretPos^ := FEditor.PixelsToRowColumn(ScreenToControl(Mouse.CursorPos), [])
  else
  begin
    CaretPos^.X := X;
    CaretPos^.Y := Y;
  end;

  Application.QueueASyncCall(@HandleFindDeclaration, PtrInt(CaretPos)); // SynEdit is paint locked!
end;

procedure TSimbaScriptTab.HandleEditorSpecialLine(Sender: TObject; Line: Integer; var Special: Boolean; AMarkup: TSynSelectedColor);
begin
  Special := Line = FScriptErrorLine;

  if Special then
  begin
    AMarkup.BackAlpha := 200;
    AMarkup.Background := $0000CC;
    AMarkup.Foreground := $000000;
  end;
end;

procedure TSimbaScriptTab.HandleEditorUserCommand(Sender: TObject; var Command: TSynEditorCommand; var AChar: TUTF8Char; Data: Pointer);
begin
  case Command of
    ecParameterHint, ecParameterHintChar:
      HandleParameterHints();
    ecAutoComplete, ecAutoCompleteChar:
      HandleAutoComplete();
  end;
end;

function TSimbaScriptTab.SaveAsDialog: String;
begin
  Result := '';

  with TSaveDialog.Create(Self) do
  try
    Filter := 'Simba Files|*.simba;*.pas;*.inc;|Any Files|*.*';
    Options := Options + [ofOverwritePrompt];
    InitialDir := ExtractFileDir(FScriptFileName);
    if (InitialDir = '') then
      InitialDir := GetScriptPath();

    if Execute() then
    begin
      if (ExtractFileExt(FileName) = '') then
        FileName := ChangeFileExt(FileName, '.simba');

      Result := FileName;
    end;
  finally
    Free();
  end;
end;

function TSimbaScriptTab.Save(FileName: String): Boolean;
begin
  Result := False;

  if (FileName = '') then
  begin
    FileName := SaveAsDialog();
    if (FileName = '') then
      Exit;
  end;

  try
    FEditor.Lines.SaveToFile(FileName);

    Result := True;
  except
    on E: Exception do
    begin
      MessageDlg('Unable to save script: ' + E.Message, mtError, [mbOK], 0);

      Exit;
    end;
  end;

  FScriptTitle := ExtractFileNameOnly(FileName);
  FScriptFileName := FileName;

  UpdateSavedText();
end;

function TSimbaScriptTab.Load(FileName: String): Boolean;
begin
  Result := False;
  if (FileName = '') then
    Exit;

  try
    FEditor.Lines.LoadFromFile(FileName);

    Result := True;
  except
    on E: Exception do
    begin
      MessageDlg('Unable to load script: ' + E.Message, mtError, [mbOK], 0);
      Exit;
    end;
  end;

  FScriptTitle := ExtractFileNameOnly(FileName);
  FScriptFileName := FileName;

  UpdateSavedText();
end;

function TSimbaScriptTab.GetParser: TCodeInsight;
begin
  Result := TCodeInsight.Create();
  if (Result.Lexer.FileName = '') then
    Result.Lexer.FileName := FScriptFileName;

  // Result.OnMessage := @SimbaForm.CodeTools_OnMessage;
  Result.OnFindInclude := @SimbaForm.CodeTools_OnFindInclude;
  Result.OnFindLibrary := @SimbaForm.CodeTools_OnFindLibrary;
  Result.OnLoadLibrary := @SimbaForm.CodeTools_OnLoadLibrary;
  Result.Lexer.CaretPos := FEditor.SelStart - 1;
 // Result.Lexer.MaxPos := FEditor.SelStart - 1;
  Result.Lexer.Script := FEditor.Text;
end;

function TSimbaScriptTab.ParseScript: TCodeInsight;
begin
  Result := TCodeInsight.Create();
  if (Result.Lexer.FileName = '') then
    Result.Lexer.FileName := FScriptFileName;

  Result.OnMessage := @SimbaForm.CodeTools_OnMessage;
  Result.OnFindInclude := @SimbaForm.CodeTools_OnFindInclude;
  Result.OnFindLibrary := @SimbaForm.CodeTools_OnFindLibrary;
  Result.OnLoadLibrary := @SimbaForm.CodeTools_OnLoadLibrary;
  Result.Lexer.CaretPos := FEditor.SelStart - 1;
  Result.Lexer.MaxPos := FEditor.SelStart - 1;
  Result.Run(Script, Result.Lexer.FileName);
end;

function TSimbaScriptTab.Load(FileName: String; AScriptFileName, AScriptTitle: String): Boolean;
begin
  Result := False;

  try
    FSavedText := '';

    FScriptTitle := AScriptTitle;
    FScriptFileName := AScriptFileName;

    FEditor.Lines.LoadFromFile(FileName);
    if (FEditor.OnChange <> nil) then
      FEditor.OnChange(FEditor);

    Result := True;
  except
    on E: Exception do
      MessageDlg('Unable to load script: ' + E.Message, mtError, [mbOK], 0);
  end;
end;

procedure TSimbaScriptTab.SetError(Line, Col: Int32);
begin
  FScriptErrorLine := Line;

  FEditor.CaretX := Col;
  FEditor.CaretY := Line;
  FEditor.TopLine := Line - (FEditor.LinesInWindow div 2);
  FEditor.Invalidate();
end;

procedure TSimbaScriptTab.Undo;
begin
  FEditor.Undo();
end;

procedure TSimbaScriptTab.Redo;
begin
  FEditor.Redo();
end;

function TSimbaScriptTab.CanClose: Boolean;
begin
  Result := True;

  if (FScriptInstance <> nil) then
  begin
    Self.Show();

    case MessageDlg('Script is still running. Forcefully stop this script?', mtConfirmation, [mbYes, mbNo], 0) of
      mrYes:
        if (FScriptInstance <> nil) then
          FScriptInstance.Kill();
      mrNo:
        Result := False;
    end;
  end;

  if Result and ScriptChanged then
  begin
    Show();

    case MessageDlg('Script has been modified. Save this script?', mtConfirmation, [mbYes, mbNo, mbAbort], 0) of
      mrYes:
        Save(FScriptFileName);
      mrAbort:
        Result := False;
    end;
  end;
end;

procedure TSimbaScriptTab.Reset;
begin
  if (SimbaScriptTabHistory <> nil) then
    SimbaScriptTabHistory.Clear(Self);

  FScriptTitle := 'Untitled';
  FScriptFileName := '';
  FScriptErrorLine := -1;

  FEditor.Text := SimbaSettings.Editor.DefaultScript.Value;
  FEditor.ClearUndo();

  UpdateSavedText();
end;

function TSimbaScriptTab.CreateDebuggingForm: TSimbaDebuggerForm;
begin
  if (FDebuggingForm = nil) then
  begin
    FDebuggingForm := TSimbaDebuggerForm.Create(Self);
    FDebuggingForm.Font := Self.Font;
    FDebuggingForm.ShowOnTop();
  end;

  FDebuggingForm.Caption := 'Debugger - ' + FScriptTitle;
  FDebuggingForm.ShowOnTop();

  Result := FDebuggingForm;
end;

function TSimbaScriptTab.ScriptState: ESimbaScriptState;
begin
  Result := STATE_NONE;
  if (FScriptInstance <> nil) then
    Result := FScriptInstance.State;
end;

function TSimbaScriptTab.ScriptTimeRunning: UInt64;
begin
  Result := 0;
  if (FScriptInstance <> nil) then
    Result := FScriptInstance.TimeRunning;
end;

procedure TSimbaScriptTab.Run(Target: THandle);
begin
  DebugLn('TSimbaScriptTab.Run :: ', ScriptTitle, ' ', ScriptFileName);

  if (FScriptInstance <> nil) then
    FScriptInstance.Resume()
  else
  begin
    FScriptInstance := TSimbaScriptInstance.Create(Self);
    FScriptInstance.Target := Target;

    if (FScriptFileName = '') then
    begin
      FScriptInstance.ScriptName := ScriptTitle;
      FScriptInstance.ScriptFile := CreateTempFile(Script, 'script');
    end else
      FScriptInstance.ScriptFile := ScriptFileName;

    FScriptInstance.Run();
  end;
end;

procedure TSimbaScriptTab.Compile;
begin
  DebugLn('TSimbaScriptTab.Compile :: ', ScriptTitle, ' ', ScriptFileName);

  if (FScriptInstance = nil) then
  begin
    FScriptInstance := TSimbaScriptInstance.Create(Self);

    if (FScriptFileName = '') then
    begin
      FScriptInstance.ScriptName := ScriptTitle;
      FScriptInstance.ScriptFile := CreateTempFile(Script, '.script');
    end else
      FScriptInstance.ScriptFile := ScriptFileName;

    FScriptInstance.Compile();
  end;
end;

procedure TSimbaScriptTab.Pause;
begin
  DebugLn('TSimbaScriptTab.Pause :: ', ScriptTitle, ' ', ScriptFileName);

  if (FScriptInstance <> nil) then
    FScriptInstance.Pause();
end;

procedure TSimbaScriptTab.Stop;
begin
  DebugLn('TSimbaScriptTab.Stop :: ', ScriptTitle, ' ', ScriptFileName);

  if (FScriptInstance <> nil) then
    FScriptInstance.Stop();
end;

constructor TSimbaScriptTab.Create(APageControl: TPageControl);
begin
  inherited Create(APageControl);

  Caption := FScriptTitle;
  ImageIndex := IMAGE_SIMBA;

  FEditor := TSimbaEditor.Create(Self);
  FEditor.Parent := Self;
  FEditor.Align := alClient;
  FEditor.BorderStyle := bsNone;

  FEditor.OnClick := @HandleEditorClick;
  FEditor.OnChange := @HandleEditorChange;
  FEditor.OnClickLink := @HandleEditorLinkClick;
  FEditor.OnSpecialLineMarkup := @HandleEditorSpecialLine;
  FEditor.OnProcessUserCommand := @HandleEditorUserCommand;

  FFunctionList := TSimbaFunctionList.Create(Self);
  FFunctionList.Parent := SimbaFunctionListForm;
  FFunctionList.Align := alClient;

  FFunctionListUpdater := TSimbaFunctionListUpdater.Create(FFunctionList);
  FFunctionListTimer := TTimer.Create(Self);
  FFunctionListTimer.Interval := 750;
  FFunctionListTimer.Enabled := False;
  FFunctionListTimer.OnTimer := @TimerExecute;

  Reset();
end;

destructor TSimbaScriptTab.Destroy;
begin
  FFunctionListTimer.Enabled := False;
  if (FFunctionListUpdater <> nil) then
    FreeAndNil(FFunctionListUpdater);

  if (SimbaScriptTabHistory <> nil) then
    SimbaScriptTabHistory.Clear(Self);

  inherited Destroy();
end;

end.

