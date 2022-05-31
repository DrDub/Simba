unit simba.import_string;

{$i simba.inc}

interface

implementation

uses
  classes, sysutils, lptypes,  uregexpr, strutils,
  simba.script_compiler, simba.mufasatypes, simba.stringutil,
  simba.helpers_string;

procedure _LapeExtractFromStr(const Params: PParamArray; const Result: Pointer); {$IFDEF Lape_CDECL}cdecl;{$ENDIF}
begin
  Pstring(Result)^ := ExtractFromStr(Pstring(Params^[0])^, PStrExtr(Params^[1])^);
end;

procedure _LapeBetween(const Params: PParamArray; const Result: Pointer); {$IFDEF Lape_CDECL}cdecl;{$ENDIF}
begin
  Pstring(Result)^ := Between(Pstring(Params^[0])^, Pstring(Params^[1])^, Pstring(Params^[2])^);
end;

procedure _LapeImplode(const Params: PParamArray; const Result: Pointer); {$IFDEF Lape_CDECL}cdecl;{$ENDIF}
begin
  Pstring(Result)^ := Implode(Pstring(Params^[0])^, PStringArray(Params^[1])^);
end;

procedure _LapeExplode(const Params: PParamArray; const Result: Pointer); {$IFDEF Lape_CDECL}cdecl;{$ENDIF}
begin
  PStringArray(Result)^ := Explode(Pstring(Params^[0])^, Pstring(Params^[1])^);
end;

procedure _LapeExecRegExpr(const Params: PParamArray; const Result: Pointer); {$IFDEF Lape_CDECL}cdecl;{$ENDIF}
begin
  Pboolean(Result)^ := ExecRegExpr(PString(Params^[0])^, PString(Params^[1])^);
end;

procedure _LapeSplitRegExpr(const Params: PParamArray; const Result: Pointer); {$IFDEF Lape_CDECL}cdecl;{$ENDIF}
var
  List: TStringList;
begin
  List := TStringList.Create();
  try
    SplitRegExpr(PString(Params^[0])^, PString(Params^[1])^, List);

    PStringArray(Result)^ := List.ToStringArray();
  finally
    List.Free();
  end;
end;

procedure _LapeReplaceRegExpr(const Params: PParamArray; const Result: Pointer); {$IFDEF Lape_CDECL}cdecl;{$ENDIF}
begin
  PString(Result)^ := ReplaceRegExpr(PString(Params^[0])^, PString(Params^[1])^, PString(Params^[2])^, Pboolean(Params^[3])^);
end;

procedure _LapePosEx(const Params: PParamArray; const Result: Pointer); {$IFDEF Lape_CDECL}cdecl;{$ENDIF}
begin
  PInteger(Result)^ := PosEx(PString(Params^[0])^, PString(Params^[1])^, PInteger(Params^[2])^);
end;

procedure _LapeLevDist(const Params: PParamArray; const Result: Pointer); {$IFDEF Lape_CDECL}cdecl;{$ENDIF}
begin
  PInteger(Result)^ := LevDistance(PString(Params^[0])^, PString(Params^[1])^);
end;

procedure _LapeMultiBetween(const Params: PParamArray; const Result: Pointer); {$IFDEF Lape_CDECL}cdecl;{$ENDIF}
begin
  PStringArray(Result)^ := MultiBetween(PString(Params^[0])^, PString(Params^[1])^, PString(Params^[2])^);
end;

procedure _LapeIsArrInStr(const Params: PParamArray; const Result: Pointer); {$IFDEF Lape_CDECL}cdecl;{$ENDIF}
begin
  PBoolean(Result)^ := IsArrInStr(PStringArray(Params^[0])^, PString(Params^[1])^);
end;

procedure _LapePosMulti(const Params: PParamArray; const Result: Pointer); {$IFDEF Lape_CDECL}cdecl;{$ENDIF}
begin
  PIntegerArray(Result)^ := PosMulti(PString(Params^[0])^, PString(Params^[1])^);
end;

procedure _LapeIsStrInArr(const Params: PParamArray; const Result: Pointer); {$IFDEF Lape_CDECL}cdecl;{$ENDIF}
begin
  PBoolean(Result)^ := IsStrInArr(PString(Params^[0])^, PBoolean(Params^[1])^, PStringArray(Params^[2])^);
end;

procedure _LapeUTF8Decode(const Params: PParamArray; const Result: Pointer); {$IFDEF Lape_CDECL}cdecl;{$ENDIF}
begin
  PWideString(Result)^ := UTF8Decode(PString(Params^[0])^);
end;

