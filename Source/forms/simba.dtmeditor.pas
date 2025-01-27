﻿{
  Author: Raymond van Venetië and Merlijn Wajer
  Project: Simba (https://github.com/MerlijnWajer/Simba)
  License: GNU General Public License (https://www.gnu.org/licenses/gpl-3.0)
}
unit simba.dtmeditor;

{$i simba.inc}

interface

uses
  classes, sysutils, fileutil, dividerbevel, forms, controls,
  graphics, dialogs, extctrls, comctrls, stdctrls, menus, lcltype,
  simba.client, simba.dtm, simba.mufasatypes, simba.imagebox, simba.imagebox_bitmap, simba.imagebox_zoom;

type
  TDTMPrintEvent   = procedure(DTM: String) of object;
  TDTMPrintEventEx = procedure(DTM: String) is nested;

  TSimbaDTMEditorForm = class(TForm)
    ButtonUpdateImage: TButton;
    ButtonClearImage: TButton;
    MenuItemUpdateImage: TMenuItem;
    MenuItemClearImage: TMenuItem;
    MenuItemFindDTM: TMenuItem;
    MenuItemPrintDTM: TMenuItem;
    MenuItemOffsetDTM: TMenuItem;
    MenuItemLoadImage: TMenuItem;
    PanelAlignment: TPanel;
    ButtonPrintDTM: TButton;
    FindDTMButton: TButton;
    ButtonDeletePoints: TButton;
    ButtonDebugColor: TButton;
    ButtonDeletePoint: TButton;
    Divider1: TDividerBevel;
    Divider3: TDividerBevel;
    Divider2: TDividerBevel;
    EditPointX: TEdit;
    EditPointY: TEdit;
    EditPointColor: TEdit;
    EditPointTolerance: TEdit;
    EditPointSize: TEdit;
    LabelX: TLabel;
    LabelY: TLabel;
    LabelColor: TLabel;
    LabelTolerance: TLabel;
    LabelSize: TLabel;
    ListBox: TListBox;
    MainMenu: TMainMenu;
    MenuItemImage: TMenuItem;
    PanelTop: TPanel;
    PanelSelectedPoint: TPanel;
    MenuDTM: TMenuItem;
    MenuItemLoadDTM: TMenuItem;
    MenuItemSeperator: TMenuItem;
    MenuItemDebugColor: TMenuItem;
    MenuItemColorRed: TMenuItem;
    MenuItemColorGreen: TMenuItem;
    MenuItemColorBlue: TMenuItem;
    MenuItemColorYellow: TMenuItem;
    PanelMain: TPanel;
    PanelRight: TPanel;
    PointFlashTimer: TTimer;

    procedure ButtonClearImageClick(Sender: TObject);
    procedure ButtonDeletePointsClick(Sender: TObject);
    procedure ButtonDebugColorClick(Sender: TObject);
    procedure ButtonDeletePointClick(Sender: TObject);
    procedure CenterDivider(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure MenuItemOffsetDTMClick(Sender: TObject);
    procedure MenuItemLoadImageClick(Sender: TObject);
    procedure ListBoxSelectionChange(Sender: TObject; User: boolean);
    procedure PanelRightResize(Sender: TObject);
    procedure PointEditChanged(Sender: TObject);
    procedure ButtonPrintDTMClick(Sender: TObject);
    procedure FindDTMClick(Sender: TObject);
    procedure PointFlash(Sender: TObject);
    procedure LoadDTMClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure ChangeDrawColor(Sender: TObject);
    procedure ClientImageMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure ClientImageMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure ClientImageMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure ClientImageClear(Sender: TObject);
    procedure ButtonUpdateImageClick(Sender: TObject);
  protected
    FImageBox: TSimbaImageBox;
    FImageZoom: TSimbaImageBoxZoom;
    FZoomInfo: TLabel;
    FManageClient: Boolean;
    FClient: TClient;
    FDragging: Integer;
    FDebugDTM: TPointArray;
    FDebugColor: TPointArray;

    FOnPrintDTM: TDTMPrintEvent;
    FOnPrintDTMEx: TDTMPrintEventEx;

    FDrawColor: TColor;
    FFlashing: Boolean;
    FLastFlash: UInt64;

    procedure DoPaintArea(Sender: TObject; Bitmap: TSimbaImageBoxBitmap; R: TRect);

    procedure AddPoint(X, Y, Col, Tol, Size: Integer); overload;
    procedure AddPoint(X, Y, Col: Integer); overload;
    procedure EditPoint(Index: Integer; X, Y, Col, Tol, Size: Integer);
    procedure OffsetPoint(Index: Integer; X, Y: Integer);

    function GetPointAt(X, Y: Integer): Integer;
    function GetPoint(Index: Integer): TDTMPoint;
    function GetPoints: TDTMPointArray;
    function GetDTM: TDTM;

    procedure DrawDTM;
  public
    constructor Create(Client: TClient; ManageClient: Boolean); reintroduce;
    constructor Create(Window: TWindowHandle); reintroduce;
    destructor Destroy; override;

    property OnPrintDTM: TDTMPrintEvent read FOnPrintDTM write FOnPrintDTM;
    property OnPrintDTMEx: TDTMPrintEventEx read FOnPrintDTMEx write FOnPrintDTMEx;
  end;

implementation

{$R *.lfm}

uses
  math,
  simba.colormath, simba.windowhandle;

procedure TSimbaDTMEditorForm.ClientImageMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
var
  R, G, B: Byte;
  H, S, L: Extended;
  Point: TDTMPoint;
begin
  FImageZoom.MoveTest(FImageBox, X, Y);

  ColorToRGB(FImageBox.Background.Canvas.Pixels[X, Y], R, G, B);
  ColorToHSL(FImageBox.Background.Canvas.Pixels[X, Y], H, S, L);

  FZoomInfo.Caption := Format('Color: %d', [FImageBox.Background.Canvas.Pixels[X, Y]]) + LineEnding +
                       Format('RGB: %d, %d, %d', [R, G, B])                            + LineEnding +
                       Format('HSL: %.2f, %.2f, %.2f', [H, S, L])                      + LineEnding;

  if (FDragging > -1) then
  begin
    Point := GetPoint(FDragging);

    EditPoint(FDragging, X, Y, FImageBox.Background.Canvas.Pixels[X, Y], Point.Tolerance, Point.AreaSize);
  end;

  if (GetPointAt(X, Y) > -1) then
    FImageBox.Cursor := crHandPoint
  else
    FImageBox.Cursor := crDefault;
end;

procedure TSimbaDTMEditorForm.ClientImageMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  case Button of
    mbLeft:
      begin
        FDragging := GetPointAt(X, Y);

        case FImageBox.Cursor of
          crDefault:
            begin
              AddPoint(X, Y, FImageBox.Background.Canvas.Pixels[X, Y]);

              FImageBox.Cursor := crHandPoint;
            end;

          crHandPoint:
            ListBox.ItemIndex := GetPointAt(X, Y);
        end;
      end;
  end;
end;

procedure TSimbaDTMEditorForm.ClientImageMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if (Button = mbLeft) then
    FDragging := -1;
end;

procedure TSimbaDTMEditorForm.ChangeDrawColor(Sender: TObject);
var
  i: Integer;
begin
  with Sender as TMenuItem do
  begin
    for i := 0 to Parent.Count - 1 do
      if (Parent[i] <> Sender) then
        Parent[i].Checked := False;

    case Caption of
      'Red':    FDrawColor := clRed;
      'Green':  FDrawColor := clGreen;
      'Blue':   FDrawColor := clBlue;
      'Yellow': FDrawColor := clYellow;
    end;
  end;
end;

procedure TSimbaDTMEditorForm.DrawDTM;
begin
  FDebugColor := [];
  FDebugDTM   := [];

  FImageBox.Paint();
end;

function TSimbaDTMEditorForm.GetPointAt(X, Y: Integer): Integer;
var
  Points: TDTMPointArray;
  i: Integer;
begin
  Result := -1;

  Points := GetPoints();

  for i := 0 to High(Points) do
  begin
    if (X >= Points[i].X - Max(1, Points[i].AreaSize)) and (Y >= Points[i].Y - Max(1, Points[i].AreaSize)) and
       (X <= Points[i].X + Max(1, Points[i].AreaSize)) and (Y <= Points[i].Y + Max(1, Points[i].AreaSize)) then
      begin
        Result := i;
        Break;
      end;
  end;
end;

procedure TSimbaDTMEditorForm.ButtonUpdateImageClick(Sender: TObject);
begin
  if not FClient.IOManager.TargetValid() then
    FClient.IOManager.SetDesktop();
  FImageBox.SetBackground(FClient.IOManager);

  DrawDTM();
end;

procedure TSimbaDTMEditorForm.DoPaintArea(Sender: TObject; Bitmap: TSimbaImageBoxBitmap; R: TRect);
var
  Points: TDTMPointArray;
  I: Integer;
  FlashColor: TColor;
begin
  if Length(FDebugDTM) > 0 then
    Bitmap.DrawCrossArray(FDebugDTM, 10, FDrawColor)
  else
  if Length(FDebugColor) > 0 then
    Bitmap.DrawPoints(FDebugColor, FDrawColor)
  else
  begin
    Points := GetPoints();
    for I := 0 to High(Points) do
    begin
      if (Length(Points) > 1) then // Connect to main point
        Bitmap.DrawLine(TPoint.Create(Points[0].X, Points[0].Y),
                        TPoint.Create(Points[I].X, Points[I].Y), clRed);

      with Points[I] do
        Bitmap.DrawBoxFilled(
          TBox.Create(X - AreaSize, Y - AreaSize, X + AreaSize, Y + AreaSize), clYellow
        );
    end;

    if Length(Points) > 0 then
      with Points[0] do
        Bitmap.DrawBoxFilled(
          TBox.Create(X - AreaSize, Y - AreaSize, X + AreaSize, Y + AreaSize), clYellow
        );

    if FFlashing and (GetTickCount64() - FLastFlash > 400) then
    begin
      FLastFlash := GetTickCount64();

      if Odd(PointFlashTimer.Tag) then
        FlashColor := clRed
      else
        FlashColor := clYellow;

      if ListBox.ItemIndex > -1 then
        with GetPoint(ListBox.ItemIndex) do
          Bitmap.DrawBoxFilled(
            TBox.Create(X - AreaSize, Y - AreaSize, X + AreaSize, Y + AreaSize), FlashColor
          );

      PointFlashTimer.Tag := PointFlashTimer.Tag + 1;
    end;
  end;
end;

procedure TSimbaDTMEditorForm.AddPoint(X, Y, Col, Tol, Size: Integer);
begin
  ListBox.ItemIndex := ListBox.Items.Add('%d, %d, %d, %d, %d', [X, Y, Col, Tol, Size]);
  DrawDTM();
end;

procedure TSimbaDTMEditorForm.AddPoint(X, Y, Col: Integer);
begin
  ListBox.ItemIndex := ListBox.Items.Add('%d, %d, %d, 0, 1', [X, Y, Col]);
  DrawDTM();
end;

procedure TSimbaDTMEditorForm.EditPoint(Index: Integer; X, Y, Col, Tol, Size: Integer);
begin
  ListBox.Items[Index] := Format('%d, %d, %d, %d, %d', [X, Y, Col, Tol, Size]);

  if ListBox.ItemIndex = Index then
  begin
    EditPointX.Text := IntToStr(X);
    EditPointY.Text := IntToStr(Y);
    EditPointColor.Text := IntToStr(Col);
    EditPointTolerance.Text := IntToStr(Tol);
    EditPointSize.Text := IntToStr(Size);
  end;

  DrawDTM();
end;

procedure TSimbaDTMEditorForm.OffsetPoint(Index: Integer; X, Y: Integer);
var
  Point: TDTMPoint;
begin
  Point := GetPoint(Index); EditPoint(Index, Point.X + X, Point.Y + Y, Point.Color, Point.Tolerance, Point.AreaSize);
  Point := GetPoint(Index); EditPoint(Index, Point.X + X, Point.Y + Y, Point.Color, Point.Tolerance, Point.AreaSize);
end;

function TSimbaDTMEditorForm.GetPoint(Index: Integer): TDTMPoint;
var
  Items: TStringArray;
begin
  Items := ListBox.Items[Index].Split(', ');

  Result.x := StrToInt(Items[0]);
  Result.y := StrToInt(Items[1]);
  Result.Color := StrToInt(Items[2]);
  Result.Tolerance := StrToInt(Items[3]);
  Result.AreaSize := StrToInt(Items[4]);
 // Result.bp := False;
end;

function TSimbaDTMEditorForm.GetPoints: TDTMPointArray;
var
  i: Integer;
begin
  SetLength(Result, ListBox.Items.Count);
  for i := 0 to High(Result) do
    Result[i] := GetPoint(i);
end;

function TSimbaDTMEditorForm.GetDTM: TDTM;
var
  Points: TDTMPointArray;
  i: Integer;
begin
  Points := GetPoints();

  Result := TDTM.Create();
  for i := 0 to High(Points) do
    Result.AddPoint(Points[i]);
end;

procedure TSimbaDTMEditorForm.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
  CloseAction := caFree;
end;

procedure TSimbaDTMEditorForm.LoadDTMClick(Sender: TObject);
var
  Value: String;
  DTM: TDTM;
  I: Integer;
begin
  Value := '';

  if InputQuery('Open DTM', 'Enter DTM String (DTM will be normalized)', Value) then
  begin
    ButtonDeletePoints.Click();

    if (Pos(#39, Value) > 0) then // in case someone passes more than the actual string value.
    begin
      Value := Copy(Value, Pos(#39, Value) + 1, $FFFFFF);
      Value := Copy(Value, 1, Pos(#39, Value) - 1);
    end;

    DTM := TDTM.Create();

    try
      DTM.LoadFromString(Value);
      for I := 0 to DTM.PointCount - 1 do
        with DTM.Points[I] do
          AddPoint(X, Y, Color, Tolerance, AreaSize);
    except
      ShowMessage('Invalid DTM String: ' + Value);
    end;

    DTM.Free();
  end;
end;

procedure TSimbaDTMEditorForm.PointFlash(Sender: TObject);
begin
  if FFlashing then
    FImageBox.Paint();
end;

procedure TSimbaDTMEditorForm.FindDTMClick(Sender: TObject);
var
  DTM: TDTM;
begin
  ListBox.ClearSelection();

  DTM := GetDTM();
  try
    FDebugColor := [];
    FDebugDTM   := FImageBox.FindDTMs(DTM);

    FImageBox.Paint();
  finally
    DTM.Free();
  end;
end;

procedure TSimbaDTMEditorForm.ButtonPrintDTMClick(Sender: TObject);
var
  DTM: TDTM;
begin
  DTM := GetDTM();

  try
    if Assigned(OnPrintDTM) then
      OnPrintDTM(DTM.SaveToString());
    if Assigned(OnPrintDTMEx) then
      OnPrintDTMEx(DTM.SaveToString());
  finally
    DTM.Free();
  end;
end;

procedure TSimbaDTMEditorForm.ListBoxSelectionChange(Sender: TObject; User: boolean);
begin
  if (ListBox.ItemIndex > -1) then
  begin
    FFlashing := True;

    PanelSelectedPoint.Enabled := True;

    with GetPoint(ListBox.ItemIndex) do
    begin
      if not FImageBox.IsVisible(X, Y) then
        FImageBox.MoveTo(X, Y);

      EditPointX.Text := IntToStr(X);
      EditPointY.Text := IntToStr(Y);
      EditPointColor.Text := IntToStr(Color);
      EditPointTolerance.Text := IntToStr(Tolerance);
      EditPointSize.Text := IntToStr(AreaSize);
    end;
  end else
    PanelSelectedPoint.Enabled := False;

  DrawDTM();
end;

procedure TSimbaDTMEditorForm.PanelRightResize(Sender: TObject);
begin
  PanelRight.Constraints.MinWidth := PanelRight.Width;
end;

procedure TSimbaDTMEditorForm.ButtonDebugColorClick(Sender: TObject);
begin
  if ListBox.ItemIndex > -1 then
    with GetPoint(ListBox.ItemIndex) do
    begin
      FFlashing := False;

      FDebugDTM   := [];
      FDebugColor := FImageBox.FindColors(1, Color, Tolerance);

      FImageBox.Paint();
    end;
end;

procedure TSimbaDTMEditorForm.ButtonDeletePointClick(Sender: TObject);
begin
  if ListBox.ItemIndex > -1 then
  begin
    ListBox.DeleteSelected();
    ListBox.OnSelectionChange(Self, False);
  end;
end;

procedure TSimbaDTMEditorForm.CenterDivider(Sender: TObject);
var
  Divider: TDividerBevel absolute Sender;
begin
  Divider.LeftIndent := (Divider.Width div 2) - (Divider.Canvas.TextWidth(Divider.Caption) div 2) - Divider.CaptionSpacing;
end;

procedure TSimbaDTMEditorForm.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if (Key = VK_DELETE) then
  begin
    ButtonDeletePoint.Click();

    Key := VK_UNKNOWN;
  end;
end;

procedure TSimbaDTMEditorForm.MenuItemOffsetDTMClick(Sender: TObject);
var
  Values: array[0..1] of String;
  X, Y, I: Integer;
begin
  Values[0] := '0';
  Values[1] := '0';

  if InputQuery('Offset DTM', ['X Offset', 'Y Offset'], Values) then
  begin
    X := StrToIntDef(Values[0], 0);
    Y := StrToIntDef(Values[1], 0);

    for I := 0 to ListBox.Count - 1 do
      OffsetPoint(I, X, Y);
  end;
end;

procedure TSimbaDTMEditorForm.MenuItemLoadImageClick(Sender: TObject);
begin
  with TOpenDialog.Create(Self) do
  try
    InitialDir := Application.Location;

    if Execute() then
    try
      FImageBox.SetBackground(FileName);
    except
    end;
  finally
    Free();
  end;
end;

procedure TSimbaDTMEditorForm.ButtonClearImageClick(Sender: TObject);
begin
  DrawDTM();
end;

procedure TSimbaDTMEditorForm.ButtonDeletePointsClick(Sender: TObject);
begin
  ListBox.Clear();
  ListBox.OnSelectionChange(Self, False);
end;

procedure TSimbaDTMEditorForm.PointEditChanged(Sender: TObject);
var
  X, Y, Col, Tol, Size: Integer;
  Point: TDTMPoint;
begin
  if (ListBox.ItemIndex > -1) and (TEdit(Sender).Text <> '') then
  begin
    Point := GetPoint(ListBox.ItemIndex);

    X := StrToIntDef(EditPointX.Text, Point.X);
    Y := StrToIntDef(EditPointY.Text, Point.Y);
    Col := StrToIntDef(EditPointColor.Text, Point.Color);
    Tol := StrToIntDef(EditPointTolerance.Text, Point.Tolerance);
    Size := StrToIntDef(EditPointSize.Text, Point.AreaSize);

    EditPoint(ListBox.ItemIndex, X, Y, Col, Tol, Size);
  end;
end;

procedure TSimbaDTMEditorForm.ClientImageClear(Sender: TObject);
begin
  DrawDTM();
end;

destructor TSimbaDTMEditorForm.Destroy;
begin
  if FManageClient and (FClient <> nil) then
    FreeAndNil(FClient);

  inherited Destroy();
end;

constructor TSimbaDTMEditorForm.Create(Client: TClient; ManageClient: Boolean);
begin
  inherited Create(Application.MainForm);

  FDrawColor := clRed;
  FDragging := -1;

  FImageBox := TSimbaImageBox.Create(Self);
  FImageBox.Parent := PanelMain;
  FImageBox.Align := alClient;
  FImageBox.OnPaintArea := @DoPaintArea;
  FImageBox.OnMouseDown := @ClientImageMouseDown;
  FImageBox.OnMouseMove := @ClientImageMouseMove;
  FImageBox.OnMouseUp := @ClientImageMouseUp;

  FImageZoom := TSimbaImageBoxZoom.Create(Self);
  FImageZoom.Parent := PanelTop;
  FImageZoom.SetZoom(4, 5);
  FImageZoom.BorderSpacing.Around := 10;

  FZoomInfo := TLabel.Create(Self);
  FZoomInfo.Parent := PanelTop;
  FZoomInfo.BorderSpacing.Right := 10;
  FZoomInfo.AnchorToNeighbour(akLeft, 10, FImageZoom);

  FManageClient := ManageClient;
  FClient := Client;

  FImageBox.SetBackground(FClient.IOManager);
end;

constructor TSimbaDTMEditorForm.Create(Window: TWindowHandle);
var
  Client: TClient;
begin
  Client := TClient.Create();
  if (Window > 0) and Window.IsValid() then
    Client.IOManager.SetTarget(Window);

  Create(Client, True);
end;

end.
