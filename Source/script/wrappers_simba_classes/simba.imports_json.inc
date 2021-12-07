addClass('TZAbstractObject','TObject');
addClass('TJSONObject','TZAbstractObject');
addClass('TJSONArray','TZAbstractObject');
addGlobalFunc('procedure TJSONArray.Init(); overload', @_LapeJSONArray_create);
addGlobalFunc('procedure TJSONArray.Init(s : string); overload', @_LapeJSONArray_createExExEx);
addGlobalFunc('function TJSONArray.get(index : integer): Pointer; constref', @_LapeJSONArray_get);
addGlobalFunc('function TJSONArray.getBoolean(index : integer): boolean; constref', @_LapeJSONArray_getBoolean);
addGlobalFunc('function TJSONArray.getDouble(index : integer): double; constref', @_LapeJSONArray_getDouble);
addGlobalFunc('function TJSONArray.getInt(index : integer): integer; constref', @_LapeJSONArray_getInt);
addGlobalFunc('function TJSONArray.getJSONArray(index : integer): TJSONArray; constref', @_LapeJSONArray_getJSONArray);
addGlobalFunc('function TJSONArray.getJSONObject(index : integer): TJsonObject; constref', @_LapeJSONArray_getJSONObject);
addGlobalFunc('function TJSONArray.getString(index : integer): string; constref', @_LapeJSONArray_getString);
addGlobalFunc('function TJSONArray.isNull(index : integer): boolean; constref', @_LapeJSONArray_isNull);
addGlobalFunc('function TJSONArray.join(separator : string): string; constref', @_LapeJSONArray_join);
addGlobalFunc('function TJSONArray.length: integer; constref', @_LapeJSONArray_length);
addGlobalFunc('function TJSONArray.opt(index : integer): Pointer; constref', @_LapeJSONArray_opt);
addGlobalFunc('function TJSONArray.optBoolean(index : integer): boolean; constref', @_LapeJSONArray_optBoolean);
addGlobalFunc('function TJSONArray.optBoolean(index : integer; defaultValue : boolean): boolean; constref; overload', @_LapeJSONArray_optBooleanEx);
addGlobalFunc('function TJSONArray.optDouble(index : integer): double; constref', @_LapeJSONArray_optDouble);
addGlobalFunc('function TJSONArray.optDouble(index : integer; defaultValue :double ): double; constref; overload', @_LapeJSONArray_optDoubleEx);
addGlobalFunc('function TJSONArray.optInt(index : integer): integer; constref', @_LapeJSONArray_optInt);
addGlobalFunc('function TJSONArray.optInt(index : integer; defaultValue : integer): integer; constref; overload', @_LapeJSONArray_optIntEx);
addGlobalFunc('function TJSONArray.optJSONArray(index : integer): TJSONArray; constref', @_LapeJSONArray_optJSONArray);
addGlobalFunc('function TJSONArray.optJSONObject(index : integer): TJSONObject; constref', @_LapeJSONArray_optJSONObject);
addGlobalFunc('function TJSONArray.optString(index : integer): string; constref', @_LapeJSONArray_optString);
addGlobalFunc('function TJSONArray.optString(index : integer; defaultValue : string): string; constref; overload', @_LapeJSONArray_optStringEx);
addGlobalFunc('function TJSONArray.put(value : boolean): TJSONArray; constref; overload', @_LapeJSONArray_put);
addGlobalFunc('function TJSONArray.put(value : double ): TJSONArray; constref; overload', @_LapeJSONArray_putEx);
addGlobalFunc('function TJSONArray.put(value : integer): TJSONArray; constref; overload', @_LapeJSONArray_putExEx);
addGlobalFunc('function TJSONArray.put(value : pointer): TJSONArray; constref; overload', @_LapeJSONArray_putExExEx);
addGlobalFunc('function TJSONArray.put(value: string): TJSONArray; constref; overload', @_LapeJSONArray_putExExExEx);
addGlobalFunc('function TJSONArray.put(index : integer ; value : boolean): TJSONArray; constref; overload', @_LapeJSONArray_putExExExExEx);
addGlobalFunc('function TJSONArray.put(index : integer ; value : double): TJSONArray; constref; overload', @_LapeJSONArray_putExExExExExEx);
addGlobalFunc('function TJSONArray.put(index : integer ; value : integer): TJSONArray; constref; overload', @_LapeJSONArray_putExExExExExExEx);
addGlobalFunc('function TJSONArray.put(index : integer ; value : pointer): TJSONArray; constref; overload', @_LapeJSONArray_putExExExExExExExEx);
addGlobalFunc('function TJSONArray.put(index: integer; value: string): TJSONArray; constref; overload', @_LapeJSONArray_putExExExExExExExExEx);
addGlobalFunc('function TJSONArray.toJSONObject(names  :TJSONArray ): TJsonObject ; constref; overload', @_LapeJSONArray_toJSONObject);
addGlobalFunc('function TJSONArray.toString: string; constref; overload; override', @_LapeJSONArray_toString);
addGlobalFunc('function TJSONArray.toString(indentFactor : integer): string; constref; overload', @_LapeJSONArray_toStringEx);
addGlobalFunc('function TJSONArray.toString(indentFactor, indent : integer): string; constref; overload', @_LapeJSONArray_toStringExEx);
//addGlobalFunc('procedure TJSONArray.Free; constref', @_LapeJSONArray_Free);

