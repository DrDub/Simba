{
  Author: Raymond van Venetië and Merlijn Wajer
  Project: Simba (https://github.com/MerlijnWajer/Simba)
  License: GNU General Public License (https://www.gnu.org/licenses/gpl-3.0)
}
unit simba.client;

{$i simba.inc}

interface

uses
  Classes, SysUtils, simba.mufasatypes,
  simba.iomanager, simba.files, simba.finder, simba.bitmap, simba.dtm, simba.ocr, simba.internet;

(*

Client Class
============

The ``TClient`` class is the class that glues all other MML classes together
into one usable class. Internally, quite some MML classes require other MML
classes, and they access these other classes through their "parent"
``TClient``
class.

An image tells more than a thousands words:

    .. image:: ../../Pics/Client_Classes.png


    And the class dependency graph: (An arrow indicates a dependency)

    .. image:: ../../Pics/client_classes_dependencies.png

    The client class does not do much else except creating the classes when it
    is
    created and destroying the classes when it is being destroyed. 

*)

type
  PClient = ^TClient;
  TClient = class(TObject)
  private
    FOwnIOManager: Boolean;
  public
    IOManager: TIOManager;
    MFiles: TMFiles;
    MFinder: TMFinder;
    MBitmaps: TMBitmaps;
    MDTMs: TMDTMS;
    MOCR: TMOCR;
    MInternets: TMInternet;
    MSockets: TMSocks;

    constructor Create(const plugin_dir: string = ''; const UseIOManager: TIOManager = nil);
    destructor Destroy; override;
  end;

(*
  Properties:

      - IOManager
      - MFiles
      - MFinder
      - MBitmaps
      - MDTMs
      - MOCR
      - WriteLnProc
*)

implementation

(*

TClient.Create
~~~~~~~~~~~~~~

.. code-block:: pascal

  constructor TClient.Create(const plugin_dir: string = ''; const UseIOManager : TIOManager = nil);

*)

// Possibly pass arguments to a default window.
constructor TClient.Create(const plugin_dir: string = ''; const UseIOManager : TIOManager = nil);
begin
  inherited Create;

  if UseIOManager = nil then
    IOManager := TIOManager.Create(plugin_dir)
  else
    IOManager := UseIOManager;

  FOwnIOManager := (UseIOManager = nil);

  MFiles := TMFiles.Create(self);
  MFinder := TMFinder.Create(Self);
  MBitmaps := TMBitmaps.Create(Self);
  MDTMs := TMDTMS.Create(Self);
  MOCR := TMOCR.Create(Self);
  MInternets := TMInternet.Create(Self);
  MSockets := TMSocks.Create(Self);
end;

(*

TClient.Destroy
~~~~~~~~~~~~~~~

.. code-block:: pascal

    destructor TClient.Destroy;

*)

destructor TClient.Destroy;
begin

  MOCR.Free;
  MDTMs.Free;
  MBitmaps.Free;
  MFinder.Free;
  MFiles.Free;
  MInternets.Free;
  MSockets.Free;
  if FOwnIOManager then
    IOManager.Free;

  inherited;
end;

end.
