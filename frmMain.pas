unit frmMain;

interface

uses
  System.Threading,
  System.Diagnostics,
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Objects,
  System.Actions, FMX.ActnList,
  FMX.Controls.Presentation;

type
  TPointMass = class
  private
    FPositon: TPointF;
    FVelocity: TPointF;
    FAcceleration: TPointF;
    FForce: TPointF;

    FImage: TRectangle;
    FShadow: TRectangle;
  public
    constructor Create();
  end;

  TForm10 = class(TForm)
    ActionList1: TActionList;
    actClose: TAction;
    rectShadow: TRectangle;
    rectCog: TRectangle;
    procedure actCloseExecute(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormPaint(Sender: TObject; Canvas: TCanvas; const ARect: TRectF);
  private
    FCogs: array of TPointMass;
    FStopWatch: TStopwatch;

    FVirgin: Boolean;
    procedure CadenceCogs;
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form10: TForm10;

implementation

uses System.TimeSpan
{$IFDEF MSWINDOWS}
,MMSystem
{$ENDIF}
;

{$R *.fmx}

procedure TForm10.actCloseExecute(Sender: TObject);
begin
  Close;
end;

procedure TForm10.CadenceCogs;
var
  pointMass: TPointMass;
  mousePosition: TPointF;
  strength: Single;
  offset: Single;
  elapsed: TTimeSpan;
  dt: Single;


begin

  if FVirgin then
  begin
    FVirgin := False;
    elapsed := TTimeSpan.Create(0,0,0,0,10);
  end
  else begin
    FStopWatch.Stop;
    elapsed := FStopWatch.Elapsed;
    FStopWatch.Reset;
  end;
  FStopWatch.Start;

  dt := elapsed.Ticks / elapsed.TicksPerSecond;

  BeginUpdate;

  mousePosition := ScreenToClient(Screen.MousePos)-PointF(128,128);

  strength := 100;
  offset := 32;

  for pointMass in FCogs do
  begin
    // newton is in da house
    pointMass.FForce          := -(pointMass.FPositon - mousePosition)*20;
    pointMass.FPositon        := pointMass.FPositon + pointMass.FVelocity*dt*strength;
    pointMass.FVelocity       := pointMass.FVelocity *0.75 +pointMass.FAcceleration*dt;
    pointMass.FAcceleration   := pointMass.FAcceleration * 0.9 + pointMass.FForce*dt;

    pointMass.FImage.Position.Point   := pointMass.FPositon;
    pointMass.FShadow.Position.Point  := pointMass.FPositon + PointF(offset,offset);

    pointMass.FImage.RotationAngle    := pointMass.FImage.RotationAngle + dt*10;
    pointMass.FShadow.RotationAngle   := pointMass.FShadow.RotationAngle + dt*10;


    strength := strength * 0.75 + 10;
    offset := offset - 32*(0.9/Length(FCogs));

    mousePosition := pointMass.FPositon;

  end;

  EndUpdate;

end;

procedure TForm10.FormCreate(Sender: TObject);
var
  i: Integer;
  alpha1: Single;
  alpha2: Single;
  pointMass: TPointMass;
begin
  FVirgin := True;
  SetLength(FCogs, 16);

  alpha1 := 1;
  alpha2 := 1;

  for i := 0 to High(FCogs) do
  begin
    pointMass := TPointMass.Create;

    pointMass.FImage :=  rectCog.Clone(Self) as TRectangle;
    pointMass.FImage.Parent := Self;
    pointMass.FImage.Opacity := alpha1;
    pointMass.FImage.Scale.X := alpha1;
    pointMass.FImage.Scale.Y := alpha1;
    pointMass.FImage.RotationAngle := i;

    pointMass.FShadow := rectShadow.Clone(Self) as TRectangle;
    pointMass.FShadow.Parent := Self;
    pointMass.FShadow.Opacity := alpha2;
    pointMass.FShadow.Scale.X := alpha1;
    pointMass.FShadow.Scale.Y := alpha1;
    pointMass.FShadow.RotationAngle := i;

    alpha1 := alpha1 - (0.75/Length(FCogs));
    alpha2 := alpha2 - (0.50/Length(FCogs));

    FCogs[i] := pointMass;
  end;

  for pointMass in FCogs do
  begin
    pointMass.FImage.SendToBack;
  end;

  for pointMass in FCogs do
  begin
    pointMass.FShadow.SendToBack;
  end;

  rectCog.Visible := False;
  rectShadow.Visible := False;

  FStopWatch := TStopwatch.StartNew;


end;

procedure TForm10.FormPaint(Sender: TObject; Canvas: TCanvas;
  const ARect: TRectF);
begin
  Application.ProcessMessages;
  CadenceCogs;
end;

{ TPointMass }

constructor TPointMass.Create;
begin
  FImage := nil;
  FShadow := nil;
end;

end.
