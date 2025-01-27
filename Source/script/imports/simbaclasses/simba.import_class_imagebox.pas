unit simba.import_class_imagebox;

{$i simba.inc}

interface

implementation

uses
  classes, sysutils, controls, extctrls, comctrls, graphics, lptypes, ffi,
  simba.script_compiler, simba.mufasatypes, simba.imagebox, simba.imagebox_bitmap, simba.bitmap, simba.dtm, simba.iomanager;

type
  PComponent = ^TComponent;
  PCursor = ^TCursor;
  PNotifyEvent = ^TNotifyEvent;
  PMouseMoveEvent = ^TMouseMoveEvent;
  PMouseEvent = ^TMouseEvent;
  PStatusBar = ^TStatusBar;
  PStatusPanel = ^TStatusPanel;
  PBitmap = ^TBitmap;

procedure _LapeSimbaImageBoxBitmap_DrawLineGap(const Params: PParamArray); LAPE_WRAPPER_CALLING_CONV
begin
  PSimbaImageBoxBitmap(Params^[0])^.DrawLineGap(PPoint(Params^[1])^, PPoint(Params^[2])^, PInteger(Params^[3])^, PColor(Params^[4])^);
end;

procedure _LapeSimbaImageBoxBitmap_DrawLine(const Params: PParamArray); LAPE_WRAPPER_CALLING_CONV
begin
  PSimbaImageBoxBitmap(Params^[0])^.DrawLine(PPoint(Params^[1])^, PPoint(Params^[2])^, PColor(Params^[3])^);
end;

procedure _LapeSimbaImageBoxBitmap_DrawCross(const Params: PParamArray); LAPE_WRAPPER_CALLING_CONV
begin
  PSimbaImageBoxBitmap(Params^[0])^.DrawCross(PPoint(Params^[1])^, PInteger(Params^[2])^, PColor(Params^[3])^);
end;

procedure _LapeSimbaImageBoxBitmap_DrawCrossArray(const Params: PParamArray); LAPE_WRAPPER_CALLING_CONV
begin
  PSimbaImageBoxBitmap(Params^[0])^.DrawCrossArray(PPointArray(Params^[1])^, PInteger(Params^[2])^, PColor(Params^[3])^);
end;

procedure _LapeSimbaImageBoxBitmap_DrawCrossHair(const Params: PParamArray); LAPE_WRAPPER_CALLING_CONV
begin
  PSimbaImageBoxBitmap(Params^[0])^.DrawCrosshair(PPoint(Params^[1])^, PInteger(Params^[2])^, PColor(Params^[3])^);
end;

procedure _LapeSimbaImageBoxBitmap_DrawBox(const Params: PParamArray); LAPE_WRAPPER_CALLING_CONV
begin
  PSimbaImageBoxBitmap(Params^[0])^.DrawBox(PBox(Params^[1])^, PColor(Params^[2])^);
end;

procedure _LapeSimbaImageBoxBitmap_DrawBoxFilled(const Params: PParamArray); LAPE_WRAPPER_CALLING_CONV
begin
  PSimbaImageBoxBitmap(Params^[0])^.DrawBoxFilled(PBox(Params^[1])^, PColor(Params^[2])^);
end;

procedure _LapeSimbaImageBoxBitmap_DrawPoly(const Params: PParamArray); LAPE_WRAPPER_CALLING_CONV
begin
  PSimbaImageBoxBitmap(Params^[0])^.DrawPoly(PPointArray(Params^[1])^, PBoolean(Params^[2])^, PColor(Params^[3])^);
end;

procedure _LapeSimbaImageBoxBitmap_DrawPoint(const Params: PParamArray); LAPE_WRAPPER_CALLING_CONV
begin
  PSimbaImageBoxBitmap(Params^[0])^.DrawPoint(PPoint(Params^[1])^, PColor(Params^[2])^);
end;