procedure _LapeUTF8Encode(const Params: PParamArray; const Result: Pointer); {$IFDEF Lape_CDECL}cdecl;{$ENDIF}
begin
  PAnsiString(Result)^ := UTF8Encode(PWideString(Params^[0])^);
end;

procedure _LapeString_Before(const Params: PParamArray; const Result: Pointer); {$IFDEF Lape_CDECL}cdecl;{$ENDIF}
begin
  PString(Result)^ := PString(Params^[0])^.Before(PString(Params^[1])^);
end;

procedure _LapeString_After(const Params: PParamArray; const Result: Pointer); {$IFDEF Lape_CDECL}cdecl;{$ENDIF}
begin
  PString(Result)^ := PString(Params^[0])^.After(PString(Params^[1])^);
end;

procedure _LapeString_StartsWith(const Params: PParamArray; const Result: Pointer); {$IFDEF Lape_CDECL}cdecl;{$ENDIF}
begin
  PBoolean(Result)^ := PString(Params^[0])^.StartsWith(PString(Params^[1])^, PBoolean(Params^[2])^);
end;

procedure _LapeString_EndsWith(const Params: PParamArray; const Result: Pointer); {$IFDEF Lape_CDECL}cdecl;{$ENDIF}
begin
  PBoolean(Result)^ := PString(Params^[0])^.EndsWith(PString(Params^[1])^, PBoolean(Params^[2])^);
end;

procedure _LapeString_IsUpper(const Params: PParamArray; const Result: Pointer); {$IFDEF Lape_CDECL}cdecl;{$ENDIF}
begin
  PBoolean(Result)^ := PString(Params^[0])^.IsUpper();
end;

procedure _LapeString_IsLower(const Params: PParamArray; const Result: Pointer); {$IFDEF Lape_CDECL}cdecl;{$ENDIF}
begin
  PBoolean(Result)^ := PString(Params^[0])^.IsLower();
end;

procedure _LapeString_ToUpper(const Params: PParamArray; const Result: Pointer); {$IFDEF Lape_CDECL}cdecl;{$ENDIF}
begin
  PString(Result)^ := PString(Params^[0])^.ToUpper();
end;

procedure _LapeString_ToLower(const Params: PParamArray; const Result: Pointer); {$IFDEF Lape_CDECL}cdecl;{$ENDIF}
begin
  PString(Result)^ := PString(Params^[0])^.ToLower();
end;

procedure _LapeString_Capitalize(const Params: PParamArray; const Result: Pointer); {$IFDEF Lape_CDECL}cdecl;{$ENDIF}
begin
  PString(Result)^ := PString(Params^[0])^.Capitalize();
end;

procedure _LapeString_Split(const Params: PParamArray; const Result: Pointer); {$IFDEF Lape_CDECL}cdecl;{$ENDIF}
begin
  PStringArray(Result)^ := PString(Params^[0])^.Split(PString(Params^[1])^);
end;

procedure _LapeString_PadLeft(const Params: PParamArray; const Result: Pointer); {$IFDEF Lape_CDECL}cdecl;{$ENDIF}
begin
  PString(Result)^ := PString(Params^[0])^.PadLeft(PInteger(Params^[1])^, PChar(Params^[2])^);
end;

procedure _LapeString_PadRight(const Params: PParamArray; const Result: Pointer); {$IFDEF Lape_CDECL}cdecl;{$ENDIF}
begin
  PString(Result)^ := PString(Params^[0])^.PadRight(PInteger(Params^[1])^, PChar(Params^[2])^);
end;

procedure _LapeString_Partition(const Params: PParamArray; const Result: Pointer); {$IFDEF Lape_CDECL}cdecl;{$ENDIF}
begin
  PStringArray(Result)^ := PString(Params^[0])^.Partition(PString(Params^[1])^);
end;

procedure _LapeString_Replace(const Params: PParamArray; const Result: Pointer); {$IFDEF Lape_CDECL}cdecl;{$ENDIF}
begin
  PString(Result)^ := PString(Params^[0])^.Replace(PString(Params^[1])^, PString(Params^[2])^);
end;

procedure _LapeString_ReplaceEx(const Params: PParamArray; const Result: Pointer); {$IFDEF Lape_CDECL}cdecl;{$ENDIF}
type
  PReplaceFlags = ^TReplaceFlags;
begin
  PString(Result)^ := PString(Params^[0])^.Replace(PString(Params^[1])^, PString(Params^[2])^, PReplaceFlags(Params^[3])^);
end;

procedure _LapeString_Trim(const Params: PParamArray; const Result: Pointer); {$IFDEF Lape_CDECL}cdecl;{$ENDIF}
begin
  PString(Result)^ := PString(Params^[0])^.Trim();
