addClass('TTarget');
addGlobalType('record Ptr: PRGB32; IncPtrWith: integer; RowLen: integer; end', 'TRetData');
addGlobalType('UInt32', 'TClickType');
addGlobalFunc('procedure TTarget.GetTargetDimensions(out w, h: integer); constref', @_LapeTarget_GetTargetDimensions);
addGlobalFunc('procedure TTarget.GetTargetPosition(out left, top: integer); constref', @_LapeTarget_GetTargetPosition);
addGlobalFunc('function TTarget.GetColor(x,y : integer): TColor; constref', @_LapeTarget_GetColor);
addGlobalFunc('function TTarget.CopyData(X, Y, Width, Height: Integer): PRGB32; constref', @_LapeTarget_CopyData);
addGlobalFunc('function TTarget.ReturnData(xs, ys, width, height: Integer): TRetData; constref', @_LapeTarget_ReturnData);
addGlobalFunc('procedure TTarget.FreeReturnData; constref', @_LapeTarget_FreeReturnData);
addGlobalFunc('procedure TTarget.ActivateClient; constref', @_LapeTarget_ActivateClient);
addGlobalFunc('function TTarget.TargetValid: boolean; constref', @_LapeTarget_TargetValid);
addGlobalFunc('function TTarget.MouseSetClientArea(x1, y1, x2, y2: integer): boolean; constref', @_LapeTarget_MouseSetClientArea);
addGlobalFunc('procedure TTarget.MouseResetClientArea; constref', @_LapeTarget_MouseResetClientArea);
addGlobalFunc('function TTarget.ImageSetClientArea(x1, y1, x2, y2: integer): boolean; constref', @_LapeTarget_ImageSetClientArea);
addGlobalFunc('procedure TTarget.ImageResetClientArea; constref', @_LapeTarget_ImageResetClientArea);
addGlobalFunc('procedure TTarget.GetMousePosition(out x,y: integer); constref', @_LapeTarget_GetMousePosition);
addGlobalFunc('procedure TTarget.MoveMouse(x,y: integer); constref', @_LapeTarget_MoveMouse);
addGlobalFunc('procedure TTarget.ScrollMouse(x,y : integer; Lines : integer); constref', @_LapeTarget_ScrollMouse);
addGlobalFunc('procedure TTarget.HoldMouse(x,y: integer; button: TClickType); constref', @_LapeTarget_HoldMouse);
addGlobalFunc('procedure TTarget.ReleaseMouse(x,y: integer; button: TClickType); constref', @_LapeTarget_ReleaseMouse);
addGlobalFunc('function TTarget.IsMouseButtonHeld(button : TClickType): boolean; constref', @_LapeTarget_IsMouseButtonHeld);
addGlobalFunc('procedure TTarget.SendString(str: string; keywait, keymodwait: integer); constref', @_LapeTarget_SendString);
addGlobalFunc('procedure TTarget.HoldKey(key: integer); constref', @_LapeTarget_HoldKey);
addGlobalFunc('procedure TTarget.ReleaseKey(key: integer); constref', @_LapeTarget_ReleaseKey);
addGlobalFunc('function TTarget.IsKeyHeld(key: integer): boolean; constref', @_LapeTarget_IsKeyHeld);
addGlobalFunc('function TTarget.GetKeyCode(C : char): integer; constref', @_LapeTarget_GetKeyCode);
addGlobalFunc('function TTarget.GetHandle: PtrUInt; constref', @_LapeTarget_GetHandle);
addGlobalFunc('procedure TTarget.SetHandle(Value: PtrUInt); constref', @_LapeTarget_SetHandle);
addGlobalFunc('procedure TTarget.AddHandlerInvalidTarget(Handler: TNotifyEvent); constref', @_LapeTarget_AddHandlerInvalidTarget);
addGlobalFunc('procedure TTarget.RemoveHandlerInvalidTarget(Handler: TNotifyEvent); constref', @_LapeTarget_RemoveHandlerInvalidTarget);
addGlobalFunc('procedure TTarget.SetAutoFocus(Value: Boolean); constref', @_LapeTarget_SetAutoFocus);
addGlobalFunc('function TTarget.GetAutoFocus: Boolean; constref', @_LapeTarget_GetAutoFocus);
addGlobalFunc('procedure TTarget.Init()', @_LapeTarget_Init);
// addGlobalFunc('procedure TTarget.Free; constref', @_LapeTarget_Free);