procedure _LapeSimbaImageBoxBitmap_DrawPoints(const Params: PParamArray); LAPE_WRAPPER_CALLING_CONV
begin
  PSimbaImageBoxBitmap(Params^[0])^.DrawPoints(PPointArray(Params^[1])^, PColor(Params^[2])^);
end;

procedure _LapeSimbaImageBoxBitmap_DrawCircle(const Params: PParamArray); LAPE_WRAPPER_CALLING_CONV
begin
  PSimbaImageBoxBitmap(Params^[0])^.DrawCircle(PPoint(Params^[1])^, PInteger(Params^[2])^, PColor(Params^[3])^);
end;

procedure _LapeSimbaImageBoxBitmap_DrawCircleFilled(const Params: PParamArray); LAPE_WRAPPER_CALLING_CONV
begin
  PSimbaImageBoxBitmap(Params^[0])^.DrawCircleFilled(PPoint(Params^[1])^, PInteger(Params^[2])^, PColor(Params^[3])^);
end;

procedure _LapeSimbaImageBoxBitmap_DrawBoxTransparent(const Params: PParamArray); LAPE_WRAPPER_CALLING_CONV
begin
  PSimbaImageBoxBitmap(Params^[0])^.DrawBoxTransparent(PBox(Params^[1])^, PColor(Params^[2])^, PSingle(Params^[3])^);
end;

procedure _LapeSimbaImageBoxBitmap_DrawEllipse(const Params: PParamArray); LAPE_WRAPPER_CALLING_CONV
begin
  PSimbaImageBoxBitmap(Params^[0])^.DrawEllipse(PPoint(Params^[1])^, PInteger(Params^[2])^, PInteger(Params^[3])^, PColor(Params^[4])^);
end;

procedure _LapeSimbaImageBox_Zoom_Read(const Params: PParamArray; const Result: Pointer); LAPE_WRAPPER_CALLING_CONV
begin
  PSingle(Result)^ := PSimbaImageBox(Params^[0])^.Zoom;
end;

procedure _LapeSimbaImageBox_Zoom_Write(const Params: PParamArray); LAPE_WRAPPER_CALLING_CONV
begin
  PSimbaImageBox(Params^[0])^.Zoom := PSingle(Params^[1])^;
end;

procedure _LapeSimbaImageBox_StatusBar_Read(const Params: PParamArray; const Result: Pointer); LAPE_WRAPPER_CALLING_CONV
begin
  PStatusBar(Result)^ := PSimbaImageBox(Params^[0])^.StatusBar;
end;

procedure _LapeSimbaImageBox_StatusPanel_Read(const Params: PParamArray; const Result: Pointer); LAPE_WRAPPER_CALLING_CONV
begin
  PStatusPanel(Result)^ := PSimbaImageBox(Params^[0])^.StatusPanel;
end;

procedure _LapeSimbaImageBox_OnPaintArea_Read(const Params: PParamArray; const Result: Pointer); LAPE_WRAPPER_CALLING_CONV
begin
  PSimbaImageBoxPaintAreaEvent(Result)^ := PSimbaImageBox(Params^[0])^.OnPaintArea;
end;

procedure _LapeSimbaImageBox_OnPaintArea_Write(const Params: PParamArray); LAPE_WRAPPER_CALLING_CONV
begin
  PSimbaImageBox(Params^[0])^.OnPaintArea := PSimbaImageBoxPaintAreaEvent(Params^[1])^;
end;

procedure _LapeSimbaImageBox_MoveTo(const Params: PParamArray); LAPE_WRAPPER_CALLING_CONV
begin
  PSimbaImageBox(Params^[0])^.MoveTo(PInteger(Params^[1])^, PInteger(Params^[2])^);
end;

procedure _LapeSimbaImageBox_IsVisible(const Params: PParamArray; const Result: Pointer); LAPE_WRAPPER_CALLING_CONV
begin
  PBoolean(Result)^ := PSimbaImageBox(Params^[0])^.IsVisible(PInteger(Params^[1])^, PInteger(Params^[2])^);