end;

procedure _LapeString_TrimLeft(const Params: PParamArray; const Result: Pointer); {$IFDEF Lape_CDECL}cdecl;{$ENDIF}
begin
  PString(Result)^ := PString(Params^[0])^.TrimLeft();
end;

procedure _LapeString_TrimRight(const Params: PParamArray; const Result: Pointer); {$IFDEF Lape_CDECL}cdecl;{$ENDIF}
begin
  PString(Result)^ := PString(Params^[0])^.TrimRight();
end;

procedure _LapeString_TrimEx(const Params: PParamArray; const Result: Pointer); {$IFDEF Lape_CDECL}cdecl;{$ENDIF}
type
  PCharArray = ^TCharArray;
begin
  PString(Result)^ := PString(Params^[0])^.Trim(PCharArray(Params^[1])^);
end;

procedure _LapeString_TrimLeftEx(const Params: PParamArray; const Result: Pointer); {$IFDEF Lape_CDECL}cdecl;{$ENDIF}
type
  PCharArray = ^TCharArray;
begin
  PString(Result)^ := PString(Params^[0])^.TrimLeft(PCharArray(Params^[1])^);
end;

procedure _LapeString_TrimRightEx(const Params: PParamArray; const Result: Pointer); {$IFDEF Lape_CDECL}cdecl;{$ENDIF}
type
  PCharArray = ^TCharArray;
begin
  PString(Result)^ := PString(Params^[0])^.TrimRight(PCharArray(Params^[1])^);
end;

procedure _LapeString_RegExprSplit(const Params: PParamArray; const Result: Pointer); {$IFDEF Lape_CDECL}cdecl;{$ENDIF}
begin
  PStringArray(Result)^ := PString(Params^[0])^.RegExprSplit(PString(Params^[1])^);
end;

procedure _LapeString_RegExprFind(const Params: PParamArray; const Result: Pointer); {$IFDEF Lape_CDECL}cdecl;{$ENDIF}
begin
  PRegExprMatch(Result)^ := PString(Params^[0])^.RegExprFind(PString(Params^[1])^);
end;

procedure _LapeString_RegExprFindAll(const Params: PParamArray; const Result: Pointer); {$IFDEF Lape_CDECL}cdecl;{$ENDIF}
begin
  PRegExprMatchArray(Result)^ := PString(Params^[0])^.RegExprFindAll(PString(Params^[1])^);
end;

procedure _LapeString_RegExprExists(const Params: PParamArray; const Result: Pointer); {$IFDEF Lape_CDECL}cdecl;{$ENDIF}
begin
  PBoolean(Result)^ := PString(Params^[0])^.RegExprExists(PString(Params^[1])^);
end;

procedure _LapeString_CopyRange(const Params: PParamArray; const Result: Pointer); {$IFDEF Lape_CDECL}cdecl;{$ENDIF}
begin
  PString(Result)^ := PString(Params^[0])^.CopyRange(PInteger(Params^[1])^, PInteger(Params^[2])^);
end;

procedure _LapeString_DeleteRange(const Params: PParamArray); {$IFDEF Lape_CDECL}cdecl;{$ENDIF}
begin
  PString(Params^[0])^.DeleteRange(PInteger(Params^[1])^, PInteger(Params^[2])^);
end;

procedure _LapeString_Insert(const Params: PParamArray); {$IFDEF Lape_CDECL}cdecl;{$ENDIF}
begin
  PString(Params^[0])^.Insert(PString(Params^[1])^, PInteger(Params^[2])^);
end;

procedure _LapeString_Append(const Params: PParamArray); {$IFDEF Lape_CDECL}cdecl;{$ENDIF}
begin
  PString(Params^[0])^.Append(PChar(Params^[1])^);
end;

procedure _LapeString_Extend(const Params: PParamArray); {$IFDEF Lape_CDECL}cdecl;{$ENDIF}
begin
  PString(Params^[0])^.Extend(PString(Params^[1])^);
end;

procedure _LapeString_Remove(const Params: PParamArray; const Result: Pointer); {$IFDEF Lape_CDECL}cdecl;{$ENDIF}
begin
  PBoolean(Result)^ := PString(Params^[0])^.Remove(PString(Params^[1])^);
end;

procedure _LapeString_RemoveAll(const Params: PParamArray; const Result: Pointer); {$IFDEF Lape_CDECL}cdecl;{$ENDIF}
begin
  PInteger(Result)^ := PString(Params^[0])^.RemoveAll(PString(Params^[1])^);
end;

