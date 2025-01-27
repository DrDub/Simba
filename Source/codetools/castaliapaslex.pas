{
  The contents of this file are subject to the Mozilla Public License Version
  1.1 (the "License"); you may not use this file except in compliance with the
  License. You may obtain a copy of the License at
  http://www.mozilla.org/NPL/NPL-1_1Final.html

  Software distributed under the License is distributed on an "AS IS" basis,
  WITHOUT WARRANTY OF ANY KIND, either express or implied. See the License for
  the specific language governing rights and limitations under the License.
}
unit castaliapaslex;

{$MODE DELPHI}

{$DEFINE D8_NEWER}
{$DEFINE D9_NEWER}
{$DEFINE D10_NEWER}

interface

uses
  SysUtils, Classes,
  castaliapaslextypes;

var
  Identifiers: array[#0..#255] of ByteBool;
  mHashTable: array[#0..#255] of Integer;

type
  TmwBasePasLex = class;
  TDirectiveEvent = procedure(Sender: TmwBasePasLex) of object;

  PDefineRec = ^TDefineRec;
  TDefineRec = record
    Defined: Boolean;
    StartCount: Integer;
    Next: PDefineRec;
  end;
  TDefineRecArray = array of TDefineRec;

  PSaveDefinesRec = ^TSaveDefinesRec;
  TSaveDefinesRec = record
    RecArray: TDefineRecArray;
    Stack: Integer;
    Defines: string;
  end;

  TmwBasePasLex = class(TObject)
  private
    fCommentState: TCommentState;
    fOrigin: PAnsiChar;
    fProcTable: array[#0..#255] of procedure of object;
    fScript: String;
    Run: Integer;
    TempRun: Integer;
    fIdentFuncTable: array[0..191] of function: TptTokenKind of object;
    fTokenPos: Integer;
    fLineNumber: Integer;
    FTokenID: TptTokenKind;
    fLinePos: Integer;
    fExID: TptTokenKind;
    FOnMessage: TMessageEvent;
    fOnCompDirect: TDirectiveEvent;
    fOnElseDirect: TDirectiveEvent;
    fOnEndIfDirect: TDirectiveEvent;
    fOnIfDefDirect: TDirectiveEvent;
    fOnIfNDefDirect: TDirectiveEvent;
    fOnResourceDirect: TDirectiveEvent;
    fOnIncludeDirect: TDirectiveEvent;
    fOnLibraryDirect: TDirectiveEvent;
    fOnDefineDirect: TDirectiveEvent;
    fOnIfOptDirect: TDirectiveEvent;
    fOnIfDirect: TDirectiveEvent;
    fOnIfEndDirect: TDirectiveEvent;
    fOnElseIfDirect: TDirectiveEvent;
	  fOnUnDefDirect: TDirectiveEvent;
    FDirectiveParamOrigin: PAnsiChar;

  	fAsmCode : Boolean;		// DR 2002-01-14

    FDefines: TStringList;
    FDefineStack: Integer;
    FTopDefineRec: PDefineRec;
    FUseDefines: Boolean;
    FUseCodeToolsIDEDirective: Boolean;

    function KeyHash: Integer;
    function KeyComp(const aKey: string): Boolean;
    function Func9: tptTokenKind;
    function Func15: TptTokenKind;
    function Func19: TptTokenKind;
    function Func20: TptTokenKind;
	  function Func21: TptTokenKind;
    function Func23: TptTokenKind;
    function Func27: TptTokenKind;
    function Func28: TptTokenKind;
    function Func29: TptTokenKind;
    function Func30: TptTokenKind;
    function Func32: TptTokenKind;
    function Func33: TptTokenKind;
    function Func35: TptTokenKind;
    function Func37: TptTokenKind;
    function Func39: TptTokenKind;
    function Func40: TptTokenKind;
    function Func41: TptTokenKind;
    {$IFDEF D8_NEWER} //JThurman 2004-03-2003
    function Func42: TptTokenKind;
    {$ENDIF}
    function Func44: TptTokenKind;
    function Func45: TptTokenKind;
    function Func46: TptTokenKind;
    function Func47: TptTokenKind;
    function Func49: TptTokenKind;
    function Func52: TptTokenKind;
    function Func53: TptTokenKind;
    function Func54: TptTokenKind;
	  function Func55: TptTokenKind;
    function Func56: TptTokenKind;
    function Func57: TptTokenKind;
    function Func58: TptTokenKind;
    function Func59: TptTokenKind;
    function Func60: TptTokenKind;
    function Func63: TptTokenKind;
    function Func64: TptTokenKind;
  	function Func65: TptTokenKind;
    function Func66: TptTokenKind;
    function Func69: TptTokenKind;
    function Func71: TptTokenKind;
    {$IFDEF D8_NEWER} //JThurman 2004-03-2003
    function Func72: TptTokenKind;
    {$ENDIF}
    function Func73: TptTokenKind;
    function Func75: TptTokenKind;
    function Func76: TptTokenKind;
    function Func78: TptTokenKind;
    function Func79: TptTokenKind;
    function Func81: TptTokenKind;
    function Func84: TptTokenKind;
  	function Func85: TptTokenKind;
    function Func87: TptTokenKind;
    function Func88: TptTokenKind;
    {$IFDEF D8_NEWER}
    function Func89: TptTokenKind; //JThurman 2004-03-03
    {$ENDIF}
    function Func91: TptTokenKind;
    function Func92: TptTokenKind;
    function Func94: TptTokenKind;
    function Func95: TptTokenKind;
    function Func96: TptTokenKind;
    function Func97: TptTokenKind;
    function Func98: TptTokenKind;
    function Func99: TptTokenKind;
    function Func100: TptTokenKind;
    function Func101: TptTokenKind;
    function Func102: TptTokenKind;
    function Func103: TptTokenKind;
    function Func105: TptTokenKind;
    function Func106: TptTokenKind;
    function Func108: TptTokenKind;
    function Func112: TptTokenKind;
    function Func117: TptTokenKind;
    function Func126: TptTokenKind;
    function Func127: TptTokenKind;
    function Func132: TptTokenKind;
    function Func133: TptTokenKind;
    function Func136: TptTokenKind;
    function Func143: TptTokenKind;
    function Func166: TptTokenKind;
    function Func168: TptTokenKind;
    function Func191: TptTokenKind;
    function AltFunc: TptTokenKind;
    procedure InitIdent;
    function GetPosXY: TTokenPoint; // !! changed to TokenPoint //jdj 7/18/1999
    function IdentKind: TptTokenKind;
    procedure SetRunPos(Value: Integer);
    procedure MakeMethodTables;
    procedure AddressOpProc;
    {$IFDEF D8_NEWER} //JThurman 2004-04-06
    procedure AmpersandOpProc;
    {$ENDIF}
    procedure AsciiCharProc;
    procedure AnsiProc;
    procedure BorProc;
    procedure BraceCloseProc;
    procedure BraceOpenProc;
    procedure ColonProc;
    procedure CommaProc;
    procedure CRProc;
    procedure EqualProc;
    procedure GreaterProc;
    procedure IdentProc;
    procedure IntegerProc;
    procedure LFProc;
    procedure LowerProc;
    procedure MinusProc;
    procedure NullProc;
    procedure NumberProc;
    procedure PlusProc;
    procedure PointerSymbolProc;
    procedure PointProc;
    procedure RoundCloseProc;
    procedure RoundOpenProc;
    procedure SemiColonProc;
    procedure SetScript(Value: String);
    procedure SlashProc;
    procedure SpaceProc;
    procedure SquareCloseProc;
    procedure SquareOpenProc;
    procedure StarProc;
    procedure StringProc;
    procedure StringDQProc;
    procedure SymbolProc;
    procedure UnknownProc;
    function GetToken: string;
    function GetTokenLen: Integer;
    function GetCompilerDirective: string;
    function GetDirectiveKind: TptTokenKind;
    function GetIDEDirectiveKind: TptTokenKind;
    function GetDirectiveParam: string;
    function GetDirectiveParamOriginal : string;
    function GetIsJunk: Boolean;
    function GetIsSpace: Boolean;
    function GetIsCompilerDirective: Boolean;
    function GetGenID: TptTokenKind;

    procedure SetOnElseIfDirect(const Value: TDirectiveEvent);

    function IsDefined(const ADefine: string): Boolean;
    procedure EnterDefineBlock(ADefined: Boolean);
    procedure ExitDefineBlock;

    procedure DoProcTable(AChar: AnsiChar);
    function IsIdentifiers(AChar: AnsiChar): Boolean;
    function HashValue(AChar: AnsiChar): Integer;
  protected
    procedure SetOrigin(NewValue: PAnsiChar); virtual;
    procedure SetOnCompDirect(const Value: TDirectiveEvent); virtual;
    procedure SetOnDefineDirect(const Value: TDirectiveEvent); virtual;
    procedure SetOnElseDirect(const Value: TDirectiveEvent); virtual;
    procedure SetOnEndIfDirect(const Value: TDirectiveEvent); virtual;
    procedure SetOnIfDefDirect(const Value: TDirectiveEvent); virtual;
    procedure SetOnIfNDefDirect(const Value: TDirectiveEvent); virtual;
    procedure SetOnIfOptDirect(const Value: TDirectiveEvent); virtual;
    procedure SetOnIncludeDirect(const Value: TDirectiveEvent); virtual;
    procedure SetOnLibraryDirect(const Value: TDirectiveEvent); virtual;
    procedure SetOnResourceDirect(const Value: TDirectiveEvent); virtual;
    procedure SetOnUnDefDirect(const Value: TDirectiveEvent); virtual;
    procedure SetOnIfDirect(const Value: TDirectiveEvent); virtual;
    procedure SetOnIfEndDirect(const Value: TDirectiveEvent); virtual;
  public
    CaretPos: Integer;
    MaxPos: Integer;

    constructor Create;
    destructor Destroy; override;
    procedure Next; inline;
    procedure NextID(ID: TptTokenKind); inline;
    procedure NextNoJunk; inline;
    procedure NextNoSpace; inline;
    procedure Init;
    procedure InitFrom(ALexer: TmwBasePasLex);

    procedure AddDefine(const ADefine: string);
    procedure RemoveDefine(const ADefine: string);
    procedure ClearDefines;
    procedure InitDefines;
    procedure CloneDefinesFrom(ALexer: TmwBasePasLex);
    function SaveDefines: TSaveDefinesRec;
    procedure LoadDefines(From: TSaveDefinesRec);

    property CompilerDirective: string read GetCompilerDirective;
    property DirectiveParam: string read GetDirectiveParam;
    property DirectiveParamOriginal : string read GetDirectiveParamOriginal;
	  property IsJunk: Boolean read GetIsJunk;
    property IsSpace: Boolean read GetIsSpace;
    property LineNumber: Integer read fLineNumber write fLineNumber;
    property LinePos: Integer read fLinePos write fLinePos;
    property Origin: PAnsiChar read fOrigin write SetOrigin;
    property Script: String read FScript write SetScript;
    property PosXY: TTokenPoint read GetPosXY;
    property RunPos: Integer read Run write SetRunPos;
    property Token: string read GetToken;
    property TokenLen: Integer read GetTokenLen;
    property TokenPos: Integer read fTokenPos;
    property TokenID: TptTokenKind read FTokenID;
    property ExID: TptTokenKind read fExID;
    property GenID: TptTokenKind read GetGenID;
    property IsCompilerDirective: Boolean read GetIsCompilerDirective;
    property OnMessage: TMessageEvent read FOnMessage write FOnMessage;
    property OnCompDirect: TDirectiveEvent read fOnCompDirect write SetOnCompDirect;
    property OnDefineDirect: TDirectiveEvent read fOnDefineDirect write SetOnDefineDirect;
    property OnElseDirect: TDirectiveEvent read fOnElseDirect write SetOnElseDirect;
    property OnEndIfDirect: TDirectiveEvent read fOnEndIfDirect write SetOnEndIfDirect;
    property OnIfDefDirect: TDirectiveEvent read fOnIfDefDirect write SetOnIfDefDirect;
    property OnIfNDefDirect: TDirectiveEvent read fOnIfNDefDirect write SetOnIfNDefDirect;
    property OnIfOptDirect: TDirectiveEvent read fOnIfOptDirect write SetOnIfOptDirect;
    property OnIncludeDirect: TDirectiveEvent read fOnIncludeDirect write SetOnIncludeDirect;
    property OnLibraryDirect: TDirectiveEvent read fOnLibraryDirect write SetOnLibraryDirect;
    property OnIfDirect: TDirectiveEvent read fOnIfDirect write SetOnIfDirect;
    property OnIfEndDirect: TDirectiveEvent read fOnIfEndDirect write SetOnIfEndDirect;
    property OnElseIfDirect: TDirectiveEvent read fOnElseIfDirect write  SetOnElseIfDirect;
	  property OnResourceDirect: TDirectiveEvent read fOnResourceDirect write SetOnResourceDirect;
	  property OnUnDefDirect: TDirectiveEvent read fOnUnDefDirect write SetOnUnDefDirect;

	  property AsmCode : Boolean read fAsmCode write fAsmCode;
    property DirectiveParamOrigin: PAnsiChar read FDirectiveParamOrigin;

    property UseCodeToolsIDEDirective: Boolean read FUseCodeToolsIDEDirective write FUseCodeToolsIDEDirective;
    property UseDefines: Boolean read FUseDefines write FUseDefines;

    property Defines: TStringList read FDefines;
  end;

  TmwPasLex = class(TmwBasePasLex)
  private
    fAheadLex: TmwBasePasLex;
    fFileName: String;
    fIsLibrary: Boolean;
    function GetAheadExID: TptTokenKind;
    function GetAheadGenID: TptTokenKind;
    function GetAheadToken: string;
    function GetAheadTokenID: TptTokenKind;
    function GetStatus: TmwPasLexStatus;
    procedure SetStatus(const Value: TmwPasLexStatus);
  protected
    procedure SetOrigin(NewValue: PAnsiChar); override;
    procedure SetOnCompDirect(const Value: TDirectiveEvent); override;
    procedure SetOnDefineDirect(const Value: TDirectiveEvent); override;
    procedure SetOnElseDirect(const Value: TDirectiveEvent); override;
    procedure SetOnEndIfDirect(const Value: TDirectiveEvent); override;
    procedure SetOnIfDefDirect(const Value: TDirectiveEvent); override;
    procedure SetOnIfNDefDirect(const Value: TDirectiveEvent); override;
    procedure SetOnIfOptDirect(const Value: TDirectiveEvent); override;
    procedure SetOnIncludeDirect(const Value: TDirectiveEvent); override;
    procedure SetOnResourceDirect(const Value: TDirectiveEvent); override;
    procedure SetOnUnDefDirect(const Value: TDirectiveEvent); override;
  public
    constructor Create; overload;
    destructor Destroy; override;
    procedure InitAhead;
    procedure AheadNext;
    property AheadLex: TmwBasePasLex read fAheadLex;
    property AheadToken: string read GetAheadToken;
    property AheadTokenID: TptTokenKind read GetAheadTokenID;
    property AheadExID: TptTokenKind read GetAheadExID;
    property AheadGenID: TptTokenKind read GetAheadGenID;
    property Status: TmwPasLexStatus read GetStatus write SetStatus;
    property FileName: String read fFileName write fFileName;
    property IsLibrary: Boolean read fIsLibrary write fIsLibrary;
  end;

implementation

procedure MakeIdentTable;
var
  I, J: AnsiChar;
begin
  for I := #0 to #255 do
  begin
    case I of
      '_', '0'..'9', 'a'..'z', 'A'..'Z': Identifiers[I] := True;
    else Identifiers[I] := False;
    end;
    J := AnsiString(UpCase(I))[1];
    case I of
      'a'..'z', 'A'..'Z', '_': mHashTable[I] := Ord(J) - 64;
      '0'..'9': mHashTable[I] := Ord(J) - 47;
    else mHashTable[Char(I)] := 0;
    end;
  end;
end;

procedure TmwBasePasLex.ClearDefines;
var
  Frame: PDefineRec;
begin
  while FTopDefineRec <> nil do
  begin
    Frame := FTopDefineRec;
    FTopDefineRec := Frame^.Next;
    Dispose(Frame);
  end;
  FDefines.Clear;
  FDefineStack := 0;
  FTopDefineRec := nil;
end;

procedure TmwBasePasLex.CloneDefinesFrom(ALexer: TmwBasePasLex);
var
  Frame, LastFrame, SourceFrame: PDefineRec;
begin
  ClearDefines;
  FDefines.Assign(ALexer.FDefines);
  FDefineStack := ALexer.FDefineStack;

  Frame := nil;
  LastFrame := nil;
  SourceFrame := ALexer.FTopDefineRec;
  while SourceFrame <> nil do
  begin
    New(Frame);
    if FTopDefineRec = nil then
      FTopDefineRec := Frame
    else
      LastFrame^.Next := Frame;
    Frame^.Defined := SourceFrame^.Defined;
    Frame^.StartCount := SourceFrame^.StartCount;
    LastFrame := Frame;

    SourceFrame := SourceFrame^.Next;
  end;
  if Frame <> nil then
    Frame^.Next := nil;
end;

function TmwBasePasLex.SaveDefines: TSaveDefinesRec;
var
  Frame: PDefineRec;
begin
  Result.Defines := FDefines.CommaText;
  Result.Stack := FDefineStack;

  Frame := FTopDefineRec;
  while (Frame <> nil) do
  begin
    SetLength(Result.RecArray, Length(Result.RecArray) + 1);
    Result.RecArray[High(Result.RecArray)] := Frame^;
    Result.RecArray[High(Result.RecArray)].Next := nil;
    Frame := Frame^.Next;
  end;
end;

procedure TmwBasePasLex.LoadDefines(From: TSaveDefinesRec);
var
  Frame, LastFrame: PDefineRec;
  i: Integer;
begin
  ClearDefines;
  FDefines.CommaText := From.Defines;
  FDefineStack := From.Stack;

  Frame := nil;
  LastFrame := nil;
  for i := 0 to High(From.RecArray) do
  begin
    New(Frame);
    if (i = 0) then
      FTopDefineRec := Frame
    else
      LastFrame^.Next := Frame;

    Frame^ := From.RecArray[i];
    LastFrame := Frame;
  end;

  if (Frame <> nil) then
    Frame^.Next := nil;
end;

function TmwBasePasLex.GetPosXY: TTokenPoint;
begin //jdj 7/18/1999
  // !! changed setting code
  Result.X:= FTokenPos - FLinePos;
  Result.Y:= FLineNumber;
end;

procedure TmwBasePasLex.InitIdent;
var
  I: Integer;
begin
  for I := 0 to 191 do
    case I of
      {$IFDEF D8_NEWER}
      9: fIdentFuncTable[I] := Func9;
      {$ENDIF}
      15: fIdentFuncTable[I] := Func15;
	    19: fIdentFuncTable[I] := Func19;
      20: fIdentFuncTable[I] := Func20;
      21: fIdentFuncTable[I] := Func21;
	    23: fIdentFuncTable[I] := Func23;
      27: fIdentFuncTable[I] := Func27;
      28: fIdentFuncTable[I] := Func28;
      29: fIdentFuncTable[I] := Func29;
      30: fIdentFuncTable[I] := Func30;
      32: fIdentFuncTable[I] := Func32;
      33: fIdentFuncTable[I] := Func33;
      35: fIdentFuncTable[I] := Func35;
      37: fIdentFuncTable[I] := Func37;
	  39: fIdentFuncTable[I] := Func39;
      40: fIdentFuncTable[I] := Func40;
	  41: fIdentFuncTable[I] := Func41;
    {$IFDEF D8_NEWER} //JThurman 2004-03-2003
    42: fIdentFuncTable[I] := Func42;
    {$ENDIF}
      44: fIdentFuncTable[I] := Func44;
      45: fIdentFuncTable[I] := Func45;
      46: fIdentFuncTable[I] := Func46;
      47: fIdentFuncTable[I] := Func47;
      49: fIdentFuncTable[I] := Func49;
      52: fIdentFuncTable[I] := Func52;
      53: fIdentFuncTable[I] := Func53;
      54: fIdentFuncTable[I] := Func54;
      55: fIdentFuncTable[I] := Func55;
      56: fIdentFuncTable[I] := Func56;
      57: fIdentFuncTable[I] := Func57;
      58: fIdentFuncTable[I] := Func58;
	    59: fIdentFuncTable[I] := Func59;
      60: fIdentFuncTable[I] := Func60;
      63: fIdentFuncTable[I] := Func63;
	    64: fIdentFuncTable[I] := Func64;
      65: fIdentFuncTable[I] := Func65;
      66: fIdentFuncTable[I] := Func66;
      69: fIdentFuncTable[I] := Func69;
      71: fIdentFuncTable[I] := Func71;
      {$IFDEF D8_NEWER} //JThurman 2004-03-2003
      72: fIdentFuncTable[I] := Func72;
      {$ENDIF}
      73: fIdentFuncTable[I] := Func73;
      75: fIdentFuncTable[I] := Func75;
      76: fIdentFuncTable[I] := Func76;
      78: fIdentFuncTable[I] := Func78;
      79: fIdentFuncTable[I] := Func79;
      81: fIdentFuncTable[I] := Func81;
      84: fIdentFuncTable[I] := Func84;
	    85: fIdentFuncTable[I] := Func85;
      87: fIdentFuncTable[I] := Func87;
      88: fIdentFuncTable[I] := Func88;
      {$IFDEF D8_NEWER} //JThurman 2004-03-03
      89: fIdentFuncTable[I] := Func89;
      {$ENDIF}
      91: fIdentFuncTable[I] := Func91;
      92: fIdentFuncTable[I] := Func92;
      94: fIdentFuncTable[I] := Func94;
      95: fIdentFuncTable[I] := Func95;
      96: fIdentFuncTable[I] := Func96;
      97: fIdentFuncTable[I] := Func97;
      98: fIdentFuncTable[I] := Func98;
      99: fIdentFuncTable[I] := Func99;
      100: fIdentFuncTable[I] := Func100;
	    101: fIdentFuncTable[I] := Func101;
      102: fIdentFuncTable[I] := Func102;
      103: fIdentFuncTable[I] := Func103;
      105: fIdentFuncTable[I] := Func105;
	    106: fIdentFuncTable[I] := Func106;
      108: fIdentFuncTable[I] := Func108;
      112: fIdentFuncTable[I] := Func112;
      117: fIdentFuncTable[I] := Func117;
      126: fIdentFuncTable[I] := Func126;
      127: fIdentFuncTable[I] := Func127;
      132: fIdentFuncTable[I] := Func132;
      133: fIdentFuncTable[I] := Func133;
	    136: fIdentFuncTable[I] := Func136;
      143: fIdentFuncTable[I] := Func143;
      166: fIdentFuncTable[I] := Func166;
      168: fIdentFuncTable[I] := Func168;
      191: fIdentFuncTable[I] := Func191;
    else fIdentFuncTable[I] := AltFunc;
    end;
end;

function TmwBasePasLex.KeyHash: Integer;
//var
//  DebugKeyHash: String = '';
begin
  Result := 0;
  while IsIdentifiers(fOrigin[Run]) do
  begin
    // DebugKeyHash += fOrigin[Run];
    Inc(Result, HashValue(fOrigin[Run]));
    Inc(Run);
  end;

  // WriteLn('KeyHash for ', DebugKeyHash, ' = ', Result);
end;

function TmwBasePasLex.KeyComp(const aKey: string): Boolean;
var
  I: Integer;
  Temp: PAnsiChar;
begin
  if Length(aKey) = TokenLen then
  begin
    Temp := fOrigin + fTokenPos;
    Result := True;
    for i := 1 to TokenLen do
    begin
      if mHashTable[Temp^] <> mHashTable[aKey[i]] then
      begin
        Result := False;
        break;
      end;
      inc(Temp);
    end;
  end
  else Result := False;
end;

function TmwBasePasLex.Func9: tptTokenKind;
begin
  Result := tokIdentifier;
  if KeyComp('Add') then
    FExID := tokAdd;
end;

function TmwBasePasLex.Func15: TptTokenKind;
begin
  Result := tokIdentifier;
  if KeyComp('If') then Result := tokIf;
end;

function TmwBasePasLex.Func19: TptTokenKind;
begin
  Result := tokIdentifier;
  if KeyComp('Do') then Result := tokDo else
    if KeyComp('And') then Result := tokAnd;
end;

function TmwBasePasLex.Func20: TptTokenKind;
begin
  Result := tokIdentifier;
  if KeyComp('As') then Result := tokAs;
end;

function TmwBasePasLex.Func21: TptTokenKind;
begin
  Result := tokIdentifier;
  if KeyComp('Of') then Result := tokOf else
    if KeyComp('At') then fExID := tokAt;
end;

function TmwBasePasLex.Func23: TptTokenKind;
begin
  Result := tokIdentifier;
  if KeyComp('End') then Result := tokEnd else
    if KeyComp('In') then Result := tokIn;
end;

function TmwBasePasLex.Func27: TptTokenKind;
begin
  Result := tokIdentifier;
  if KeyComp('Cdecl') then fExID := tokCdecl;
end;

function TmwBasePasLex.Func28: TptTokenKind;
begin
  Result := tokIdentifier;
  if KeyComp('Read') then fExID := tokRead else
    if KeyComp('Case') then Result := tokCase else
      if KeyComp('Is') then Result := tokIs;
end;

function TmwBasePasLex.Func29: TptTokenKind;
begin
  Result := tokIdentifier;
  if KeyComp('On') then fExID := tokOn;
end;

function TmwBasePasLex.Func30: TptTokenKind;
begin
  Result := tokIdentifier;
end;

function TmwBasePasLex.Func32: TptTokenKind;
begin
  Result := tokIdentifier;
  if KeyComp('Label') then Result := tokLabel else
    if KeyComp('Mod') then Result := tokMod;
end;

function TmwBasePasLex.Func33: TptTokenKind;
begin
  Result := tokIdentifier;
  if KeyComp('Or') then Result := tokOr else
    if KeyComp('Name') then fExID := tokName else
      if KeyComp('Asm') then Result := tokAsm;
end;

function TmwBasePasLex.Func35: TptTokenKind;
begin
  Result := tokIdentifier;
  if KeyComp('To') then Result := tokTo else
    if KeyComp('Div') then Result := tokDiv;
end;

function TmwBasePasLex.Func37: TptTokenKind;
begin
  Result := tokIdentifier;
  if KeyComp('Begin') then Result := tokBegin else
    if KeyComp('Break') then fExID := tokBreak;
end;

function TmwBasePasLex.Func39: TptTokenKind;
begin
  Result := tokIdentifier;
  if KeyComp('For') then Result := tokFor else
    if KeyComp('Shl') then Result := tokShl;
end;

function TmwBasePasLex.Func40: TptTokenKind;
begin
  Result := tokIdentifier;
  if KeyComp('Packed') then Result := tokPacked;
end;

function TmwBasePasLex.Func41: TptTokenKind;
begin
  Result := tokIdentifier;
  if KeyComp('Var') then Result := tokVar else
    if KeyComp('Else') then Result := tokElse else
      if KeyComp('Halt') then fExID := tokHalt;
end;

function TmwBasePasLex.Func42: TptTokenKind;
begin
  Result := tokIdentifier;
  if KeyComp('Final') then
    fExID := tokFinal;
end;

function TmwBasePasLex.Func44: TptTokenKind;
begin
  Result := tokIdentifier;
  if KeyComp('Set') then Result := tokSet else
    if KeyComp('Package') then fExID := tokPackage;
end;

function TmwBasePasLex.Func45: TptTokenKind;
begin
  Result := tokIdentifier;
  if KeyComp('Shr') then Result := tokShr;
end;

function TmwBasePasLex.Func46: TptTokenKind;
begin
  Result := tokIdentifier;
  if KeyComp('Sealed') then Result := tokSealed;
end;

function TmwBasePasLex.Func47: TptTokenKind;
begin
  Result := tokIdentifier;
  if KeyComp('Then') then Result := tokThen;
end;

function TmwBasePasLex.Func49: TptTokenKind;
begin
  Result := tokIdentifier;
  if KeyComp('Not') then Result := tokNot;
end;

function TmwBasePasLex.Func52: TptTokenKind;
begin
  Result := tokIdentifier;
  if KeyComp('Raise') then Result := tokRaise;
end;

function TmwBasePasLex.Func53: TptTokenKind;
begin
  Result := tokIdentifier;
  if KeyComp('Enum') then Result := tokEnum;
end;

function TmwBasePasLex.Func54: TptTokenKind;
begin
  Result := tokIdentifier;
  if KeyComp('Class') then Result := tokClass;
end;

function TmwBasePasLex.Func55: TptTokenKind;
begin
  Result := tokIdentifier;
  if KeyComp('Object') then Result := tokObject;
end;

function TmwBasePasLex.Func56: TptTokenKind;
begin
  Result := tokIdentifier;
  if KeyComp('Index') then fExID := tokIndex else
    if KeyComp('Out') then fExID := tokOut;
end;

function TmwBasePasLex.Func57: TptTokenKind;
begin
  Result := tokIdentifier;
  if KeyComp('While') then Result := tokWhile else
    if KeyComp('Xor') then Result := tokXor else
      if KeyComp('Goto') then Result := tokGoto;
end;

function TmwBasePasLex.Func58: TptTokenKind;
begin
  Result := tokIdentifier;
  if KeyComp('Exit') then fExID := tokExit;
end;

function TmwBasePasLex.Func59: TptTokenKind;
begin
  Result := tokIdentifier;
  if KeyComp('Safecall') then fExID := tokSafecall;
end;

function TmwBasePasLex.Func60: TptTokenKind;
begin
  Result := tokIdentifier;
  if KeyComp('With') then Result := tokWith;
end;

function TmwBasePasLex.Func63: TptTokenKind;
begin
  Result := tokIdentifier;
  case fOrigin[fTokenPos] of
    'P', 'p': if KeyComp('Public') then fExID := tokPublic;
    'A', 'a': if KeyComp('Array') then Result := tokArray;
    'T', 't': if KeyComp('Try') then Result := tokTry;
    'R', 'r': if KeyComp('Record') then Result := tokRecord;
    'I', 'i': if KeyComp('Inline') then
     begin
       Result := tokInline;
       fExID := tokInline;
     end;
  end;
end;

function TmwBasePasLex.Func64: TptTokenKind;
begin
  Result := tokIdentifier;
  case fOrigin[fTokenPos] of
    'H', 'h': if KeyComp('Helper') then fExID := tokHelper;
    'U', 'u': if KeyComp('Uses') then Result := tokUses
    else
    if KeyComp('Unit') then Result := tokUnit;
  end;
end;

function TmwBasePasLex.Func65: TptTokenKind;
begin
  Result := tokIdentifier;
  if KeyComp('Repeat') then Result := tokRepeat;
end;

function TmwBasePasLex.Func66: TptTokenKind;
begin
  Result := tokIdentifier;
  if KeyComp('Type') then Result := tokType else
    if KeyComp('Unsafe') then Result := tokUnsafe;
end;

function TmwBasePasLex.Func69: TptTokenKind;
begin
  Result := tokIdentifier;
  if KeyComp('Default') then fExID := tokDefault else
    if KeyComp('Message') then fExID := tokMessage;
end;

function TmwBasePasLex.Func71: TptTokenKind;
begin
  Result := tokIdentifier;
  if KeyComp('Stdcall') then fExID := tokStdcall else
    if KeyComp('Const') then Result := tokConst else
      if KeyComp('Native') then fExID := tokNative;
end;

function TmwBasePasLex.Func72: TptTokenKind;
begin
  Result := tokIdentifier;
  if KeyComp('Static') then
    fExID := tokStatic;
end;

function TmwBasePasLex.Func73: TptTokenKind;
begin
  Result := tokIdentifier;
  if KeyComp('Except') then Result := tokExcept;
  if KeyComp('Union') then Result := tokUnion;
end;

function TmwBasePasLex.Func75: TptTokenKind;
begin
  Result := tokIdentifier;
  if KeyComp('Write') then fExID := tokWrite;
end;

function TmwBasePasLex.Func76: TptTokenKind;
begin
  Result := tokIdentifier;
  if KeyComp('Until') then Result := tokUntil;
end;

function TmwBasePasLex.Func78: TptTokenKind;
begin
  Result := tokIdentifier;
end;

function TmwBasePasLex.Func79: TptTokenKind;
begin
  Result := tokIdentifier;
  if KeyComp('Finally') then Result := tokFinally;
end;

function TmwBasePasLex.Func81: TptTokenKind;
begin
  Result := tokIdentifier;
  if KeyComp('Stored') then fExID := tokStored else
	  if KeyComp('Interface') then Result := tokInterface else
      if KeyComp('Deprecated') then fExID := tokDeprecated;
end;

function TmwBasePasLex.Func84: TptTokenKind;
begin
  Result := tokIdentifier;
  if KeyComp('Abstract') then fExID := tokAbstract;
end;

function TmwBasePasLex.Func85: TptTokenKind;
begin
  Result := tokIdentifier;
  if KeyComp('Library') then Result := tokLibrary else
	  if KeyComp('Forward') then fExID := tokForward else
end;

function TmwBasePasLex.Func87: TptTokenKind;
begin
  Result := tokIdentifier;
end;

function TmwBasePasLex.Func88: TptTokenKind;
begin
  Result := tokIdentifier;
  if KeyComp('Program') then Result := tokProgram;
end;

function TmwBasePasLex.Func89: TptTokenKind;
begin
  Result := tokIdentifier;
  if KeyComp('Strict') then Result := tokStrict;
end;

function TmwBasePasLex.Func91: TptTokenKind;
begin
  Result := tokIdentifier;
  if KeyComp('Downto') then Result := tokDownto else
    if KeyComp('Private') then fExID := tokPrivate else
end;

function TmwBasePasLex.Func92: TptTokenKind;
begin
  Result := tokIdentifier;
  if KeyComp('Overload') then fExID := tokOverload;
end;

function TmwBasePasLex.Func94: TptTokenKind;
begin
  Result := tokIdentifier;
  if KeyComp('Assembler') then fExID := tokAssembler;
end;

function TmwBasePasLex.Func95: TptTokenKind;
begin
  Result := tokIdentifier;
  if KeyComp('Absolute') then fExID := tokAbsolute;
end;

function TmwBasePasLex.Func96: TptTokenKind;
begin
  Result := tokIdentifier;
  if KeyComp('Override') then fExID := tokOverride else
    if KeyComp('Published') then fExID := tokPublished;
end;

function TmwBasePasLex.Func97: TptTokenKind;
begin
  Result := tokIdentifier;
  if KeyComp('Threadvar') then Result := tokThreadvar;
end;

function TmwBasePasLex.Func98: TptTokenKind;
begin
  Result := tokIdentifier;
  if KeyComp('Export') then fExID := tokExport else
    if KeyComp('Nodefault') then fExID := tokNodefault;
end;

function TmwBasePasLex.Func99: TptTokenKind;
begin
  Result := tokIdentifier;
  if KeyComp('External') then fExID := tokExternal;
end;

function TmwBasePasLex.Func100: TptTokenKind;
begin
  Result := tokIdentifier;
  if KeyComp('Constref') then Result := tokConstRef;
end;

function TmwBasePasLex.Func101: TptTokenKind;
begin
  Result := tokIdentifier;
  if KeyComp('Register') then fExID := tokRegister
  else if KeyComp('Platform') then fExID := tokPlatform
  else if KeyComp('Continue') then fExID := tokContinue;
end;

function TmwBasePasLex.Func102: TptTokenKind;
begin
  Result := tokIdentifier;
  if KeyComp('Function') then Result := tokFunction;
end;

function TmwBasePasLex.Func103: TptTokenKind;
begin
  Result := tokIdentifier;
  if KeyComp('Virtual') then fExID := tokVirtual;
end;

function TmwBasePasLex.Func105: TptTokenKind;
begin
  Result := tokIdentifier;
  if KeyComp('Procedure') then Result := tokProcedure;
end;

function TmwBasePasLex.Func106: TptTokenKind;
begin
  Result := tokIdentifier;
  if KeyComp('Protected') then fExID := tokProtected;
end;

function TmwBasePasLex.Func108: TptTokenKind;
begin
  Result := tokIdentifier;
  if KeyComp('Operator') then Result := tokOperator;
end;

function TmwBasePasLex.Func112: TptTokenKind;
begin
  Result := tokIdentifier;
  if KeyComp('Requires') then fExID := tokRequires;
end;

function TmwBasePasLex.Func117: TptTokenKind;
begin
  Result := tokIdentifier;
  if KeyComp('Exports') then Result := tokExports;
end;

function TmwBasePasLex.Func126: TptTokenKind;
begin
  Result := tokIdentifier;
  if KeyComp('Implements') then fExID := tokImplements;
end;

function TmwBasePasLex.Func127: TptTokenKind;
begin
  Result := tokIdentifier;
  if KeyComp('Runerror') then fExID := tokRunError;
end;

function TmwBasePasLex.Func132: TptTokenKind;
begin
  Result := tokIdentifier;
  if KeyComp('Reintroduce') then fExID := tokReintroduce;
end;

function TmwBasePasLex.Func133: TptTokenKind;
begin
  Result := tokIdentifier;
  if KeyComp('Property') then Result := tokProperty;
end;

function TmwBasePasLex.Func136: TptTokenKind;
begin
  Result := tokIdentifier;
  if KeyComp('Finalization') then Result := tokFinalization;
end;

function TmwBasePasLex.Func143: TptTokenKind;
begin
  Result := tokIdentifier;
  if KeyComp('Destructor') then Result := tokDestructor;
end;

function TmwBasePasLex.Func166: TptTokenKind;
begin
  Result := tokIdentifier;
  if KeyComp('Constructor') then Result := tokConstructor else
    if KeyComp('Implementation') then Result := tokImplementation;
end;

function TmwBasePasLex.Func168: TptTokenKind;
begin
  Result := tokIdentifier;
  if KeyComp('Initialization') then Result := tokInitialization;
end;

function TmwBasePasLex.Func191: TptTokenKind;
begin
  Result := tokIdentifier;
  if KeyComp('Resourcestring') then Result := tokResourcestring else
    if KeyComp('Stringresource') then fExID := tokStringresource;
end;

function TmwBasePasLex.AltFunc: TptTokenKind;
begin
  Result := tokIdentifier;
end;

function TmwBasePasLex.IdentKind: TptTokenKind;
var
  HashKey: Integer;
begin
  HashKey := KeyHash;
  if HashKey < 192 then
	Result := fIdentFuncTable[HashKey]
  else Result := tokIdentifier;
end;

procedure TmwBasePasLex.MakeMethodTables;
var
  I: Char;
begin
  for I := #0 to #255 do
    case I of
      #0: fProcTable[I] := NullProc;
      #10: fProcTable[I] := LFProc;
      #13: fProcTable[I] := CRProc;
      #1..#9, #11, #12, #14..#32:
        fProcTable[I] := SpaceProc;
      '#': fProcTable[I] := AsciiCharProc;
      '$': fProcTable[I] := IntegerProc;
      #34: fProcTable[I] := StringDQProc;
      #39: fProcTable[I] := StringProc;
      '0'..'9': fProcTable[I] := NumberProc;
      'A'..'Z', 'a'..'z', '_':
        fProcTable[I] := IdentProc;
      '{': fProcTable[I] := BraceOpenProc;
      '}': fProcTable[I] := BraceCloseProc;
      '!', '%', '&', '('..'/', ':'..'@', '['..'^', '`', '~':
        begin
          case I of
            '(': fProcTable[I] := RoundOpenProc;
            ')': fProcTable[I] := RoundCloseProc;
            '*': fProcTable[I] := StarProc;
            '+': fProcTable[I] := PlusProc;
            ',': fProcTable[I] := CommaProc;
            '-': fProcTable[I] := MinusProc;
            '.': fProcTable[I] := PointProc;
            '/': fProcTable[I] := SlashProc;
            ':': fProcTable[I] := ColonProc;
            ';': fProcTable[I] := SemiColonProc;
            '<': fProcTable[I] := LowerProc;
            '=': fProcTable[I] := EqualProc;
            '>': fProcTable[I] := GreaterProc;
            '@': fProcTable[I] := AddressOpProc;
            '[': fProcTable[I] := SquareOpenProc;
            ']': fProcTable[I] := SquareCloseProc;
            '^': fProcTable[I] := PointerSymbolProc; 
            {$IFDEF D8_NEWER} //JThurman 2004-04-06
            '&': fProcTable[I] := AmpersandOpProc;
            {$ENDIF}
            else fProcTable[I] := SymbolProc;
          end;
        end;
    else fProcTable[I] := UnknownProc;
    end;
end;

constructor TmwBasePasLex.Create;
begin
  inherited Create;
  fOrigin := nil;
  InitIdent;
  MakeMethodTables;
  fExID := tokUnKnown;

  FUseDefines := True;
  FDefines := TStringList.Create;
  FDefines.Duplicates := dupIgnore;
  FTopDefineRec := nil;
  InitDefines;

  MaxPos := -1;
  CaretPos := -1;
end;

destructor TmwBasePasLex.Destroy;
begin
  ClearDefines;
  FDefines.Free;
  fOrigin := nil;
  inherited Destroy;
end;

procedure TmwBasePasLex.DoProcTable(AChar: AnsiChar); inline;
begin
  if AChar <= #255 then
    fProcTable[AChar]
  else
  begin
    IdentProc;
  end;
end;

procedure TmwBasePasLex.SetOrigin(NewValue: PAnsiChar);
begin
  fOrigin := NewValue;
  Init;
  //Next();
end;

procedure TmwBasePasLex.SetRunPos(Value: Integer);
begin
  Run := Value;
  Next;
end;

procedure TmwBasePasLex.AddDefine(const ADefine: string);
begin
  FDefines.Add(ADefine);
end;

procedure TmwBasePasLex.AddressOpProc;
begin
  case FOrigin[Run + 1] of
    '@':
      begin
        fTokenID := tokDoubleAddressOp;
        inc(Run, 2);
      end;
  else
    begin
      fTokenID := tokAddressOp;
      inc(Run);
    end;
  end;
end;

procedure TmwBasePasLex.AsciiCharProc;
begin
  fTokenID := tokAsciiChar;
  inc(Run);
  if FOrigin[Run] = '$' then
  begin
    inc(Run);
    while FOrigin[Run] in ['0'..'9', 'A'..'F', 'a'..'f'] do inc(Run);
  end else
  begin
    while FOrigin[Run] in ['0'..'9'] do
      inc(Run);
  end;
end;

procedure TmwBasePasLex.BraceCloseProc;
begin
  inc(Run);
  fTokenId := tokError;
  if Assigned(FOnMessage) then
	  FOnMessage(Self, meError, 'Illegal character', PosXY.X, PosXY.Y);
end;

procedure TmwBasePasLex.BorProc;
begin
  fTokenID := tokBorComment;
  case FOrigin[Run] of
    #0:
      begin
		    NullProc;
        if Assigned(FOnMessage) then
          FOnMessage(Self, meError, 'Unexpected file end', PosXY.X, PosXY.Y);
        exit;
      end;
  end;

  while FOrigin[Run] <> #0 do
	  case FOrigin[Run] of
	    '}':
		  begin
		    fCommentState := csNo;
		    inc(Run);
		    break;
		  end;

	    #10:
		  begin
			  inc(Run);
			  inc(fLineNumber);
			  fLinePos := Run;
		  end;
	    #13:
		  begin
			  inc(Run);
			  if FOrigin[Run] = #10 then inc( Run );
			  inc(fLineNumber);
			  fLinePos := Run;
		  end;
	    else
        inc(Run);
	  end;
end;

procedure TmwBasePasLex.BraceOpenProc;
var
  Param, Def: string;
  tmpRun: Integer;
begin
  case FOrigin[Run + 1] of
    '$': fTokenID := GetDirectiveKind;
    '%': FTokenID := GetIDEDirectiveKind;
    '.':
      begin
        tmpRun := fTokenPos;
        Run := fTokenPos + 2;
        FDirectiveParamOrigin := FOrigin + FTokenPos;
        FTokenPos := Run;
        case KeyHash of
          55: if KeyComp('LOADLIB') then
                fTokenID := tokLibraryDirect
              else
                fTokenID := tokBorComment;
          68: if KeyComp('INCLUDE') then
                fTokenID := tokIncludeDirect
              else
                fTokenID := tokBorComment;
          136: if KeyComp('INCLUDE_ONCE') then
                fTokenID := tokIncludeOnceDirect
              else
                fTokenID := tokBorComment;
        else
          fTokenId := tokBorComment;
        end;
        FTokenPos := tmpRun;
        Dec(Run);
      end
  else
    fTokenID := tokBorComment;
  end;
  if (fTokenID = tokBorComment) then
    fCommentState := csBor;
  inc(Run);
  while FOrigin[Run] <> #0 do
    case FOrigin[Run] of
      '}':
        begin
          fCommentState := csNo;
          inc(Run);
          break;
		    end;
	    #10:
		  begin
			  inc(Run);
			  inc(fLineNumber);
			  fLinePos := Run;
		  end;
	    #13:
		  begin
			  inc(Run);
			  if FOrigin[Run] = #10 then inc( Run );
			  inc(fLineNumber);
			  fLinePos := Run;
		  end;
    else inc(Run);
    end;

  case fTokenID of
    tokIDECodeTools:
      begin
        if FUseCodeToolsIDEDirective then
        begin
          if DirectiveParamOriginal = 'off' then
            EnterDefineBlock(False)
          else
          if DirectiveParamOriginal = 'on' then
            ExitDefineBlock();
        end;

        Next();
      end;

    tokCompDirect:
      begin
        if FUseDefines and (FDefineStack = 0) then
        begin
          Def := CompilerDirective;
          if (Def = '$S+') or (Def = '$SCOPEDENUMS ON') then
            AddDefine('!SCOPEDENUMS')
          else
          if (Def = '$S-') or (Def = '$SCOPEDENUMS OFF') then
            RemoveDefine('!SCOPEDENUMS')
          else
          if (Def = '$EXPLICTSELF ON') then
            AddDefine('!EXPLICTSELF')
          else
          if (Def = '$EXPLICTSELF OFF') then
            RemoveDefine('!EXPLICTSELF');
        end;

        if Assigned(fOnCompDirect) and (FDefineStack = 0) then
          fOnCompDirect(Self);
      end;
    tokDefineDirect:
      begin
        if FUseDefines and (FDefineStack = 0) then
          AddDefine(DirectiveParam);
        if Assigned(fOnDefineDirect) then
          fOnDefineDirect(Self);
      end;
    tokElseDirect:
      begin
        if FUseDefines then
        begin
          if FTopDefineRec <> nil then
          begin
            if FTopDefineRec^.Defined then
              Inc(FDefineStack)
            else
              if FDefineStack > 0 then
                Dec(FDefineStack);
          end;
        end;
        if Assigned(fOnElseDirect) then
          fOnElseDirect(Self);
      end;
    tokEndIfDirect:
      begin
        if FUseDefines then
          ExitDefineBlock;
        if Assigned(fOnEndIfDirect) then
          fOnEndIfDirect(Self);
      end;
    tokIfDefDirect:
      begin
        if FUseDefines then
          EnterDefineBlock(IsDefined(DirectiveParam));
        if Assigned(fOnIfDefDirect) then
          fOnIfDefDirect(Self);
      end;
    tokIfNDefDirect:
      begin
        if FUseDefines then
          EnterDefineBlock(not IsDefined(DirectiveParam));
    		if Assigned(fOnIfNDefDirect) then
          fOnIfNDefDirect(Self);
      end;
    tokIfOptDirect:
      begin
        if Assigned(fOnIfOptDirect) then
          fOnIfOptDirect(Self);
      end;
    tokIfDirect:
      begin
        if FUseDefines then
        begin
          Param := DirectiveParam;
          if Pos('DEFINED', Param) = 1 then
          begin
            Def := Copy(Param, 9, Length(Param) - 9);
            EnterDefineBlock(IsDefined(Def));
          end;
        end;
        if Assigned(fOnIfDirect) then
          fOnIfDirect(Self);
      end;
    tokIfEndDirect:
      begin
        if FUseDefines then
          ExitDefineBlock;
        if Assigned(fOnIfEndDirect) then
          fOnIfEndDirect(Self);
      end;
    tokElseIfDirect:
      begin
        if FUseDefines then
        begin
          if FTopDefineRec <> nil then
          begin
            if FTopDefineRec^.Defined then
              Inc(FDefineStack)
            else
            begin
              if FDefineStack > 0 then
                Dec(FDefineStack);
              Param := DirectiveParam;
              if Pos('DEFINED', Param) = 1 then
              begin
                Def := Copy(Param, 9, Length(Param) - 9);
                EnterDefineBlock(IsDefined(Def));
              end;
            end;
          end;
        end;
        if Assigned(fOnElseIfDirect) then
          fOnElseIfDirect(Self);
      end;
    tokIncludeDirect, tokIncludeOnceDirect:
      begin
        if Assigned(fOnIncludeDirect) and (FDefineStack = 0) then
          fOnIncludeDirect(Self);
      end;
    tokLibraryDirect:
      begin
        if Assigned(fOnLibraryDirect) and (FDefineStack = 0) then
          fOnLibraryDirect(Self);
      end;
    tokResourceDirect:
      begin
        if Assigned(fOnResourceDirect) and (FDefineStack = 0) then
          fOnResourceDirect(Self);
      end;
    tokUndefDirect:
      begin
        if FUseDefines and (FDefineStack = 0) then
          RemoveDefine(DirectiveParam);
        if Assigned(fOnUndefDirect) then
          fOnUndefDirect(Self);
      end;
  end;
  Next();
end;

procedure TmwBasePasLex.ColonProc;
begin
  case FOrigin[Run + 1] of
    '=':
      begin
        inc(Run, 2);
        fTokenID := tokAssign;
	    end;
  else
    begin
      inc(Run);
      fTokenID := tokColon;
    end;
  end;
end;

procedure TmwBasePasLex.CommaProc;
begin
  inc(Run);
  fTokenID := tokComma;
end;

procedure TmwBasePasLex.CRProc;
begin
  case fCommentState of
    csBor: fTokenID := tokCRLFCo;
    csAnsi: fTokenID := tokCRLFCo;
    else
      fTokenID := tokCRLF;
  end;

  case FOrigin[Run + 1] of
    #10: inc(Run, 2);
    else
      inc(Run);
  end;

  inc(fLineNumber);
  fLinePos := Run;
end;

procedure TmwBasePasLex.EnterDefineBlock(ADefined: Boolean);
var
  StackFrame: PDefineRec;
begin
  New(StackFrame);
  StackFrame^.Next := FTopDefineRec;
  StackFrame^.Defined := ADefined;
  StackFrame^.StartCount := FDefineStack;
  FTopDefineRec := StackFrame;
  if not ADefined then
    Inc(FDefineStack);
end;

procedure TmwBasePasLex.EqualProc;
begin
  inc(Run);
  fTokenID := tokEqual;
end;

procedure TmwBasePasLex.ExitDefineBlock;
var
  StackFrame: PDefineRec;
begin
  StackFrame := FTopDefineRec;
  if StackFrame <> nil then
  begin
    FDefineStack := StackFrame^.StartCount;
    FTopDefineRec := StackFrame^.Next;
    Dispose(StackFrame);
  end;
end;

procedure TmwBasePasLex.GreaterProc;
begin
  case FOrigin[Run + 1] of
    '=':
      begin
        inc(Run, 2);
        fTokenID := tokGreaterEqual;
      end;
  else
    begin
      inc(Run);
      fTokenID := tokGreater;
	end;
  end;
end;

function TmwBasePasLex.HashValue(AChar: AnsiChar): Integer;
begin
  if AChar <= #255 then
    Result := mHashTable[fOrigin[Run]]
  else
    Result := Ord(AChar);
end;

procedure TmwBasePasLex.IdentProc; inline;
begin
  fTokenID := IdentKind;
end;

procedure TmwBasePasLex.IntegerProc;
begin
  inc(Run);
  fTokenID := tokIntegerConst;
  while FOrigin[Run] in ['0'..'9', 'A'..'F', 'a'..'f'] do
    inc(Run);
end;

function TmwBasePasLex.IsDefined(const ADefine: string): Boolean;
begin
  Result := FDefines.IndexOf(ADefine) > -1;
end;

function TmwBasePasLex.IsIdentifiers(AChar: AnsiChar): Boolean;
begin
  if AChar <= #255 then
    Result := Identifiers[AChar]
  else
    Result := True;
end;

procedure TmwBasePasLex.LFProc;
begin
  case fCommentState of
	  csBor: fTokenID := tokCRLFCo;
	  csAnsi: fTokenID := tokCRLFCo;
    else
      fTokenID := tokCRLF;
  end;
  inc(Run);
  inc(fLineNumber);
  fLinePos := Run;
end;

procedure TmwBasePasLex.LowerProc;
begin
  case FOrigin[Run + 1] of
    '=':
      begin
        inc(Run, 2);
        fTokenID := tokLowerEqual;
      end;
    '>':
      begin
        inc(Run, 2);
        fTokenID := tokNotEqual;
      end
  else
    begin
      inc(Run);
      fTokenID := tokLower;
    end;
  end;
end;

procedure TmwBasePasLex.MinusProc;
begin
  inc(Run);
  if FOrigin[Run] = '=' then
  begin
    inc(Run);
    fTokenID := tokMinusAsgn;
  end else
    fTokenID := tokMinus;
end;

procedure TmwBasePasLex.NullProc;
begin
  fTokenID := tokNull;
end;

procedure TmwBasePasLex.NumberProc;
begin
  inc(Run);
  fTokenID := tokIntegerConst;
  while FOrigin[Run] in ['0'..'9', '.', 'e', 'E'] do
  begin
    case FOrigin[Run] of
      '.':
        if FOrigin[Run + 1] = '.' then
          break
        else fTokenID := tokFloat
    end;
    inc(Run);
  end;
end;

procedure TmwBasePasLex.PlusProc;
begin
  inc(Run);
  if FOrigin[Run] = '=' then
  begin
    inc(Run);
    fTokenID := tokPlusAsgn;
  end else
    fTokenID := tokPlus;
end;

procedure TmwBasePasLex.PointerSymbolProc;
begin
  Inc(Run);
  fTokenID := tokPointerSymbol;
end;

procedure TmwBasePasLex.PointProc;
begin
  case FOrigin[Run + 1] of
    '.':
      begin
        inc(Run, 2);
        fTokenID := tokDotDot;
      end;
    ')':
      begin
        inc(Run, 2);
        fTokenID := tokSquareClose;
      end;
  else
    begin
      inc(Run);
      fTokenID := tokPoint;
    end;
  end;
end;

procedure TmwBasePasLex.RemoveDefine(const ADefine: string);
var
  I: Integer;
begin
  I := FDefines.IndexOf(ADefine);
  if (I > -1) then
    FDefines.Delete(I);
end;

procedure TmwBasePasLex.RoundCloseProc;
begin
  inc(Run);
  fTokenID := tokRoundClose;
end;

procedure TmwBasePasLex.AnsiProc;
begin
  fTokenID := tokAnsiComment;
  case FOrigin[Run] of
    #0:
      begin
        NullProc;
        if Assigned(FOnMessage) then
          FOnMessage(Self, meError, 'Unexpected file end', PosXY.X, PosXY.Y);
        exit;
      end;
  end;

  while fOrigin[Run] <> #0 do
    case fOrigin[Run] of
      '*':
        if fOrigin[Run + 1] = ')' then
        begin
          fCommentState := csNo;
          inc(Run, 2);
          break;
        end
        else inc(Run);

	  #10:
		begin
			inc(Run);
			inc(fLineNumber);
			fLinePos := Run;
		end;
	  #13:
		begin
			inc(Run);
			if FOrigin[Run] = #10 then
        inc(Run);
			inc(fLineNumber);
			fLinePos := Run;
		end;

	  else
      inc(Run);
  end;
end;

procedure TmwBasePasLex.RoundOpenProc;
begin
  inc(Run);
  case fOrigin[Run] of
    '*':
      begin
        fTokenID := tokAnsiComment;
        if FOrigin[Run + 1] = '$' then
          fTokenID := GetDirectiveKind
        else fCommentState := csAnsi;
        inc(Run);
        while fOrigin[Run] <> #0 do
          case fOrigin[Run] of
            '*':
			  if fOrigin[Run + 1] = ')' then
			  begin
				fCommentState := csNo;
				inc(Run, 2);
				break;
			  end
			  else inc(Run);

			  #10:
				begin
					inc(Run);
					inc(fLineNumber);
					fLinePos := Run;
				end;
			  #13:
				begin
					inc(Run);
					if FOrigin[Run] = #10 then inc(Run);
					inc(fLineNumber);
					fLinePos := Run;
				end;
			else inc(Run);
          end;
      end;
    '.':
      begin
        inc(Run);
        fTokenID := tokSquareOpen;
      end;
  else fTokenID := tokRoundOpen;
  end;
  case fTokenID of
    tokCompDirect:
      begin
        if Assigned(fOnCompDirect) then
          fOnCompDirect(Self);
      end;
    tokDefineDirect:
      begin
        if Assigned(fOnDefineDirect) then
          fOnDefineDirect(Self);
      end;
    tokElseDirect:
      begin
        if Assigned(fOnElseDirect) then
          fOnElseDirect(Self);
      end;
    tokEndIfDirect:
      begin
        if Assigned(fOnEndIfDirect) then
          fOnEndIfDirect(Self);
      end;
    tokIfDefDirect:
      begin
        if Assigned(fOnIfDefDirect) then
          fOnIfDefDirect(Self);
      end;
    tokIfNDefDirect:
      begin
        if Assigned(fOnIfNDefDirect) then
          fOnIfNDefDirect(Self);
      end;
    tokIfOptDirect:
      begin
        if Assigned(fOnIfOptDirect) then
          fOnIfOptDirect(Self);
      end;
    tokLibraryDirect:
       begin
        if Assigned(fOnLibraryDirect) then
          fOnLibraryDirect(Self);
      end;
    tokIncludeDirect, tokIncludeOnceDirect:
      begin
        if Assigned(fOnIncludeDirect) then
          fOnIncludeDirect(Self);
      end;
    tokResourceDirect:
      begin
        if Assigned(fOnResourceDirect) then
          fOnResourceDirect(Self);
      end;
    tokUndefDirect:
      begin
        if Assigned(fOnUndefDirect) then
          fOnUndefDirect(Self);
      end;
  end;
end;

procedure TmwBasePasLex.SemiColonProc;
begin
  inc(Run);
  fTokenID := tokSemiColon;
end;

procedure TmwBasePasLex.SetScript(Value: String);
begin
  fScript := Value;
  Origin := PChar(fScript);
end;

procedure TmwBasePasLex.SlashProc;
begin
  case FOrigin[Run + 1] of
    '/':
      begin
        inc(Run, 2);
        fTokenID := tokSlashesComment;
        while FOrigin[Run] <> #0 do
        begin
          case FOrigin[Run] of
            #10, #13: break;
          end;
          inc(Run);
        end;
      end;
    '=': 
      begin
        inc(Run,2);
        fTokenID := tokDivAsgn;
      end;
  else
    begin
      inc(Run);
      fTokenID := tokSlash;
    end;
  end;
end;

procedure TmwBasePasLex.SpaceProc;
begin
  inc(Run);
  fTokenID := tokSpace;
  while FOrigin[Run] in [#1..#9, #11, #12, #14..#32] do
    inc(Run);
end;

procedure TmwBasePasLex.SquareCloseProc;
begin
  inc(Run);
  fTokenID := tokSquareClose;
end;

procedure TmwBasePasLex.SquareOpenProc;
begin
  inc(Run);
  fTokenID := tokSquareOpen;
end;

procedure TmwBasePasLex.StarProc;
begin
  inc(Run);
  case FOrigin[Run]  of
    '=':
      begin
        inc(Run);
        fTokenID := tokMulAsgn;
      end;
    '*':
      begin
        inc(Run);
        if FOrigin[Run] = '=' then
        begin
          inc(Run);
          fTokenID := tokPowAsgn;
        end else
          fTokenID := tokStarStar;
      end;
    else
      fTokenID := tokStar;
  end;
end;

procedure TmwBasePasLex.StringProc;
begin
  fTokenID := tokStringConst;
  repeat
    Inc(Run);
    case FOrigin[Run] of
      #0, #10, #13:
        begin
          if Assigned(FOnMessage) then
            FOnMessage(Self, meError, 'Unterminated string', PosXY.X, PosXY.Y);
          Break;
        end;
      #39:
        while (FOrigin[Run] = #39) and (FOrigin[Run + 1] = #39) do
          Inc(Run, 2);
    end;
  until FOrigin[Run] = #39;

  if FOrigin[Run] = #39 then
  begin
    Inc(Run);
    if TokenLen = 3 then
      fTokenID := tokAsciiChar;
  end;
end;

procedure TmwBasePasLex.SymbolProc;
begin
  inc(Run);
  fTokenID := tokSymbol;
end;

procedure TmwBasePasLex.UnknownProc;
begin
  inc(Run);
  fTokenID := tokUnknown;
  if Assigned(FOnMessage) then
   FOnMessage(Self, meError, 'Unknown Character', PosXY.X, PosXY.Y);
end;

procedure TmwBasePasLex.Next; inline;
begin
  fExID := tokUnKnown;
  fTokenPos := Run;

  case fCommentState of
    csNo: DoProcTable(fOrigin[Run]);
    csBor: BorProc;
    csAnsi: AnsiProc;
  end;

  if (MaxPos > -1) and (fTokenPos > MaxPos) and (not IsJunk) then
    fTokenID := tok_DONE;
end;

function TmwBasePasLex.GetIsJunk: Boolean;
begin
  result := IsTokenIDJunk(FTokenID) or (FUseDefines and (FDefineStack > 0) and (TokenID <> tokNull) and (TokenID <> tok_DONE));
end;

function TmwBasePasLex.GetIsSpace: Boolean;
begin
  Result := fTokenID in [tokCRLF, tokSpace];
end;

function TmwBasePasLex.GetToken: string; inline;
begin
  SetString(Result, (FOrigin + fTokenPos), GetTokenLen);
end;

function TmwBasePasLex.GetTokenLen: Integer; inline;
begin
  Result := Run - fTokenPos;
end;

procedure TmwBasePasLex.NextID(ID: TptTokenKind); inline;
begin
  repeat
    case fTokenID of
      tokNull, tok_DONE: break;
    else Next;
    end;
  until fTokenID = ID;
end;

procedure TmwBasePasLex.NextNoJunk; inline;
begin
  repeat
    Next;
  until not IsJunk;
end;

procedure TmwBasePasLex.NextNoSpace; inline;
begin
  repeat
    Next;
  until not IsSpace;
end;

function TmwBasePasLex.GetCompilerDirective: string;
var
  DirectLen: Integer;
begin
  if TokenID <> tokCompDirect then
    Result := ''
  else
    case fOrigin[fTokenPos] of
      '(':
        begin
          DirectLen := Run - fTokenPos - 4;
          SetString(Result, (FOrigin + fTokenPos + 2), DirectLen);
          Result := UpperCase(Result);
        end;
      '{':
        begin
          DirectLen := Run - fTokenPos - 2;
          SetString(Result, (FOrigin + fTokenPos + 1), DirectLen);
          Result := UpperCase(Result);
        end;
    end;
end;

function TmwBasePasLex.GetDirectiveKind: TptTokenKind;
var
  TempPos: Integer;
begin
  case fOrigin[fTokenPos] of
    '(': Run := FTokenPos + 3;
    '{': Run := FTokenPos + 2;
  end;
  FDirectiveParamOrigin := FOrigin + FTokenPos;
  TempPos := fTokenPos;
  fTokenPos := Run;

  case KeyHash of
    9:
      if KeyComp('I') then
        Result := tokIncludeDirect else
        Result := tokCompDirect;
    15:
      if KeyComp('IF') then
        Result := tokIfDirect else
        Result := tokCompDirect;
    18:
      if KeyComp('R') then
      begin
        if not (fOrigin[Run] in ['+', '-']) then
          Result := tokResourceDirect else Result := tokCompDirect;
      end else Result := tokCompDirect;
    30:
      if KeyComp('IFDEF') then
        Result := tokIfDefDirect else
        Result := tokCompDirect;
    38:
      if KeyComp('ENDIF') then
        Result := tokEndIfDirect else
      if KeyComp('IFEND') then
        Result := tokIfEndDirect else
        Result := tokCompDirect;
    41:
      if KeyComp('ELSE') then
        Result := tokElseDirect else
        Result := tokCompDirect;
    43:
      if KeyComp('DEFINE') then
        Result := tokDefineDirect else
        Result := tokCompDirect;
    44:
      if KeyComp('IFNDEF') then
        Result := tokIfNDefDirect else
        Result := tokCompDirect;
    50:
      if KeyComp('UNDEF') then
        Result := tokUndefDirect else
        Result := tokCompDirect;
    55:
      if KeyComp('LOADLIB') then
        Result := tokLibraryDirect else
        Result := tokCompDirect;
    56:
      if KeyComp('ELSEIF') then
        Result := tokElseIfDirect else
        Result := tokCompDirect;
    66:
      if KeyComp('IFOPT') then
        Result := tokIfOptDirect else
        Result := tokCompDirect;
    68:
      if KeyComp('INCLUDE') then
        Result := tokIncludeDirect else
        Result := tokCompDirect;
    104:
      if KeyComp('RESOURCE') then
        Result := tokResourceDirect else
        Result := tokCompDirect;
    136: if KeyComp('INCLUDE_ONCE') then
        Result := tokIncludeOnceDirect else
        Result := tokCompDirect;
  else Result := tokCompDirect;
  end;
  fTokenPos := TempPos;
  dec(Run);
end;

function TmwBasePasLex.GetIDEDirectiveKind: TptTokenKind;
var
  TempPos: Integer;
begin
  case fOrigin[fTokenPos] of
    '(': Run := FTokenPos + 3;
    '{': Run := FTokenPos + 2;
  end;
  fDirectiveParamOrigin := FOrigin + FTokenPos;
  TempPos := fTokenPos;
  fTokenPos := Run;

   case KeyHash of
     108:
       if KeyComp('CODETOOLS') then
         Result := tokIDECodeTools
       else
         Result := tokCompDirect;
     else
       Result := tokCompDirect;
  end;

  fTokenPos := TempPos;
  dec(Run);
end;

function TmwBasePasLex.GetDirectiveParamOriginal: string;
var
  EndPos: Integer;
  ParamLen: Integer;
begin
  // !! without this set... there is a warning?
  EndPos:= 0;
  case fOrigin[fTokenPos] of
    '(':
      begin
        TempRun := FTokenPos + 3;
        EndPos := Run - 2;
      end;
    '{':
      begin
        TempRun := FTokenPos + 2;
        EndPos := Run - 1;
      end;
  end;
  while IsIdentifiers(fOrigin[TempRun]) do
    inc(TempRun);
  while fOrigin[TempRun] in ['+', ',', '-'] do
  begin
    inc(TempRun);
    while IsIdentifiers(fOrigin[TempRun]) do
      inc(TempRun);
    if (fOrigin[TempRun - 1] in ['+', ',', '-']) and (fOrigin[TempRun] = ' ')
      then inc(TempRun);
  end;
  if fOrigin[TempRun] = ' ' then inc(TempRun);
  ParamLen := EndPos - TempRun;
  SetString(Result, (FOrigin + TempRun), ParamLen);
end;

function TmwBasePasLex.GetDirectiveParam: string;
begin
  result := uppercase(GetDirectiveParamOriginal);
end;

procedure TmwBasePasLex.Init;
begin
  fCommentState := csNo;
  fLineNumber := 0;
  fLinePos := 0;
  Run := 0;
  //InitDefines;
end;

procedure TmwBasePasLex.InitFrom(ALexer: TmwBasePasLex);
begin
  Origin := ALexer.Origin;
  fCommentState := ALexer.fCommentState;
  fLineNumber := ALexer.fLineNumber;
  fLinePos := ALexer.fLinePos;
  Run := ALexer.Run;
  CloneDefinesFrom(ALexer);
end;

procedure TmwBasePasLex.InitDefines;
begin
  ClearDefines;
end;

function TmwBasePasLex.GetIsCompilerDirective: Boolean;
begin
  Result := fTokenID in [tokCompDirect, tokDefineDirect, tokElseDirect,
    tokEndIfDirect, tokIfDefDirect, tokIfNDefDirect, tokIfOptDirect,
    tokIncludeDirect, tokIncludeOnceDirect, tokResourceDirect, tokUndefDirect, tokLibraryDirect];
end;

function TmwBasePasLex.GetGenID: TptTokenKind;
begin
  Result := fTokenID;
  if fTokenID = tokIdentifier then
    if fExID <> tokUnknown then Result := fExID;
end;

constructor TmwPasLex.Create;
begin
  inherited Create;
  fAheadLex := TmwBasePasLex.Create;
end;

destructor TmwPasLex.Destroy;
begin
  fAheadLex.Free;
  inherited Destroy;
end;

procedure TmwPasLex.SetOrigin(NewValue: PAnsiChar);
begin
  inherited SetOrigin(NewValue);
  fAheadLex.SetOrigin(NewValue);
end;

procedure TmwPasLex.AheadNext;
begin
  fAheadLex.NextNoJunk;
end;

function TmwPasLex.GetAheadExID: TptTokenKind;
begin
  Result := fAheadLex.ExID;
end;

function TmwPasLex.GetAheadGenID: TptTokenKind;
begin
  Result := fAheadLex.GenID;
end;

function TmwPasLex.GetAheadToken: string;
begin
  Result := fAheadLex.Token;
end;

function TmwPasLex.GetAheadTokenID: TptTokenKind;
begin
  Result := fAheadLex.TokenID;
end;

procedure TmwPasLex.InitAhead;
begin
  fAheadLex.RunPos := RunPos;
  FAheadLex.fLineNumber := FLineNumber;
  FAheadLex.FLinePos := FLinePos;

  FAheadLex.CloneDefinesFrom(Self);

  //FAheadLex.FTokenPos := FTokenPos;
  while fAheadLex.IsJunk do
    fAheadLex.Next;
end;

function TmwPasLex.GetStatus: TmwPasLexStatus;
begin
  Result.CommentState := fCommentState;
  Result.ExID := fExID;
  Result.LineNumber := fLineNumber;
  Result.LinePos := fLinePos;
  Result.Origin := fOrigin;
  Result.RunPos := Run;
  Result.TokenPos := fTokenPos;
  Result.TokenID := fTokenID;
end;

procedure TmwPasLex.SetStatus(const Value: TmwPasLexStatus);
begin
  fCommentState := Value.CommentState;
  fExID := Value.ExID;
  fLineNumber := Value.LineNumber;
  fLinePos := Value.LinePos;
  fOrigin := Value.Origin;
  Run := Value.RunPos;
  fTokenPos := Value.TokenPos;
  fTokenID := Value.TokenID;
  fAheadLex.Origin := Value.Origin;
end;

procedure TmwBasePasLex.SetOnCompDirect(const Value: TDirectiveEvent);
begin
  fOnCompDirect := Value;
end;

procedure TmwBasePasLex.SetOnDefineDirect(const Value: TDirectiveEvent);
begin
  fOnDefineDirect := Value;
end;

procedure TmwBasePasLex.SetOnElseDirect(const Value: TDirectiveEvent);
begin
  fOnElseDirect := Value;
end;

procedure TmwBasePasLex.SetOnElseIfDirect(const Value: TDirectiveEvent);
begin
  fOnElseIfDirect := Value;
end;

procedure TmwBasePasLex.SetOnEndIfDirect(const Value: TDirectiveEvent);
begin
  fOnEndIfDirect := Value;
end;

procedure TmwBasePasLex.SetOnIfDefDirect(const Value: TDirectiveEvent);
begin
  fOnIfDefDirect := Value;
end;

procedure TmwBasePasLex.SetOnIfDirect(const Value: TDirectiveEvent);
begin
  FOnIfDirect := Value;
end;

procedure TmwBasePasLex.SetOnIfEndDirect(const Value: TDirectiveEvent);
begin
  FOnIfEndDirect := Value;
end;

procedure TmwBasePasLex.SetOnIfNDefDirect(const Value: TDirectiveEvent);
begin
  fOnIfNDefDirect := Value;
end;

procedure TmwBasePasLex.SetOnIfOptDirect(const Value: TDirectiveEvent);
begin
  fOnIfOptDirect := Value;
end;

procedure TmwBasePasLex.SetOnIncludeDirect(const Value: TDirectiveEvent);
begin
  fOnIncludeDirect := Value;
end;

procedure TmwBasePasLex.SetOnLibraryDirect(const Value: TDirectiveEvent);
begin
  fOnLibraryDirect := Value;
end;

procedure TmwBasePasLex.SetOnResourceDirect(const Value: TDirectiveEvent);
begin
  fOnResourceDirect := Value;
end;

procedure TmwBasePasLex.SetOnUnDefDirect(const Value: TDirectiveEvent);
begin
  fOnUnDefDirect := Value;
end;

procedure TmwPasLex.SetOnCompDirect(const Value: TDirectiveEvent);
begin
  inherited;
  //AheadLex.OnCompDirect := Value;
end;

procedure TmwPasLex.SetOnDefineDirect(const Value: TDirectiveEvent);
begin
  inherited;
  //AheadLex.OnDefineDirect := Value;
end;

procedure TmwPasLex.SetOnElseDirect(const Value: TDirectiveEvent);
begin
  inherited;
  //AheadLex.OnElseDirect := Value;
end;

procedure TmwPasLex.SetOnEndIfDirect(const Value: TDirectiveEvent);
begin
  inherited;
  //AheadLex.OnEndIfDirect := Value;
end;

procedure TmwPasLex.SetOnIfDefDirect(const Value: TDirectiveEvent);
begin
  inherited;
  //AheadLex.OnIfDefDirect := Value;
end;

procedure TmwPasLex.SetOnIfNDefDirect(const Value: TDirectiveEvent);
begin
  inherited;
  //AheadLex.OnIfNDefDirect := Value;
end;

procedure TmwPasLex.SetOnIfOptDirect(const Value: TDirectiveEvent);
begin
  inherited;
  //AheadLex.OnIfOptDirect := Value;
end;

procedure TmwPasLex.SetOnIncludeDirect(const Value: TDirectiveEvent);
begin
  inherited;
  //AheadLex.OnIncludeDirect := Value;
end;

procedure TmwPasLex.SetOnResourceDirect(const Value: TDirectiveEvent);
begin
  inherited;
  //AheadLex.OnResourceDirect := Value;
end;

procedure TmwPasLex.SetOnUnDefDirect(const Value: TDirectiveEvent);
begin
  inherited;
  //AheadLex.OnUnDefDirect := Value;
end;

procedure TmwBasePasLex.StringDQProc;
begin
  fTokenID := tokStringConst;
  repeat
    inc(Run);
    case FOrigin[Run] of
      #0{, #10, #13}:
        begin
          if Assigned(FOnMessage) then
          FOnMessage(Self, meError, 'Unterminated string', PosXY.X, PosXY.Y);
          break;
        end;
      #34:
        while (FOrigin[Run] = #34) and (FOrigin[Run + 1] = #34) do
          inc(Run, 2);
    end;
  until FOrigin[Run] = #34;
  if FOrigin[Run] = #34 then
  begin
    inc(Run);
    if TokenLen = 3 then
      fTokenID := tokAsciiChar;
  end;
  {
	if not fAsmCode then
	begin
		SymbolProc;
		Exit;
	end;
  fTokenID := tokStringDQConst;
  repeat
	inc(Run);
	case FOrigin[Run] of
	  #0, #10, #13:
		begin
		  if Assigned(FOnMessage) then
			FOnMessage(Self, meError, 'Unterminated string', PosXY.X, PosXY.Y);
		  break;
		end;
	  '\':
		begin
		  Inc( Run );
		  if FOrigin[Run] in [#32..#255] then Inc( Run );
		end;
	end;
  until FOrigin[Run] = '"';
  if FOrigin[Run] = '"' then
	inc(Run);
  }
end;

procedure TmwBasePasLex.AmpersandOpProc;
begin
  FTokenID := tokAmpersand;
  inc(Run);
  while FOrigin[Run] in ['a'..'z', 'A'..'Z','0'..'9'] do
    inc(Run);
  FTokenID := tokIdentifier;
end;

initialization
  MakeIdentTable;

end.