end;

procedure _LapeSimbaImageBox_Paint(const Params: PParamArray); LAPE_WRAPPER_CALLING_CONV
begin
  PSimbaImageBox(Params^[0])^.Paint();
end;

procedure _LapeSimbaImageBox_SetBackground_Data(const Params: PParamArray); LAPE_WRAPPER_CALLING_CONV
begin
  PSimbaImageBox(Params^[0])^.SetBackground(PPRGB32(Params^[1])^, PInteger(Params^[2])^, PInteger(Params^[3])^);
end;

procedure _LapeSimbaImageBox_SetBackground_FileName(const Params: PParamArray); LAPE_WRAPPER_CALLING_CONV
begin
  PSimbaImageBox(Params^[0])^.SetBackground(PString(Params^[1])^);
end;

procedure _LapeSimbaImageBox_SetBackground_Bitmap(const Params: PParamArray); LAPE_WRAPPER_CALLING_CONV
begin
  PSimbaImageBox(Params^[0])^.SetBackground(PMufasaBitmap(Params^[1])^);
end;

procedure _LapeSimbaImageBox_SetBackground_IOManagerArea(const Params: PParamArray); LAPE_WRAPPER_CALLING_CONV
begin
  PSimbaImageBox(Params^[0])^.SetBackground(PIOManager(Params^[1])^, PInteger(Params^[2])^, PInteger(Params^[3])^, PInteger(Params^[4])^, PInteger(Params^[5])^);
end;

procedure _LapeSimbaImageBox_SetBackground_IOManager(const Params: PParamArray); LAPE_WRAPPER_CALLING_CONV
begin
  PSimbaImageBox(Params^[0])^.SetBackground(PIOManager(Params^[1])^);
end;

procedure _LapeSimbaImageBox_Init(const Params: PParamArray); LAPE_WRAPPER_CALLING_CONV
begin
  PSimbaImageBox(Params^[0])^ := TSimbaImageBox.Create(PComponent(Params^[1])^);
end;

procedure _LapeSimbaImageBox_Free(const Params: PParamArray); LAPE_WRAPPER_CALLING_CONV
begin
  PSimbaImageBox(Params^[0])^.Free();
end;

procedure _LapeSimbaImageBox_Cursor_Read(const Params: PParamArray; const Result: Pointer); LAPE_WRAPPER_CALLING_CONV
begin
  PCursor(Result)^ := PSimbaImageBox(Params^[0])^.Cursor;
end;

procedure _LapeSimbaImageBox_Cursor_Write(const Params: PParamArray; const Result: Pointer); LAPE_WRAPPER_CALLING_CONV
begin
  PSimbaImageBox(Params^[0])^.Cursor := PCursor(Params^[1])^;
end;

procedure _LapeSimbaImageBox_OnMouseMove_Read(const Params: PParamArray; const Result: Pointer); LAPE_WRAPPER_CALLING_CONV
begin
  PMouseMoveEvent(Result)^ := PSimbaImageBox(Params^[0])^.OnMouseMove;
end;

procedure _LapeSimbaImageBox_OnMouseMove_Write(const Params: PParamArray; const Result: Pointer); LAPE_WRAPPER_CALLING_CONV
begin
  PSimbaImageBox(Params^[0])^.OnMouseMove := PMouseMoveEvent(Params^[1])^;
end;

procedure _LapeSimbaImageBox_OnMouseDown_Read(const Params: PParamArray; const Result: Pointer); LAPE_WRAPPER_CALLING_CONV
begin
  PMouseEvent(Result)^ := PSimbaImageBox(Params^[0])^.OnMouseDown;
end;

procedure _LapeSimbaImageBox_OnMouseDown_Write(const Params: PParamArray; const Result: Pointer); LAPE_WRAPPER_CALLING_CONV
begin
  PSimbaImageBox(Params^[0])^.OnMouseDown := PMouseEvent(Params^[1])^;