procedure _LapeString_IndexOf(const Params: PParamArray; const Result: Pointer); {$IFDEF Lape_CDECL}cdecl;{$ENDIF}
begin
  PInteger(Result)^ := PString(Params^[0])^.IndexOf(PString(Params^[1])^);
end;

procedure _LapeString_IndexOfEx(const Params: PParamArray; const Result: Pointer); {$IFDEF Lape_CDECL}cdecl;{$ENDIF}
begin
  PInteger(Result)^ := PString(Params^[0])^.IndexOf(PString(Params^[1])^, PInteger(Params^[2])^);
end;

procedure _LapeString_LastIndexOf(const Params: PParamArray; const Result: Pointer); {$IFDEF Lape_CDECL}cdecl;{$ENDIF}
begin
  PInteger(Result)^ := PString(Params^[0])^.LastIndexOf(PString(Params^[1])^);
end;

procedure _LapeString_LastIndexOfEx(const Params: PParamArray; const Result: Pointer); {$IFDEF Lape_CDECL}cdecl;{$ENDIF}
begin
  PInteger(Result)^ := PString(Params^[0])^.LastIndexOf(PString(Params^[1])^, PInteger(Params^[2])^);
end;

procedure _LapeString_IndicesOf(const Params: PParamArray; const Result: Pointer); {$IFDEF Lape_CDECL}cdecl;{$ENDIF}
begin
  PIntegerArray(Result)^ := PString(Params^[0])^.IndicesOf(PString(Params^[1])^);
end;

procedure _LapeString_IndicesOfEx(const Params: PParamArray; const Result: Pointer); {$IFDEF Lape_CDECL}cdecl;{$ENDIF}
begin
  PIntegerArray(Result)^ := PString(Params^[0])^.IndicesOf(PString(Params^[1])^, PInteger(Params^[2])^);
end;

procedure _LapeString_Between(const Params: PParamArray; const Result: Pointer); {$IFDEF Lape_CDECL}cdecl;{$ENDIF}
begin
  PString(Result)^ := PString(Params^[0])^.Between(PString(Params^[1])^, PString(Params^[2])^);
end;

procedure _LapeString_BetweenAll(const Params: PParamArray; const Result: Pointer); {$IFDEF Lape_CDECL}cdecl;{$ENDIF}
begin
  PStringArray(Result)^ := PString(Params^[0])^.BetweenAll(PString(Params^[1])^, PString(Params^[2])^);
end;

procedure _LapeString_NumberChars(const Params: PParamArray; const Result: Pointer); {$IFDEF Lape_CDECL}cdecl;{$ENDIF}
begin
  PString(Result)^ := String.NumberChars;
end;

procedure _LapeString_LowerChars(const Params: PParamArray; const Result: Pointer); {$IFDEF Lape_CDECL}cdecl;{$ENDIF}
begin
  PString(Result)^ := String.LowerChars;
end;

procedure _LapeString_UpperChars(const Params: PParamArray; const Result: Pointer); {$IFDEF Lape_CDECL}cdecl;{$ENDIF}
begin
  PString(Result)^ := String.UpperChars;
end;

procedure _LapeString_AlphaChars(const Params: PParamArray; const Result: Pointer); {$IFDEF Lape_CDECL}cdecl;{$ENDIF}
begin
  PString(Result)^ := String.AlphaChars;
end;

procedure _LapeString_AlphaNumChars(const Params: PParamArray; const Result: Pointer); {$IFDEF Lape_CDECL}cdecl;{$ENDIF}
begin
  PString(Result)^ := String.AlphaNumChars;
end;

procedure _LapeString_Extract(const Params: PParamArray; const Result: Pointer); {$IFDEF Lape_CDECL}cdecl;{$ENDIF}
type
  PCharArray = ^TCharArray;
begin
  PString(Result)^ := PString(Params^[0])^.Extract(PCharArray(Params^[1])^);
end;

procedure _LapeString_ExtractInteger(const Params: PParamArray; const Result: Pointer); {$IFDEF Lape_CDECL}cdecl;{$ENDIF}
begin
  PInt64(Result)^ := PString(Params^[0])^.ExtractInteger(PInt64(Params^[1])^);
end;

procedure _LapeString_ExtractFloat(const Params: PParamArray; const Result: Pointer); {$IFDEF Lape_CDECL}cdecl;{$ENDIF}
begin
  PExtended(Result)^ := PString(Params^[0])^.ExtractFloat(PInt64(Params^[1])^);
end;

