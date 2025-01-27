        ��  ��                  �  4   ��
 A R R A Y . S I M B A       	        var
  Arr: array of Integer;
  Index, Value: Integer;
begin
  Arr.SetLength(3);
  Arr[0] := 200;
  Arr[1] := 400;
  Arr[2] := 600;
  
  WriteLn('Index of 400 is ', Arr.IndexOf(400));

  Arr := [5,6,7,8];
  Arr.Append(100);

  WriteLn('For loop:');
  for Index := 0 to Arr.Length() - 1 do
    WriteLn('Arr[', Index, '] is ', Arr[Index]);

  WriteLn('For in loop')
  for Value in Arr.Reversed() do
    WriteLn(Value);
end.
   8   ��
 B I T M A P . S I M B A         	        var
  Bitmap: TMufasaBitmap;
begin
  Bitmap := TMufasaBitmap.Create(500, 500); // Bitmaps must explictly created
  Bitmap.DrawBox([100,100,400,400], $0000FF);
  Bitmap.DrawLine([50, 50], [450, 50], 5, $00FFFF);
  Bitmap.SetPixel(250, 250, $FFFFFF);
  Bitmap.SetFontSize(25);
  Bitmap.SetFontAntialiasing(False);
  Bitmap.DrawText('Hello world', [125, 125], $00FF00);

  WriteLn('Color at 250,250 is ', '$' + IntToHex(Bitmap.GetPixel(250, 250)));

  Bitmap.Show();
  Bitmap.Free(); // Bitmaps must be freed
end.   �  <   ��
 F U N C T I O N . S I M B A         	        program FunctionExample;

function GetNumber: Integer;
begin
  Result := 10; 
end;

function GetText: String;
begin
  Result := 'Hello World'; 
end;

function MultiplyNumber(Number: Integer; MultiplyBy: Integer): Integer;
begin
  Result := Number * MultiplyBy;
end;

begin
  WriteLn(GetNumber());
  WriteLn(GetText());

  Writeln('10x10 = ', MultiplyNumber(10, 10));
end;     4   ��
 L O O P . S I M B A         	        program LoopsExample;

procedure ForLoop;
var
  Counter: Integer;
begin
  WriteLn('ForLoop:');
  for Counter := 0 to 4 do
    WriteLn(Counter);
  WriteLn('ForLoop finished');
end;

procedure ForLoop_Break;
var
  Counter: Integer;
begin
  WriteLn('ForLoop_Break:');
  for Counter := 0 to 4 do
    if (Counter = 3) then // Exit the loop if counter is 3
      Break;
  WriteLn('ForLoop_Break finished: ', Counter);
end;

procedure ForLoop_Continue;
var
  Counter: Integer;
begin
  WriteLn('ForLoop_Continue:');
  for Counter := 0 to 4 do
  begin
    if (Counter = 2) or (Counter = 3) or (Counter = 4) then // Skip the loop if Counter is 2,3,4
      Continue;

    WriteLn(Counter);
  end;
  WriteLn('ForLoop_Continue finished');
end;

begin
  WriteLn('-------------------------------');
  ForLoop();
  WriteLn('-------------------------------');
  ForLoop_Break();
  WriteLn('-------------------------------');
  ForLoop_Continue();
  WriteLn('-------------------------------');
end.  `  <   ��
 P R O C E D U R E . S I M B A       	        program ProcedureExample;

procedure HelloWorld;
begin
  WriteLn('Hello world!'); 
end;

procedure MultiplyNumber(var Number: Integer; MultiplyBy: Integer);
begin
  Number := Number * MultiplyBy;
end;

var
  Number: Integer;
begin
  HelloWorld(); 
  
  Number := 10;
  MultiplyNumber(Number, 10);
  WriteLn('10x10 = ', Number);
end.�  8   ��
 T I M I N G . S I M B A         	        program TimingExample;

procedure SomethingToTime;
var
  Counter: Integer;
begin
  while (Counter < 100) do
  begin
    Sleep(Random(30));
    Inc(Counter);
  end;
end;

var
  Timer: TSimbaTimer;
  Milliseconds: Integer;
  Formatted: String;
begin
  Timer.Start();
  SomethingToTime();
  Timer.Stop();

  Milliseconds := Timer.Elapsed();
  Formatted := Timer.ElapsedFmt('s');

  WriteLn('Milliseconds: ', Milliseconds);
  WriteLN('Seconds: ', Formatted);
end. 