end;

procedure _LapeSimbaImageBox_OnMouseUp_Read(const Params: PParamArray; const Result: Pointer); LAPE_WRAPPER_CALLING_CONV
begin
  PMouseEvent(Result)^ := PSimbaImageBox(Params^[0])^.OnMouseUp;
end;

procedure _LapeSimbaImageBox_OnMouseUp_Write(const Params: PParamArray; const Result: Pointer); LAPE_WRAPPER_CALLING_CONV
begin
  PSimbaImageBox(Params^[0])^.OnMouseUp := PMouseEvent(Params^[1])^;
end;

procedure _LapeSimbaImageBox_OnMouseEnter_Read(const Params: PParamArray; const Result: Pointer); LAPE_WRAPPER_CALLING_CONV
begin
  PNotifyEvent(Result)^ := PSimbaImageBox(Params^[0])^.OnMouseEnter;
end;

procedure _LapeSimbaImageBox_OnMouseEnter_Write(const Params: PParamArray; const Result: Pointer); LAPE_WRAPPER_CALLING_CONV
begin
  PSimbaImageBox(Params^[0])^.OnMouseEnter := PNotifyEvent(Params^[1])^;
end;

procedure _LapeSimbaImageBox_OnMouseLeave_Read(const Params: PParamArray; const Result: Pointer); LAPE_WRAPPER_CALLING_CONV
begin
  PNotifyEvent(Result)^ := PSimbaImageBox(Params^[0])^.OnMouseLeave;
end;

procedure _LapeSimbaImageBox_OnMouseLeave_Write(const Params: PParamArray; const Result: Pointer); LAPE_WRAPPER_CALLING_CONV
begin
  PSimbaImageBox(Params^[0])^.OnMouseLeave := PNotifyEvent(Params^[1])^;
end;

procedure _LapeSimbaImageBox_OnDblClick_Read(const Params: PParamArray; const Result: Pointer); LAPE_WRAPPER_CALLING_CONV
begin
  PNotifyEvent(Result)^ := PSimbaImageBox(Params^[0])^.OnDblClick;
end;

procedure _LapeSimbaImageBox_OnDblClick_Write(const Params: PParamArray; const Result: Pointer); LAPE_WRAPPER_CALLING_CONV
begin
  PSimbaImageBox(Params^[0])^.OnDblClick := PNotifyEvent(Params^[1])^;
end;

procedure _LapeSimbaImageBox_MousePoint_Read(const Params: PParamArray; const Result: Pointer); LAPE_WRAPPER_CALLING_CONV
begin
  PPoint(Result)^ := PSimbaImageBox(Params^[0])^.MousePoint;
end;

procedure _LapeSimbaImageBox_Background_Read(const Params: PParamArray; const Result: Pointer); LAPE_WRAPPER_CALLING_CONV
begin
  PBitmap(Result)^ := PSimbaImageBox(Params^[0])^.Background;
end;

procedure _LapeSimbaImageBox_FindDTMs(const Params: PParamArray; const Result: Pointer); LAPE_WRAPPER_CALLING_CONV
begin
  PPointArray(Result)^ := PSimbaImageBox(Params^[0])^.FindDTMs(PDTM(Params^[1])^);
end;

procedure _LapeSimbaImageBox_FindColors(const Params: PParamArray; const Result: Pointer); LAPE_WRAPPER_CALLING_CONV
begin
  PPointArray(Result)^ := PSimbaImageBox(Params^[0])^.FindColors(PInteger(Params^[1])^, PInteger(Params^[2])^, PInteger(Params^[3])^, PExtended(Params^[4])^, PExtended(Params^[5])^);
end;

