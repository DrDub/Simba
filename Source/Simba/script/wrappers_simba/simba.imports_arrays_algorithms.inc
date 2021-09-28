FSection := 'Arrays & Algorithms';
addGlobalFunc('procedure RAaSTPAEx(var a: TPointArray; const w, h: Int32)', @_LapeRAaSTPAEx);
addGlobalFunc('procedure RAaSTPA(var a: TPointArray; const Dist: Int32)', @_LapeRAaSTPA);
addGlobalFunc('function NearbyPointInArrayEx(const P: TPoint; w, h: Int32; const a: TPointArray): Boolean', @_LapeNearbyPointInArrayEx);
addGlobalFunc('function NearbyPointInArray(const P: TPoint; Dist: Int32; const a: TPointArray): Boolean', @_LapeNearbyPointInArray);
addGlobalFunc('procedure QuickTPASort(var A: TIntegerArray; var B: TPointArray; iLo, iHi: Int32; SortUp: Boolean)', @_LapeQuickTPASort);
addGlobalFunc('procedure QuickATPASort(var A: TIntegerArray; var B: T2DPointArray; iLo, iHi: Int32; SortUp: Boolean)', @_LapeQuickATPASort);
addGlobalFunc('procedure SortTPAByX(var a: TPointArray; const LowToHi: Boolean)', @_LapeSortTPAByX);
addGlobalFunc('procedure SortTPAByY(var a: TPointArray; const LowToHi: Boolean)', @_LapeSortTPAByY);
addGlobalFunc('function FindTPARows(a: TPointArray): T2DPointArray', @_LapeFindTPARows);
addGlobalFunc('function FindTPAColumns(a: TPointArray): T2DPointArray', @_LapeFindTPAColumns);
addGlobalFunc('procedure SortTPAFrom(var a: TPointArray; const From: TPoint)', @_LapeSortTPAFrom);
addGlobalFunc('procedure SortATPAFrom(var a: T2DPointArray; const From: TPoint)', @_LapeSortATPAFrom);
addGlobalFunc('procedure SortATPAFromFirstPoint(var a: T2DPointArray; const From: TPoint)', @_LapeSortATPAFromFirstPoint);
addGlobalFunc('procedure SortATPAFromMidPoint(var a: T2DPointArray; const From: TPoint)', @_LapeSortATPAFromMidPoint);
addGlobalFunc('procedure SortATPAFromFirstPointX(var a: T2DPointArray; const From: TPoint)', @_LapeSortATPAFromFirstPointX);
addGlobalFunc('procedure SortATPAFromFirstPointY(var a: T2DPointArray; const From: TPoint)', @_LapeSortATPAFromFirstPointY);
addGlobalFunc('procedure InvertTPA(var a: TPointArray)', @_LapeInvertTPA);
addGlobalFunc('procedure InvertATPA(var a: T2DPointArray)', @_LapeInvertATPA);
addGlobalFunc('function MiddleTPAEx(const TPA: TPointArray; var x, y: Int32): Boolean', @_LapeMiddleTPAEx);
addGlobalFunc('function MiddleTPA(const TPA: TPointArray): TPoint', @_LapeMiddleTPA);
addGlobalFunc('procedure MedianTPAEx(constref TPA: TPointArray; out x, y: Int32)', @_LapeMedianTPAEx);
addGlobalFunc('function MedianTPA(constref TPA: TPointArray): TPoint', @_LapeMedianTPA);
addGlobalFunc('procedure SortATPASize(var a: T2DPointArray; const BigFirst: Boolean)', @_LapeSortATPASize);
addGlobalFunc('procedure SortATPAFromSize(var a: T2DPointArray; const Size: Int32; CloseFirst: Boolean)', @_LapeSortATPAFromSize);
addGlobalFunc('procedure FilterTPAsBetween(var atpa: T2DPointArray; const minLength, maxLength: Int32)', @_LapeFilterTPAsBetween);
addGlobalFunc('function SplitTPAEx(const arr: TPointArray; w, h: Int32): T2DPointArray', @_LapeSplitTPAEx);
addGlobalFunc('function SplitTPA(const arr: TPointArray; Dist: Int32): T2DPointArray', @_LapeSplitTPA);
addGlobalFunc('function ClusterTPAEx(const TPA: TPointArray; width, height: Int32): T2DPointArray', @_LapeClusterTPAEx);
addGlobalFunc('function ClusterTPA(const TPA: TPointArray; dist: Int32): T2DPointArray', @_LapeClusterTPA);
addGlobalFunc('procedure FilterPointsPie(var Points: TPointArray; const SD, ED, MinR, MaxR: Extended; Mx, My: Int32)', @_LapeFilterPointsPie);
addGlobalFunc('procedure FilterPointsDist(var Points: TPointArray; const MinDist, MaxDist: Extended; Mx, My: Int32)', @_LapeFilterPointsDist);
addGlobalFunc('procedure FilterPointsLine(var Points: TPointArray; Radial: Extended; Radius, MX, MY: Int32)', @_LapeFilterPointsLine);
addGlobalFunc('procedure FilterPointsBox(var points: TPointArray; x1, y1, x2, y2: Int32)', @_LapeFilterPointsBox);
addGlobalFunc('procedure FilterTPADist(var TPA: TPointArray; maxDist: Int32)', @_LapeFilterTPADist);
addGlobalFunc('function GetATPABounds(const ATPA: T2DPointArray): TBox', @_LapeGetATPABounds);
addGlobalFunc('function GetTPABounds(const TPA: TPointArray): TBox', @_LapeGetTPABounds);
addGlobalFunc('function FindTPAinTPA(const SearchTPA, TotalTPA: TPointArray; var Matches: TPointArray): Boolean', @_LapeFindTPAinTPA);
addGlobalFunc('function GetSamePointsATPA(const ATPA: T2DPointArray; var Matches: TPointArray): Boolean', @_LapeGetSamePointsATPA);
addGlobalFunc('procedure SortCircleWise(var TPA: TPointArray; const cx, cy, StartDegree: Int32; SortUp, ClockWise: Boolean)', @_LapeSortCircleWise);
addGlobalFunc('procedure LinearSort(var TPA: TPointArray; cx, cy, sd: Int32; SortUp: Boolean)', @_LapeLinearSort);
addGlobalFunc('function RotatePoint(Const p: TPoint; angle, mx, my: Extended): TPoint', @_LapeRotatePoint);
addGlobalFunc('function ChangeDistPT(const PT: TPoint; mx,my: Int32; newdist: extended): TPoint', @_LapeChangeDistPT);
addGlobalFunc('function ChangeDistTPA(var TPA: TPointArray; mx,my: Int32; newdist: extended): boolean', @_LapeChangeDistTPA);
addGlobalFunc('function FindGapsTPA(const TPA: TPointArray; MinPixels: Int32): T2DPointArray', @_LapeFindGapsTPA);
addGlobalFunc('function RemoveDistTPointArray(x, y, dist: Int32; const ThePoints: TPointArray; RemoveHigher: Boolean): TPointArray', @_LapeRemoveDistTPointArray);
addGlobalFunc('function ReArrangeandShortenArrayEx(const a: TPointArray; w, h: Int32): TPointArray', @_LapeReArrangeandShortenArrayEx);
addGlobalFunc('function ReArrangeandShortenArray(const a: TPointArray; Dist: Int32): TPointArray', @_LapeReArrangeandShortenArray);
addGlobalFunc('function TPAtoATPAEx(const TPA: TPointArray; w, h: Int32): T2DPointArray', @_LapeTPAtoATPAEx);
addGlobalFunc('function TPAtoATPA(const TPA: TPointArray; Dist: Int32): T2DPointArray', @_LapeTPAtoATPA);
addGlobalFunc('function MergeATPA(const ATPA: T2DPointArray): TPointArray', @_LapeMergeATPA);
addGlobalFunc('function TPAFromLine(const x1, y1, x2, y2: Int32): TPointArray', @_LapeTPAFromLine);
addGlobalFunc('function EdgeFromBox(const Box: TBox): TPointArray', @_LapeEdgeFromBox);
addGlobalFunc('function TPAFromBox(const Box: TBox): TPointArray', @_LapeTPAFromBox);
addGlobalFunc('function TPAFromEllipse(const CX, CY, XRadius, YRadius : Int32) : TPointArray', @_LapeTPAFromEllipse);
addGlobalFunc('function TPAFromCircle(const CX, CY, Radius : Int32) : TPointArray', @_LapeTPAFromCircle);
addGlobalFunc('function TPAFromPolygon(const Shape: TPointArray) : TPointArray', @_LapeTPAFromPolygon);
addGlobalFunc('procedure FillEllipse(var a: TPointArray)', @_LapeFillEllipse);
addGlobalFunc('function RotatePoints(const P: TPointArray; A, cx, cy: Extended): TPointArray', @_LapeRotatePoints);
addGlobalFunc('function FindTPAEdges(const p: TPointArray): TPointArray', @_LapeFindTPAEdges);
addGlobalFunc('function ClearTPAFromTPA(const Points, PointsToClear: TPointArray): TPointArray', @_LapeClearTPAFromTPA);
addGlobalFunc('function ReturnPointsNotInTPA(const TotalTPA: TPointArray; const Box: TBox): TPointArray', @_LapeReturnPointsNotInTPA);
addGlobalFunc('function PointInTPA(p: TPoint; const arP: TPointArray): Boolean', @_LapePointInTPA);
addGlobalFunc('procedure ClearDoubleTPA(var TPA: TPointArray)', @_LapeClearDoubleTPA);
addGlobalFunc('procedure TPACountSort(var TPA: TPointArray; const max: TPoint; Const SortOnX: Boolean)', @_LapeTPACountSort);
addGlobalFunc('procedure TPACountSortBase(var TPA: TPointArray; const maxx, base: TPoint; const SortOnX: Boolean)', @_LapeTPACountSortBase);
addGlobalFunc('function SameTPA(const aTPA, bTPA: TPointArray): Boolean', @_LapeSameTPA);
addGlobalFunc('function TPAInATPA(const TPA: TPointArray; const InATPA: T2DPointArray; var Index: LongInt): Boolean', @_LapeTPAInATPA);
addGlobalFunc('procedure OffsetTPA(var TPA: TPointArray; const Offset: TPoint)', @_LapeOffsetTPA);
addGlobalFunc('procedure OffsetATPA(var ATPA: T2DPointArray; const Offset: TPoint)', @_LapeOffsetATPA);
addGlobalFunc('function PartitionTPA(const TPA: TPointArray; BoxWidth, BoxHeight: Int32): T2DPointArray', @_LapePartitionTPA);
addGlobalFunc('procedure Quicksort(var Arr: TIntegerArray)', @_LapeQuicksort);
addGlobalFunc('function InIntArrayEx(const Arr: TIntegerArray; var Index: Int32; const Number: Int32): Boolean', @_LapeInIntArrayEx);
addGlobalFunc('function InIntArray(const Arr: TIntegerArray; Number: Int32): Boolean', @_LapeInIntArray);
addGlobalFunc('procedure ClearSameIntegers(var Arr: TIntegerArray)', @_LapeClearSameIntegers);
addGlobalFunc('procedure InvertTIA(var Arr: TIntegerArray)', @_LapeInvertTIA);
addGlobalFunc('function AverageTIA(const Arr: TIntegerArray): Int32', @_LapeAverageTIA);
addGlobalFunc('function AverageExtended(const Arr: TExtendedArray): Extended', @_LapeAverageExtended);
addGlobalFunc('function TPAErode(constref TPA: TPointArray; Amount: Int32): TPointArray', @_LapeTPAErode);
addGlobalFunc('function TPAGrow(constref TPA: TPointArray; Amount: Int32): TPointArray', @_LapeTPAGrow);
addGlobalFunc('function PointsInRangeOf(constref Points, Other: TPointArray; MinDist, MaxDist: Double): TPointArray; overload', @_LapePointsInRangeOf);
addGlobalFunc('function PointsInRangeOf(constref Points, Other: TPointArray; MinDistX, MinDistY, MaxDistX, MaxDistY: Double): TPointArray; overload', @_LapePointsInRangeOfEx);