procedure _LapeString_IsAlphaNum(const Params: PParamArray; const Result: Pointer); {$IFDEF Lape_CDECL}cdecl;{$ENDIF}
begin
  PBoolean(Result)^ := PString(Params^[0])^.IsAlphaNum();
end;

procedure _LapeString_IsInteger(const Params: PParamArray; const Result: Pointer); {$IFDEF Lape_CDECL}cdecl;{$ENDIF}
begin
  PBoolean(Result)^ := PString(Params^[0])^.IsInteger();
end;

procedure _LapeString_IsFloat(const Params: PParamArray; const Result: Pointer); {$IFDEF Lape_CDECL}cdecl;{$ENDIF}
begin
  PBoolean(Result)^ := PString(Params^[0])^.IsFloat();
end;

procedure _LapeString_Count(const Params: PParamArray; const Result: Pointer); {$IFDEF Lape_CDECL}cdecl;{$ENDIF}
begin
  PInteger(Result)^ := PString(Params^[0])^.Count(PString(Params^[1])^);
end;

procedure _LapeString_CountAll(const Params: PParamArray; const Result: Pointer); {$IFDEF Lape_CDECL}cdecl;{$ENDIF}
begin
  PIntegerArray(Result)^ := PString(Params^[0])^.CountAll(PStringArray(Params^[1])^);
end;

procedure _LapeString_Contains(const Params: PParamArray; const Result: Pointer); {$IFDEF Lape_CDECL}cdecl;{$ENDIF}
begin
  PBoolean(Result)^ := PString(Params^[0])^.Contains(PString(Params^[1])^, PBoolean(Params^[2])^);
end;

procedure _LapeString_ContainsAny(const Params: PParamArray; const Result: Pointer); {$IFDEF Lape_CDECL}cdecl;{$ENDIF}
begin
  PBoolean(Result)^ := PString(Params^[0])^.ContainsAny(PStringArray(Params^[1])^, PBoolean(Params^[2])^);
end;

procedure _LapeString_IndexOfAny(const Params: PParamArray; const Result: Pointer); {$IFDEF Lape_CDECL}cdecl;{$ENDIF}
begin
  PInteger(Result)^ := PString(Params^[0])^.IndexOfAny(PStringArray(Params^[1])^);
end;

procedure _LapeString_IndexOfAnyEx(const Params: PParamArray; const Result: Pointer); {$IFDEF Lape_CDECL}cdecl;{$ENDIF}
begin
  PInteger(Result)^ := PString(Params^[0])^.IndexOfAny(PStringArray(Params^[1])^, PInteger(Params^[2])^);
end;

procedure _LapeString_Format(const Params: PParamArray; const Result: Pointer); {$IFDEF Lape_CDECL}cdecl;{$ENDIF}
begin
  with VariantArrToConstArr(PVariantArray(Params^[1])^) do
    PString(Result)^ := PString(Params^[0])^.Format(VarRecs);
end;

procedure _LapeString_ToBoolean(const Params: PParamArray; const Result: Pointer); {$IFDEF Lape_CDECL}cdecl;{$ENDIF}
begin
  PBoolean(Result)^ := PString(Params^[0])^.ToBoolean();
end;

procedure _LapeString_ToBooleanDef(const Params: PParamArray; const Result: Pointer); {$IFDEF Lape_CDECL}cdecl;{$ENDIF}
begin
  PBoolean(Result)^ := PString(Params^[0])^.ToBoolean(PBoolean(Params^[1])^);
end;

procedure _LapeString_ToInteger(const Params: PParamArray; const Result: Pointer); {$IFDEF Lape_CDECL}cdecl;{$ENDIF}
begin
  PInteger(Result)^ := PString(Params^[0])^.ToInteger();
end;

procedure _LapeString_ToIntegerDef(const Params: PParamArray; const Result: Pointer); {$IFDEF Lape_CDECL}cdecl;{$ENDIF}
begin
  PInteger(Result)^ := PString(Params^[0])^.ToInteger(PInteger(Params^[1])^);
end;

procedure _LapeString_ToInt64(const Params: PParamArray; const Result: Pointer); {$IFDEF Lape_CDECL}cdecl;{$ENDIF}
begin
  PInt64(Result)^ := PString(Params^[0])^.ToInt64();
end;

procedure _LapeString_ToInt64Def(const Params: PParamArray; const Result: Pointer); {$IFDEF Lape_CDECL}cdecl;{$ENDIF}
begin
  PInt64(Result)^ := PString(Params^[0])^.ToInt64(PInt64(Params^[1])^);
end;

procedure _LapeString_ToSingle(const Params: PParamArray; const Result: Pointer); {$IFDEF Lape_CDECL}cdecl;{$ENDIF}
begin
  PSingle(Result)^ := PString(Params^[0])^.ToSingle();
