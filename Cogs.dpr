program Cogs;

uses
  System.StartUpCopy,
  FMX.Forms,
  FMX.Types,
  MMSystem,
  frmMain in 'frmMain.pas' {Form10};

{$R *.res}

begin

  Application.Initialize;

  timeBeginPeriod(1);

  // On low-end hardware or mobile bitmap effects are slowly
  GlobalDisableFocusEffect := False;
  // Allow using Direct3D for UI and 3D rendering
  GlobalUseDX := True;
  // Force using legacy DX9 feature level in Direct3D
  GlobalUseDXInDX9Mode := False;
  // Give higher priority to Direct3D WARP device instead of hardware layer
  GlobalUseDXSoftware := False;
  // Allow using Direct2D for UI rendering
  GlobalUseDirect2D := True;
  // Use ClearType rendering in GDI+ renderer
  GlobalUseGDIPlusClearType := True;
  /// <summary>The number of decimal digits for the rounding floating point
  /// values.</summary>
  DigitRoundSize:= -3;
  // Use GPU Canvas
  GlobalUseGPUCanvas := True;

  Application.CreateForm(TForm10, Form10);
  Application.Run;
end.
