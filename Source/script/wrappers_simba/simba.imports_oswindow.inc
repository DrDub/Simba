FSection := 'TWindowHandle';

addGlobalType('type PtrUInt', 'TWindowHandle');
addGlobalType('array of TWindowHandle', 'TWindowHandleArray');

addGlobalFunc('function TWindowHandle.Activate: Boolean; constref', @_LapeWindowHandle_Activate);
addGlobalFunc('function TWindowHandle.IsVaild: Boolean; constref', @_LapeWindowHandle_IsVaild);
addGlobalFunc('function TWindowHandle.IsActive: Boolean; constref', @_LapeWindowHandle_IsActive);
addGlobalFunc('function TWindowHandle.IsVisible: Boolean; constref', @_LapeWindowHandle_IsVisible);
addGlobalFunc('function TWindowHandle.GetPID: UInt32; constref', @_LapeWindowHandle_GetPID);
addGlobalFunc('function TWindowHandle.GetRootWindow: TWindowHandle; constref; ', @_LapeWindowHandle_GetRootWindow);
addGlobalFunc('function TWindowHandle.GetClassName: String; constref', @_LapeWindowHandle_GetClassName);
addGlobalFunc('function TWindowHandle.GetTitle: String; constref', @_LapeWindowHandle_GetTitle);
addGlobalFunc('function TWindowHandle.GetClassNameW: WideString; constref', @_LapeWindowHandle_GetClassNameW);
addGlobalFunc('function TWindowHandle.GetTitleW: WideString; constref', @_LapeWindowHandle_GetTitleW);
addGlobalFunc('function TWindowHandle.GetBounds: TBox; constref', @_LapeWindowHandle_GetBounds);
addGlobalFunc('function TWindowHandle.GetChildren(Recursive: Boolean = True): TWindowHandleArray; constref', @_LapeWindowHandle_GetChildren);
addGlobalFunc('procedure TWindowHandle.SetBounds(Bounds: TBox); constref', @_LapeWindowHandle_SetBounds);
addGlobalFunc('procedure TWindowHandle.Kill; constref', @_LapeWindowHandle_Kill);
addGlobalFunc('function GetTopWindows: TWindowHandleArray', @_LapeGetTopWindows);
addGlobalFunc('function GetVisibleWindows: TWindowHandleArray', @_LapeGetVisibleWindows);
addGlobalFunc('function GetWindows: TWindowHandleArray', @_LapeGetWindows);
addGlobalFunc('function GetActiveWindow: TWindowHandle', @_LapeGetActiveWindow);
addGlobalFunc('function GetDesktopWindow: TWindowHandle', @_LapeGetDesktopWindow);
addGlobalFunc('function GetWindowAtCursor: TWindowHandle', @_LapeGetWindowAtCursor);
addGlobalFunc('function FindWindow(Title: String; out Window: TWindowHandle): Boolean; overload', @_LapeFindWindow);
addGlobalFunc('function FindWindows(Title: String): TWindowHandleArray; overload', @_LapeFindWindows);
addGlobalFunc('function FindChildWindow(Title: String; ClassName: String; out Child: TWindowHandle): Boolean; overload', @_LapeFindChildWindow);
addGlobalFunc('function FindChildWindows(Title: String; ClassName: String): TWindowHandleArray; overload', @_LapeFindChildWindows);