procedure ImportSimbaImageBox(Compiler: TSimbaScript_Compiler);
begin
  with Compiler do
  begin
    addClass('TSimbaImageBoxBitmap');

    addGlobalFunc('procedure TSimbaImageBoxBitmap.DrawLineGap(Start, Stop: TPoint; Gap: Integer; Color: TColor);', @_LapeSimbaImageBoxBitmap_DrawLineGap);
    addGlobalFunc('procedure TSimbaImageBoxBitmap.DrawLine(Start, Stop: TPoint; Color: TColor);', @_LapeSimbaImageBoxBitmap_DrawLine);
    addGlobalFunc('procedure TSimbaImageBoxBitmap.DrawCross(Center: TPoint; Radius: Integer; Color: TColor);', @_LapeSimbaImageBoxBitmap_DrawCross);
    addGlobalFunc('procedure TSimbaImageBoxBitmap.DrawCrossArray(Centers: TPointArray; Radius: Integer; Color: TColor);', @_LapeSimbaImageBoxBitmap_DrawCrossArray);
    addGlobalFunc('procedure TSimbaImageBoxBitmap.DrawCrossHair(Center: TPoint; Radius: Integer; Color: TColor);', @_LapeSimbaImageBoxBitmap_DrawCrossHair);
    addGlobalFunc('procedure TSimbaImageBoxBitmap.DrawBox(Box: TBox; Color: TColor);', @_LapeSimbaImageBoxBitmap_DrawBox);
    addGlobalFunc('procedure TSimbaImageBoxBitmap.DrawBoxFilled(Box: TBox; Color: TColor);', @_LapeSimbaImageBoxBitmap_DrawBoxFilled);
    addGlobalFunc('procedure TSimbaImageBoxBitmap.DrawPoly(Poly: TPointArray; Connect: Boolean; Color: TColor);', @_LapeSimbaImageBoxBitmap_DrawPoly);
    addGlobalFunc('procedure TSimbaImageBoxBitmap.DrawPoint(P: TPoint; Color: TColor);', @_LapeSimbaImageBoxBitmap_DrawPoint);
    addGlobalFunc('procedure TSimbaImageBoxBitmap.DrawPoints(TPA: TPointArray; Color: TColor);', @_LapeSimbaImageBoxBitmap_DrawPoints);
    addGlobalFunc('procedure TSimbaImageBoxBitmap.DrawCircle(Center: TPoint; Radius: Integer; Color: TColor);', @_LapeSimbaImageBoxBitmap_DrawCircle);
    addGlobalFunc('procedure TSimbaImageBoxBitmap.DrawCircleFilled(Center: TPoint; Radius: Integer; Color: TColor);', @_LapeSimbaImageBoxBitmap_DrawCircleFilled);
    addGlobalFunc('procedure TSimbaImageBoxBitmap.DrawBoxTransparent(Box: TBox; Color: TColor; Transparency: Single);', @_LapeSimbaImageBoxBitmap_DrawBoxTransparent);
    addGlobalFunc('procedure TSimbaImageBoxBitmap.DrawEllipse(Center: TPoint; RadiusX, RadiusY: Integer; Color: TColor);', @_LapeSimbaImageBoxBitmap_DrawEllipse);

    addCallbackType('TSimbaImageBoxPaintAreaEvent = procedure(Sender: TObject; Bitmap: TSimbaImageBoxBitmap; Rect: TRect) of object');

    addClass('TSimbaImageBox', 'TWinControl');

    addClassVar('TSimbaImageBox', 'MousePoint', 'TPoint', @_LapeSimbaImageBox_MousePoint_Read);
    addClassVar('TSimbaImageBox', 'Background', 'TBitmap', @_LapeSimbaImageBox_Background_Read);
    addClassVar('TSimbaImageBox', 'Zoom', 'Single', @_LapeSimbaImageBox_Zoom_Read, @_LapeSimbaImageBox_Zoom_Write);
    addClassVar('TSimbaImageBox', 'StatusBar', 'TStatusBar', @_LapeSimbaImageBox_StatusBar_Read);
    addClassVar('TSimbaImageBox', 'StatusPanel', 'TStatusPanel', @_LapeSimbaImageBox_StatusPanel_Read);
    addClassVar('TSimbaImageBox', 'OnMouseMove', 'TMouseMoveEvent', @_LapeSimbaImageBox_OnMouseMove_Read, @_LapeSimbaImageBox_OnMouseMove_Write);
    addClassVar('TSimbaImageBox', 'OnMouseDown', 'TMouseEvent', @_LapeSimbaImageBox_OnMouseDown_Read, @_LapeSimbaImageBox_OnMouseDown_Write);
    addClassVar('TSimbaImageBox', 'OnMouseUp', 'TMouseEvent', @_LapeSimbaImageBox_OnMouseUp_Read, @_LapeSimbaImageBox_OnMouseUp_Write);
    addClassVar('TSimbaImageBox', 'OnMouseLeave', 'TNotifyEvent', @_LapeSimbaImageBox_OnMouseLeave_Read, @_LapeSimbaImageBox_OnMouseLeave_Write);
    addClassVar('TSimbaImageBox', 'OnMouseEnter', 'TNotifyEvent', @_LapeSimbaImageBox_OnMouseEnter_Read, @_LapeSimbaImageBox_OnMouseEnter_Write);
    addClassVar('TSimbaImageBox', 'OnDblClick', 'TNotifyEvent', @_LapeSimbaImageBox_OnDblClick_Read, @_LapeSimbaImageBox_OnDblClick_Write);
    addClassVar('TSimbaImageBox', 'OnPaintArea', 'TSimbaImageBoxPaintAreaEvent', @_LapeSimbaImageBox_OnPaintArea_Read, @_LapeSimbaImageBox_OnPaintArea_Write);

    addGlobalFunc('procedure TSimbaImageBox.MoveTo(X, Y: Integer);', @_LapeSimbaImageBox_MoveTo);
    addGlobalFunc('function TSimbaImageBox.IsVisible(X, Y: Integer): Boolean;', @_LapeSimbaImageBox_IsVisible);
    addGlobalFunc('procedure TSimbaImageBox.Paint;', @_LapeSimbaImageBox_Paint);
    addGlobalFunc('procedure TSimbaImageBox.SetBackground(Data: PRGB32; AWidth, AHeight: Integer); overload;', @_LapeSimbaImageBox_SetBackground_Data);
    addGlobalFunc('procedure TSimbaImageBox.SetBackground(FileName: String); overload;', @_LapeSimbaImageBox_SetBackground_FileName);
    addGlobalFunc('procedure TSimbaImageBox.SetBackground(Bitmap: TMufasaBitmap); overload;', @_LapeSimbaImageBox_SetBackground_Bitmap);
    addGlobalFunc('procedure TSimbaImageBox.SetBackground(IOManager: TIOManager; X1, Y1, X2, Y2: Integer); overload;', @_LapeSimbaImageBox_SetBackground_IOManagerArea);
    addGlobalFunc('procedure TSimbaImageBox.SetBackground(IOManager: TIOManager); overload;', @_LapeSimbaImageBox_SetBackground_IOManager);
    addGlobalFunc('function TSimbaImageBox.FindColors(CTS: Integer; Col, Tol: Integer; HueMod: Extended = 0.2; SatMod: Extended = 0.2): TPointArray;', @_LapeSimbaImageBox_FindColors);
    addGlobalFunc('function TSimbaImageBox.FindDTM(DTM: TDTM): TPointArray;', @_LapeSimbaImageBox_FindDTMs);
    addGlobalFunc('procedure TSimbaImageBox.Init(Owner: TComponent); override', @_LapeSimbaImageBox_Init);
  end;
end;

initialization
  TSimbaScript_Compiler.RegisterImport(@ImportSimbaImageBox);

end.