end;

procedure _LapeString_ToSingleDef(const Params: PParamArray; const Result: Pointer); {$IFDEF Lape_CDECL}cdecl;{$ENDIF}
begin
  PSingle(Result)^ := PString(Params^[0])^.ToSingle(PSingle(Params^[1])^);
end;

procedure _LapeString_ToDouble(const Params: PParamArray; const Result: Pointer); {$IFDEF Lape_CDECL}cdecl;{$ENDIF}
begin
  PDouble(Result)^ := PString(Params^[0])^.ToDouble();
end;

procedure _LapeString_ToDoubleDef(const Params: PParamArray; const Result: Pointer); {$IFDEF Lape_CDECL}cdecl;{$ENDIF}
begin
  PDouble(Result)^ := PString(Params^[0])^.ToDouble(PDouble(Params^[1])^);
end;

procedure _LapeString_ToExtended(const Params: PParamArray; const Result: Pointer); {$IFDEF Lape_CDECL}cdecl;{$ENDIF}
begin
  PExtended(Result)^ := PString(Params^[0])^.ToExtended();
end;

procedure _LapeString_ToExtendedDef(const Params: PParamArray; const Result: Pointer); {$IFDEF Lape_CDECL}cdecl;{$ENDIF}
begin
  PExtended(Result)^ := PString(Params^[0])^.ToExtended(PExtended(Params^[1])^);
end;

procedure _LapeString_MUL_Integer(const Params: PParamArray; const Result: Pointer); {$IFDEF Lape_CDECL}cdecl;{$ENDIF}
begin
  PString(Result)^ := PString(Params^[0])^ * PInteger(Params^[1])^;
end;

procedure _LapeString_IN_String(const Params: PParamArray; const Result: Pointer); {$IFDEF Lape_CDECL}cdecl;{$ENDIF}
begin
  PBoolean(Result)^ := PString(Params^[0])^ in PString(Params^[1])^;
end;

procedure _LapeString_IN_StringArray(const Params: PParamArray; const Result: Pointer); {$IFDEF Lape_CDECL}cdecl;{$ENDIF}
begin
  PBoolean(Result)^ := PString(Params^[0])^ in PStringArray(Params^[1])^;
end;