addGlobalFunc('procedure TJSONObject.Init(); overload', @_LapeJSONObject_create);
addGlobalFunc('procedure TJSONObject.Init(s : string); overload', @_LapeJSONObject_createExExExEx);
addGlobalFunc('procedure TJSONObject.clean; constref', @_LapeJSONObject_clean);
//    addGlobalFunc('function TJSONObject.clone: pointer; constref; override', @_LapeJSONObject_clone);
addGlobalFunc('function TJSONObject.accumulate(key : string; value : pointer): TJSONObject; constref', @_LapeJSONObject_accumulate);
addGlobalFunc('function TJSONObject.get(key : string): pointer; constref', @_LapeJSONObject_get);
addGlobalFunc('function TJSONObject.getBoolean(key : string): boolean; constref', @_LapeJSONObject_getBoolean);
addGlobalFunc('function TJSONObject.getDouble(key : string): double; constref', @_LapeJSONObject_getDouble);
addGlobalFunc('function TJSONObject.getInt(key : string): integer; constref', @_LapeJSONObject_getInt);
addGlobalFunc('function TJSONObject.getJSONArray(key : string): TJSONArray; constref', @_LapeJSONObject_getJSONArray);
addGlobalFunc('function TJSONObject.getJSONObject(key : string): TJSONObject; constref', @_LapeJSONObject_getJSONObject);
addGlobalFunc('function TJSONObject.getString(key : string): string; constref', @_LapeJSONObject_getString);
addGlobalFunc('function TJSONObject.has(key : string): boolean; constref', @_LapeJSONObject_has);
addGlobalFunc('function TJSONObject.isNull(key : string): boolean; constref', @_LapeJSONObject_isNull);
addGlobalFunc('function TJSONObject.keys: TStringList; constref', @_LapeJSONObject_keys);
addGlobalFunc('function TJSONObject.length: integer; constref', @_LapeJSONObject_length);
addGlobalFunc('function TJSONObject.names: TJSONArray; constref', @_LapeJSONObject_names);
addGlobalFunc('function TJSONObject.opt(key : string): pointer; constref', @_LapeJSONObject_opt);
addGlobalFunc('function TJSONObject.optBoolean(key : string): boolean; constref', @_LapeJSONObject_optBoolean);
addGlobalFunc('function TJSONObject.optBoolean(key : string; defaultValue : boolean): boolean; constref; overload', @_LapeJSONObject_optBooleanEx);
addGlobalFunc('function TJSONObject.optDouble(key : string): double; constref', @_LapeJSONObject_optDouble);
addGlobalFunc('function TJSONObject.optDouble(key : string; defaultValue : double): double; constref; overload', @_LapeJSONObject_optDoubleEx);
addGlobalFunc('function TJSONObject.optInt(key : string): integer; constref', @_LapeJSONObject_optInt);
addGlobalFunc('function TJSONObject.optInt(key : string; defaultValue : integer): integer; constref; overload', @_LapeJSONObject_optIntEx);
addGlobalFunc('function TJSONObject.optString(key : string): string; constref', @_LapeJSONObject_optString);
addGlobalFunc('function TJSONObject.optString(key : string; defaultValue : string): string; constref; overload', @_LapeJSONObject_optStringEx);
addGlobalFunc('function TJSONObject.optJSONArray(key : string): TJSONArray; constref', @_LapeJSONObject_optJSONArray);
addGlobalFunc('function TJSONObject.optJSONObject(key : string): TJSONObject; constref', @_LapeJSONObject_optJSONObject);
addGlobalFunc('function TJSONObject.put(key : string; value : boolean): TJSONObject; constref', @_LapeJSONObject_put);
addGlobalFunc('function TJSONObject.put(key : string; value : double): TJSONObject; constref; overload', @_LapeJSONObject_putEx);
addGlobalFunc('function TJSONObject.put(key : string; value : integer): TJSONObject; constref; overload', @_LapeJSONObject_putExEx);
addGlobalFunc('function TJSONObject.put(key : string; value : string): TJSONObject; constref; overload', @_LapeJSONObject_putExExEx);
addGlobalFunc('function TJSONObject.put(key : string; value : pointer): TJSONObject; constref; overload', @_LapeJSONObject_putExExExEx);
addGlobalFunc('function TJSONObject.putOpt(key : string; value : pointer): TJSONObject; constref', @_LapeJSONObject_putOpt);
addGlobalFunc('function TJSONObject.remove(key : string): pointer; constref', @_LapeJSONObject_remove);
addGlobalFunc('procedure TJSONObject.assignTo(json: TJSONObject); constref', @_LapeJSONObject_assignTo);
addGlobalFunc('function TJSONObject.toJSONArray(names : TJSONArray): TJSONArray; constref', @_LapeJSONObject_toJSONArray);
addGlobalFunc('function TJSONObject.toString: string ; constref; overload; override', @_LapeJSONObject_toString);
addGlobalFunc('function TJSONObject.toString(indentFactor : integer): string; constref; overload', @_LapeJSONObject_toStringEx);
addGlobalFunc('function TJSONObject.toString(indentFactor, indent : integer): string; constref; overload', @_LapeJSONObject_toStringExEx);
//addGlobalFunc('procedure TJSONObject.Free; constref', @_LapeJSONObject_Free);
