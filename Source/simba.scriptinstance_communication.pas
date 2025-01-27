{
  Author: Raymond van Venetië and Merlijn Wajer
  Project: Simba (https://github.com/MerlijnWajer/Simba)
  License: GNU General Public License (https://www.gnu.org/licenses/gpl-3.0)
}
unit simba.scriptinstance_communication;

{$i simba.inc}

interface

uses
  classes, sysutils, forms, extctrls, graphics,
  simba.ipc, simba.mufasatypes;

type
  TSimbaScriptInstanceCommunication = class(TSimbaIPCServer)
  protected
    FScriptInstance: TObject;
    FMethods: array[ESimbaCommunicationMessage] of TProc;
    FParams: TMemoryStream;
    FResult: TMemoryStream;

    procedure OnMessage(MessageID: Integer; Params, Result: TMemoryStream); override;

    procedure Disguise;
    procedure Status;

    procedure ShowTrayNotification;

    procedure GetSimbaPID;
    procedure GetSimbaTargetWindow;
    procedure GetSimbaTargetPID;

    procedure ScriptStateChanged;
    procedure ScriptError;

    procedure DebugImage_SetMaxSize;
    procedure DebugImage_MoveTo;
    procedure DebugImage_Show;
    procedure DebugImage_Update;
    procedure DebugImage_Hide;
    procedure DebugImage_Display;
    procedure DebugImage_DisplayXY;

    procedure DebugMethodName;
    procedure DebugEvents;
  public
    constructor Create(ScriptInstance: TObject); reintroduce;
  end;

implementation

uses
  simba.scriptinstance, simba.bitmap_misc, simba.main, simba.debugimageform;

procedure TSimbaScriptInstanceCommunication.OnMessage(MessageID: Integer; Params, Result: TMemoryStream);
var
  Message: ESimbaCommunicationMessage absolute MessageID;
begin
  FParams := Params;
  FResult := Result;

  FMethods[Message]();
end;

procedure TSimbaScriptInstanceCommunication.Disguise;

  procedure Execute;
  begin
    SimbaForm.Caption := FParams.ReadAnsiString();
  end;

begin
  Sync(@Execute);
end;

procedure TSimbaScriptInstanceCommunication.Status;

  procedure Execute;
  begin
    SimbaForm.StatusPanelFileName.Caption := FParams.ReadAnsiString();
  end;

begin
  Sync(@Execute);
end;

procedure TSimbaScriptInstanceCommunication.ShowTrayNotification;
var
  Title, Hint: String;
  Timeout: Integer;

  procedure Execute;
  begin
    SimbaForm.TrayIcon.BalloonTitle   := Title;
    SimbaForm.TrayIcon.BalloonHint    := Hint;
    SimbaForm.TrayIcon.BalloonTimeout := Timeout;
    SimbaForm.TrayIcon.ShowBalloonHint();
  end;

begin
  Title := FParams.ReadAnsiString;
  Hint  := FParams.ReadAnsiString;

  FParams.Read(Timeout, SizeOf(Integer));

  Sync(@Execute);
end;

// Threadsafe
procedure TSimbaScriptInstanceCommunication.GetSimbaPID;
begin
  FResult.Write(GetProcessID(), SizeOf(PtrUInt));
end;

// Threadsafe
procedure TSimbaScriptInstanceCommunication.GetSimbaTargetWindow;
begin
  FResult.Write(SimbaForm.WindowSelection, SizeOf(PtrUInt));
end;

// Threadsafe
procedure TSimbaScriptInstanceCommunication.GetSimbaTargetPID;
begin
  FResult.Write(SimbaForm.ProcessSelection, SizeOf(PtrUInt));
end;

procedure TSimbaScriptInstanceCommunication.ScriptStateChanged;
var
  State: ESimbaScriptState;

  procedure Execute;
  begin
    TSimbaScriptInstance(FScriptInstance).State := State;
  end;

begin
  FParams.Read(State, SizeOf(ESimbaScriptState));

  Sync(@Execute);
end;

procedure TSimbaScriptInstanceCommunication.ScriptError;
var
  Error: TSimbaScriptError;

  procedure Execute;
  begin
    TSimbaScriptInstance(FScriptInstance).Error := Error;
  end;

begin
  Error.Message  := FParams.ReadAnsiString();
  Error.FileName := FParams.ReadAnsiString();

  FParams.Read(Error.Line, SizeOf(Integer));
  FParams.Read(Error.Column, SizeOf(Integer));

  Sync(@Execute);
end;

procedure TSimbaScriptInstanceCommunication.DebugImage_SetMaxSize;
var
  Width, Height: Integer;

  procedure Execute;
  begin
    SimbaDebugImageForm.SetMaxSize(Width, Height);
  end;

begin
  FParams.Read(Width, SizeOf(Integer));
  FParams.Read(Height, SizeOf(Integer));

  Sync(@Execute);
end;

procedure TSimbaScriptInstanceCommunication.DebugImage_MoveTo;
var
  X, Y: Integer;

  procedure Execute;
  begin
    SimbaDebugImageForm.ImageBox.MoveTo(X, Y);
  end;

begin
  FParams.Read(X, SizeOf(Integer));
  FParams.Read(Y, SizeOf(Integer));

  Sync(@Execute);
end;

procedure TSimbaScriptInstanceCommunication.DebugImage_Show;
var
  EnsureVisible: Boolean;

  procedure Execute;
  begin
    DebugImage_Update();

    with SimbaDebugImageForm.ImageBox do
      SimbaDebugImageForm.SetSize(Background.Width, Background.Height, False, EnsureVisible);
  end;

begin
  FInputStream.Read(EnsureVisible, SizeOf(Boolean));

  Sync(@Execute);
end;

// Chunked data is sent. Row by row.
procedure TSimbaScriptInstanceCommunication.DebugImage_Update;

  // Modified from TBitmapHelper.FromData in simba.bitmap_misc
  procedure Execute;
  var
    Width, Height: Integer;
    Source, Dest: PByte;
    SourceUpper: PtrUInt;
    DestBytesPerLine, SourceBytesPerLine: Integer;
    SourcePtr, DestPtr: PByte;

    procedure BGR;
    type
      PRGB24 = ^TRGB24;
      TRGB24 = packed record
        B, G, R : Byte;
      end;
    var
      Y: Integer;
    begin
      for Y := 0 to Height - 1 do
      begin
        FInputStream.Read(Source^, SourceBytesPerLine);

        SourcePtr := Source;
        DestPtr   := Dest;

        while (PtrUInt(SourcePtr) < SourceUpper) do
        begin
          PRGB24(DestPtr)^ := PRGB24(SourcePtr)^; // Can just use first three bytes

          Inc(SourcePtr, SizeOf(TRGB32));
          Inc(DestPtr, SizeOf(TRGB24));
        end;

        Inc(Dest, DestBytesPerLine);
      end;
    end;

    procedure BGRA;
    var
      Y: Integer;
    begin
      for Y := 0 to Height - 1 do
      begin
        FInputStream.Read(Source^, SourceBytesPerLine);

        Move(Source^, Dest^, DestBytesPerLine);
        Inc(Dest, DestBytesPerLine);
      end;
    end;

    procedure ARGB;
    type
      PARGB = ^TARGB;
      TARGB = packed record
        A, R, G, B: Byte;
      end;
    var
      Y: Integer;
    begin
      for Y := 0 to Height - 1 do
      begin
        FInputStream.Read(Source^, SourceBytesPerLine);

        SourcePtr := Source;
        DestPtr   := Dest;

        while (PtrUInt(SourcePtr) < SourceUpper) do
        begin
          PARGB(DestPtr)^.R := PRGB32(SourcePtr)^.R;
          PARGB(DestPtr)^.G := PRGB32(SourcePtr)^.G;
          PARGB(DestPtr)^.B := PRGB32(SourcePtr)^.B;
          PARGB(DestPtr)^.A := PRGB32(SourcePtr)^.A;

          Inc(SourcePtr, SizeOf(TRGB32));
          Inc(DestPtr, SizeOf(TARGB));
        end;

        Inc(Dest, DestBytesPerLine);
      end;
    end;
  var
    Bitmap: TBitmap;
  begin
    FInputStream.Read(Width, SizeOf(Integer));
    FInputStream.Read(Height, SizeOf(Integer));

    Bitmap := SimbaDebugImageForm.ImageBox.Background;
    Bitmap.BeginUpdate();
    Bitmap.SetSize(Width, Height);

    DestBytesPerLine := Bitmap.RawImage.Description.BytesPerLine;
    Dest             := Bitmap.RawImage.Data;

    SourceBytesPerLine := Width * SizeOf(TRGB32);
    Source             := GetMem(SourceBytesPerLine);
    SourceUpper        := PtrUInt(Source + SourceBytesPerLine);

    case GetBitmapPixelFormat(Bitmap) of
      'BGR':  BGR();
      'BGRA': BGRA();
      'ARGB': ARGB();
    end;

    FreeMem(Source);

    Bitmap.EndUpdate();
  end;

begin
  Sync(@Execute);
end;

procedure TSimbaScriptInstanceCommunication.DebugImage_Hide;

  procedure Execute;
  begin
    SimbaDebugImageForm.Close();
  end;

begin
  Sync(@Execute);
end;

procedure TSimbaScriptInstanceCommunication.DebugImage_Display;
var
  Width, Height: Integer;

  procedure Execute;
  begin
    SimbaDebugImageForm.SetSize(Width, Height, True);
  end;

begin
  FParams.Read(Width, SizeOf(Integer));
  FParams.Read(Height, SizeOf(Integer));

  Sync(@Execute);
end;

procedure TSimbaScriptInstanceCommunication.DebugImage_DisplayXY;
var
  X, Y, Width, Height: Integer;

  procedure Execute;
  begin
    SimbaDebugImageForm.Left := X;
    SimbaDebugImageForm.Top  := Y;
    SimbaDebugImageForm.SetSize(Width, Height, True);
  end;

begin
  FParams.Read(X, SizeOf(Integer));
  FParams.Read(Y, SizeOf(Integer));
  FParams.Read(Width, SizeOf(Integer));
  FParams.Read(Height, SizeOf(Integer));

  Sync(@Execute);
end;

// threadsafe
procedure TSimbaScriptInstanceCommunication.DebugMethodName;
begin
  TSimbaScriptInstance(FScriptInstance).DebuggerForm.AddMethod(FParams.ReadAnsiString());
end;

// threadsafe
procedure TSimbaScriptInstanceCommunication.DebugEvents;
var
  Count: Integer;
begin
  FParams.Read(Count, SizeOf(Integer));

  TSimbaScriptInstance(FScriptInstance).DebuggerForm.AddEvents(FParams.Memory + FParams.Position, Count);
end;

constructor TSimbaScriptInstanceCommunication.Create(ScriptInstance: TObject);
begin
  inherited Create();

  FScriptInstance := ScriptInstance;

  FMethods[ESimbaCommunicationMessage.STATUS]                := @Status;
  FMethods[ESimbaCommunicationMessage.DISGUSE]               := @Disguise;
  FMethods[ESimbaCommunicationMessage.SIMBA_PID]             := @GetSimbaPID;
  FMethods[ESimbaCommunicationMessage.SIMBA_TARGET_PID]      := @GetSimbaTargetPID;
  FMethods[ESimbaCommunicationMessage.SIMBA_TARGET_WINDOW]   := @GetSimbaTargetWindow;
  FMethods[ESimbaCommunicationMessage.SCRIPT_ERROR]          := @ScriptError;
  FMethods[ESimbaCommunicationMessage.SCRIPT_STATE_CHANGE]   := @ScriptStateChanged;
  FMethods[ESimbaCommunicationMessage.TRAY_NOTIFICATION]     := @ShowTrayNotification;
  FMethods[ESimbaCommunicationMessage.DEBUGIMAGE_MAXSIZE]    := @DebugImage_SetMaxSize;
  FMethods[ESimbaCommunicationMessage.DEBUGIMAGE_SHOW]       := @DebugImage_Show;
  FMethods[ESimbaCommunicationMessage.DEBUGIMAGE_UPDATE]     := @DebugImage_Update;
  FMethods[ESimbaCommunicationMessage.DEBUGIMAGE_HIDE]       := @DebugImage_Hide;
  FMethods[ESimbaCommunicationMessage.DEBUGIMAGE_MOVETO]     := @DebugImage_MoveTo;
  FMethods[ESimbaCommunicationMessage.DEBUGIMAGE_DISPLAY]    := @DebugImage_Display;
  FMethods[ESimbaCommunicationMessage.DEBUGIMAGE_DISPLAY_XY] := @DebugImage_DisplayXY;
  FMethods[ESimbaCommunicationMessage.DEBUG_METHOD_NAME]     := @DebugMethodName;
  FMethods[ESimbaCommunicationMessage.DEBUG_EVENTS]          := @DebugEvents;
end;

end.