procedure ImportString(Compiler: TSimbaScript_Compiler);
begin
  with Compiler do
  begin
    pushSection('String');

    addGlobalType('(Numbers, Letters, Others)', 'StrExtr');
    addGlobalFunc('function ExtractFromStr(S: String; Extract: StrExtr): String', @_LapeExtractFromStr);
    addGlobalFunc('function Between(S1, S2, S: String): String', @_LapeBetween);
    addGlobalFunc('function Implode(Glue: String; Pieces: TStringArray): String', @_LapeImplode);
    addGlobalFunc('function Explode(Delimiter, S: String): TStringArray', @_LapeExplode);
    addGlobalFunc('function ExecRegExpr(RegExpr, InputStr: String): Boolean', @_LapeExecRegExpr);
    addGlobalFunc('function SplitRegExpr(RegExpr, InputStr: String): TStringArray', @_LapeSplitRegExpr);
    addGlobalFunc('function ReplaceRegExpr(RegExpr, InputStr, ReplaceStr: String; UseSubstitution: Boolean): String', @_LapeReplaceRegExpr);
    addGlobalFunc('function PosEx(Needle, Haystack: String; Offset: Integer): Integer', @_LapePosEx);
    addGlobalFunc('function LevDistance(Source, Target: String): Integer', @_LapeLevDist);
    addGlobalFunc('function MultiBetween(S, S1, S2: String): TStringArray', @_LapeMultiBetween);
    addGlobalFunc('function IsArrInStr(Arr: TStringArray; S: String): Boolean', @_LapeIsArrInStr);
    addGlobalFunc('function IsStrInArr(S: String;  UsePos: Boolean; Arr: TStringArray): Boolean', @_LapeIsStrInArr);
    addGlobalFunc('function PosMulti(Needle, Haystack: String): TIntegerArray', @_LapePosMulti);
    addGlobalFunc('function UTF8Decode(S: AnsiString): WideString', @_LapeUTF8Decode);
    addGlobalFunc('function UTF8Encode(S: WideString): AnsiString', @_LapeUTF8Encode);

    addGlobalType(
      'record'               + LineEnding +
      '  Position: Integer;' + LineEnding +
      '  Length: Integer;'   + LineEnding +
      '  Match: String;'     + LineEnding +
      'end;',
      'TRegExprGroup'
    );
    addGlobalType('array of TRegExprGroup', 'TRegExprGroupArray');
    addGlobalType(
      'record'                          + LineEnding +
      '  Position: Integer;'            + LineEnding +
      '  Length: Integer;'              + LineEnding +
      '  Match: String;'                + LineEnding +
      ''                                + LineEnding +
      '  Groups: TRegExprGroupArray;'   + LineEnding +
      'end;',
      'TRegExprMatch'
    );
    addGlobalType('array of TRegExprMatch', 'TRegExprMatchArray');

    addGlobalFunc('function String.NumberChars: String; static;', @_LapeString_NumberChars);
    addGlobalFunc('function String.AlphaChars: String; static;', @_LapeString_AlphaChars);
    addGlobalFunc('function String.LowerChars: String; static;', @_LapeString_LowerChars);
    addGlobalFunc('function String.UpperChars: String; static;', @_LapeString_UpperChars);
    addGlobalFunc('function String.AlphaNumChars: String; static;', @_LapeString_AlphaNumChars);

    addGlobalFunc('function String.IsUpper: Boolean;', @_LapeString_IsUpper);
    addGlobalFunc('function String.IsLower: Boolean;', @_LapeString_IsLower);

    addGlobalFunc('function String.ToUpper: String;', @_LapeString_ToUpper);
    addGlobalFunc('function String.ToLower: String;', @_LapeString_ToLower);
    addGlobalFunc('function String.Capitalize: String;', @_LapeString_Capitalize);

    addGlobalFunc('function String.Before(Value: String): String;', @_LapeString_Before);
    addGlobalFunc('function String.After(Value: String): String;', @_LapeString_After);

    addGlobalFunc('function String.Between(S1, S2: String): String;', @_LapeString_Between);
    addGlobalFunc('function String.BetweenAll(S1, S2: String): TStringArray;', @_LapeString_BetweenAll);

    addGlobalFunc('function String.RegExprSplit(Pattern: String): TStringArray;', @_LapeString_RegExprSplit);
    addGlobalFunc('function String.RegExprFindAll(Pattern: String): TRegExprMatchArray;', @_LapeString_RegExprFindAll);
    addGlobalFunc('function String.RegExprFind(Pattern: String): TRegExprMatch;', @_LapeString_RegExprFind);
    addGlobalFunc('function String.RegExprExists(Pattern: String): Boolean;', @_LapeString_RegExprExists);

    addGlobalFunc('function String.IndexOfAny(Values: TStringArray): Integer; overload;', @_LapeString_IndexOfAny);
    addGlobalFunc('function String.IndexOfAny(Values: TStringArray; Offset: Integer): Integer; overload;', @_LapeString_IndexOfAnyEx);

    addGlobalFunc('function String.IndexOf(Value: String): Integer; overload;', @_LapeString_IndexOf);
    addGlobalFunc('function String.IndexOf(Value: String; Offset: Integer): Integer; overload;', @_LapeString_IndexOfEx);
    addGlobalFunc('function String.LastIndexOf(Value: String): Integer; overload;', @_LapeString_LastIndexOf);
    addGlobalFunc('function String.LastIndexOf(Value: String; Offset: Integer): Integer; overload;', @_LapeString_LastIndexOfEx);

    addGlobalFunc('function String.IndicesOf(Value: String): TIntegerArray; overload;', @_LapeString_IndicesOf);
    addGlobalFunc('function String.IndicesOf(Value: String; Offset: Integer): TIntegerArray; overload;', @_LapeString_IndicesOfEx);

    addGlobalFunc('function String.Extract(Chars: array of Char): String;', @_LapeString_Extract);
    addGlobalFunc('function String.ExtractInteger(Default: Int64 = -1): Int64;', @_LapeString_ExtractInteger);
    addGlobalFunc('function String.ExtractFloat(Default: Extended = -1): Extended;', @_LapeString_ExtractFloat);

    addGlobalFunc('function String.IsAlphaNum: Boolean;', @_LapeString_IsAlphaNum);
    addGlobalFunc('function String.IsInteger: Boolean;', @_LapeString_IsInteger);
    addGlobalFunc('function String.IsFloat: Boolean;', @_LapeString_IsFloat);

    addGlobalFunc('function String.Trim: String; overload;', @_LapeString_Trim);
    addGlobalFunc('function String.Trim(TrimChars: array of Char): String; overload;', @_LapeString_TrimEx);

    addGlobalFunc('function String.TrimLeft: String; overload;', @_LapeString_TrimLeft);
    addGlobalFunc('function String.TrimLeft(TrimChars: array of Char): String; overload;', @_LapeString_TrimLeftEx);

    addGlobalFunc('function String.TrimRight: String; overload;', @_LapeString_TrimRight);
    addGlobalFunc('function String.TrimRight(TrimChars: array of Char): String; overload;', @_LapeString_TrimRightEx);

    addGlobalFunc('function String.StartsWith(Value: String; CaseSenstive: Boolean = True): Boolean;', @_LapeString_StartsWith);
    addGlobalFunc('function String.EndsWith(Value: String; CaseSenstive: Boolean = True): Boolean;', @_LapeString_EndsWith);

    addGlobalFunc('function String.Partition(Value: String): TStringArray;', @_LapeString_Partition);
    addGlobalFunc('function String.Replace(OldValue: String; NewValue: String): String; overload;', @_LapeString_Replace);
    addGlobalFunc('function String.Replace(OldValue: String; NewValue: String; ReplaceFlags: TReplaceFlags): String; overload;', @_LapeString_ReplaceEx);

    addGlobalFunc('function String.Contains(Value: String; CaseSenstive: Boolean = True): Boolean;', @_LapeString_Contains);
    addGlobalFunc('function String.ContainsAny(Values: TStringArray; CaseSenstive: Boolean = True): Boolean;', @_LapeString_ContainsAny);

    addGlobalFunc('function String.Count(Value: String): Integer;', @_LapeString_Count);
    addGlobalFunc('function String.CountAll(Values: TStringArray): TIntegerArray;', @_LapeString_CountAll);

    addGlobalFunc('function String.Split(Seperator: String): TStringArray;', @_LapeString_Split);

    addGlobalFunc('function String.CopyRange(StartIndex, EndIndex: Integer): String;', @_LapeString_CopyRange);
    addGlobalFunc('procedure String.DeleteRange(StartIndex, EndIndex: Integer);', @_LapeString_DeleteRange);
    addGlobalFunc('procedure String.Insert(Value: String; Index: Integer);', @_LapeString_Insert);

    addGlobalFunc('procedure String.Extend(Value: String);', @_LapeString_Extend);
    addGlobalFunc('procedure String.Append(Value: Char);', @_LapeString_Append);

    addGlobalFunc('function String.Remove(Value: String): Boolean;', @_LapeString_Remove);
    addGlobalFunc('function String.RemoveAll(Value: String): Integer;', @_LapeString_RemoveAll);

    addGlobalFunc('function String.PadLeft(Count: Integer; PaddingChar: Char = #32): String', @_LapeString_PadLeft);
    addGlobalFunc('function String.PadRight(Count: Integer; PaddingChar: Char = #32): String', @_LapeString_PadRight);

    addGlobalFunc('function String.Format(Args: TVariantArray): String;', @_LapeString_Format);

    addGlobalFunc('function String.ToBoolean: Boolean; overload;', @_LapeString_ToBoolean);
    addGlobalFunc('function String.ToBoolean(Default: Boolean): Boolean; overload;', @_LapeString_ToBooleanDef);
    addGlobalFunc('function String.ToInteger: Integer; overload;', @_LapeString_ToInteger);
    addGlobalFunc('function String.ToInteger(Default: Integer): Integer; overload;', @_LapeString_ToIntegerDef);
    addGlobalFunc('function String.ToInt64: Int64; overload;', @_LapeString_ToInt64);
    addGlobalFunc('function String.ToInt64(Default: Int64): Int64; overload;', @_LapeString_ToInt64Def);
    addGlobalFunc('function String.ToSingle: Single; overload;', @_LapeString_ToSingle);
    addGlobalFunc('function String.ToSingle(Default: Single): Single; overload;', @_LapeString_ToSingleDef);
    addGlobalFunc('function String.ToDouble: Double; overload;', @_LapeString_ToDouble);
    addGlobalFunc('function String.ToDouble(Default: Double): Double; overload;', @_LapeString_ToDoubleDef);
    addGlobalFunc('function String.ToExtended: Extended; overload;', @_LapeString_ToExtended);
    addGlobalFunc('function String.ToExtended(Default: Extended): Extended; overload;', @_LapeString_ToExtendedDef);

    addGlobalFunc('operator * (Left: String; Right: Integer): String', @_LapeString_MUL_Integer);
    addGlobalFunc('operator in(Left: String; Right: String): Boolean', @_LapeString_IN_String);
    addGlobalFunc('operator in(Left: String; Right: TStringArray): Boolean', @_LapeString_IN_StringArray);

    popSection();
  end;
end;

initialization
  TSimbaScript_Compiler.RegisterImport(@ImportString);

end.
