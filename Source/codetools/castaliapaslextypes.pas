{
  The contents of this file are subject to the Mozilla Public License Version
  1.1 (the "License"); you may not use this file except in compliance with the
  License. You may obtain a copy of the License at
  http://www.mozilla.org/NPL/NPL-1_1Final.html

  Software distributed under the License is distributed on an "AS IS" basis,
  WITHOUT WARRANTY OF ANY KIND, either express or implied. See the License for
  the specific language governing rights and limitations under the License.
}
unit castaliapaslextypes;

{$MODE DELPHI}

{$DEFINE D8_NEWER}
{$DEFINE D9_NEWER}
{$DEFINE D10_NEWER}

interface

uses SysUtils, TypInfo;

var
  CompTable: array[#0..#255] of byte;

type
  TMessageEventType = (meError, meNotSupported);
  TMessageEvent = procedure(Sender: TObject; const Typ: TMessageEventType; const Msg: string; X, Y: integer) of object; //jdj 7/16/1999; DR 2001-11-06

  TCommentState = (csAnsi, csBor, csNo);

  TTokenPoint = packed record
    X: integer;
    Y: integer;
  end;

  TptTokenKind = (
    tokAbsolute,
    tokAbstract,
    tokAdd,
    tokAddressOp,
    tokAmpersand,
    tokAnd,
    tokAnsiComment,
    tokArray,
    tokAs,
    tokAsciiChar,
    tokAsm,
    tokAssembler,
    tokAssign,
    tokAt,
    tokBegin,

    tokBorComment,
    tokBraceClose,
    tokBraceOpen,
    tokBreak, //JThurman 2004-11-8 (flow control routines)

    tokCase,
    tokCdecl,
    tokClass,
    tokClassForward,
    tokClassFunction,
    tokClassProcedure,
    tokColon,
    tokComma,
    tokCompDirect,
    tokConst, tokConstRef,
    tokConstructor,
    tokContinue, //JThurman 2004-11-8 (flow control routines)
    tokCRLF,
    tokCRLFCo,
    tokDefault,
    tokDefineDirect,
    tokDeprecated, // DR 2001-10-20
    tokDestructor,
    tokDiv,
    tokDo,
    tokDotDot,
    tokDoubleAddressOp,
    tokDownto,
    tokElse,
    tokElseDirect,
    tokEnd,
    tokEndIfDirect,
    tokEnum,
    tokEqual,
    tokError,
    tokExcept,
    tokExit, //JThurman 2004-11-8 (flow control routine)
    tokExport,
    tokExports,
    tokExternal,
  {$IFDEF D8_NEWER}//JThurman 2004-03-20
    tokFinal,
  {$ENDIF}
    tokFinalization,
    tokFinally,
    tokFloat,
    tokFor,
    tokForward,
    tokFunction,
    tokGoto,
    tokGreater,
    tokGreaterEqual,
    tokHalt, //JThurman 2004-11-8 (flow control routines)
  {$IFDEF D8_NEWER}//JThurman 2004-04-06
    tokHelper,
  {$ENDIF}
    tokIdentifier,
    tokIf,
    tokIfDirect,
    tokIfEndDirect,
    tokElseIfDirect,
    tokIfDefDirect,
    tokIfNDefDirect,
    tokIfOptDirect,
    tokIDECodeTools,
    tokImplementation,
    tokImplements,
    tokIn,
    tokIncludeDirect,
    tokIncludeOnceDirect,
    tokLibraryDirect,
    tokIndex,
    tokInitialization,
    tokInline,
    tokIntegerConst,
    tokInterface,
    tokIs,
    tokLabel,
    tokLibrary,
    tokLower,
    tokLowerEqual,
    tokMessage,
    tokMinus,
    tokMod,
    tokName,
    tokNodefault,
    tokNone,
    tokNot,
    tokNotEqual,
    tokNull,
    tokObject,
    tokOf,
    tokOn,
  {$IFDEF D8_NEWER}//JThurman 2004-03-20
    tokOperator,
  {$ENDIF}
    tokOr,
    tokOut,
    tokOverload,
    tokOverride,
    tokPackage,
    tokPacked,
    tokPlatform, // DR 2001-10-20
    tokPlus,
    tokPoint,
    tokPointerSymbol,
    tokPrivate,
    tokProcedure,
    tokProgram,
    tokProperty,
    tokProtected,
    tokPublic,
    tokPublished,
    tokRaise,
    tokRead,
    tokRecord,
    tokUnion,
  {$IFDEF D12_NEWER}
    tokReference, //JThurman 2008-25-07 (anonymous methods)
  {$ENDIF}
    tokRegister,
    tokReintroduce,
    tokRepeat,
    tokRequires,
    tokResourceDirect,
    tokResourcestring,
    tokRoundClose,
    tokRoundOpen,
    tokRunError, //JThurman 2004-11-8 (flow control routines)
    tokSafeCall,
  {$IFDEF D8_NEWER}//JThurman 2004-03-19
    tokSealed,
  {$ENDIF}
    tokSemiColon,
    tokSet,
    tokShl,
    tokShr,
    tokSlash,
    tokSlashesComment,
    tokSpace,
    tokSquareClose,
    tokSquareOpen,
    tokStar,
    tokStarStar,
  {$IFDEF D8_NEWER}//JThurman 2004-03-20
    tokStatic,
  {$ENDIF}
    tokStdcall,
    tokStored,
  {$IFDEF D8_NEWER}
    tokStrict, //JThurman 2004-03-03
  {$ENDIF}
    tokStringConst,
    tokStringresource,
    tokSymbol,
    tokThen,
    tokThreadvar,
    tokTo,
    tokTry,
    tokType,
    tokUndefDirect,
    tokUnit,
    tokUnknown,
  {$IFDEF D8_NEWER}//JThurman 2004-03-2003
    tokUnsafe,
  {$ENDIF}
    tokUntil,
    tokUses,
    tokVar,
    tokWrite,
    tokVirtual,
    tokWhile,
    tokWith,
    tokXor,

    tokNative,

    tokDivAsgn,
    tokMulAsgn,
    tokPlusAsgn,
    tokMinusAsgn,
    tokPowAsgn,

    tok_DONE);

  TmwPasLexStatus = record
    CommentState: TCommentState;
    ExID: TptTokenKind;
    LineNumber: integer;
    LinePos: integer;
    Origin: PAnsiChar;
    RunPos: integer;
    TokenPos: integer;
    TokenID: TptTokenKind;
  end;

function TokenName(Value: TptTokenKind): string;
function tokTokenName(Value: TptTokenKind): string;
function IsTokenIDJunk(const aTokenID: TptTokenKind): boolean; //XM 20001210

implementation

function TokenName(Value: TptTokenKind): string;
begin //jdj 7/18/1999
  Result := Copy(tokTokenName(Value), 4, MaxInt);
end;

function tokTokenName(Value: TptTokenKind): string;
begin
  Result := GetEnumName(TypeInfo(TptTokenKind), integer(Value));
end;

function IsTokenIDJunk(const aTokenID: TptTokenKind): boolean; //XM 20001210
begin
  Result := aTokenID in [tokAnsiComment, tokBorComment, tokCRLF,
    tokCRLFCo, tokSlashesComment, tokSpace, tokIfDirect, tokIfEndDirect,
    tokElseIfDirect, tokIfDefDirect, tokIfNDefDirect, tokEndIfDirect,
    tokIfOptDirect, tokDefineDirect, tokUndefDirect];
end;


end.
