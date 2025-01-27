{
  Author: Raymond van Venetië and Merlijn Wajer
  Project: Simba (https://github.com/MerlijnWajer/Simba)
  License: GNU General Public License (https://www.gnu.org/licenses/gpl-3.0)
}
unit simba.notesform;

{$i simba.inc}

interface

uses
  classes, sysutils, forms, controls, graphics, dialogs, stdctrls;

type
  TSimbaNotesForm = class(TForm)
    Memo: TMemo;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  end;

var
  SimbaNotesForm: TSimbaNotesForm;

implementation

{$R *.lfm}

uses
  simba.settings;

procedure TSimbaNotesForm.FormDestroy(Sender: TObject);
begin
  SimbaSettings.General.Notes.Value := Memo.Lines.Text;
end;

procedure TSimbaNotesForm.FormCreate(Sender: TObject);
begin
  Memo.Lines.Text := SimbaSettings.General.Notes.Value;
end;

end.

