unit TypeFXAnimations;

interface

uses
  Windows, SysUtils, Classes, Graphics, Types, Math;

type
  // Animation types - EXPANDED with 10 new effects
  TAnimationType = (
    atNone,
    atFire,
    atLightning,
    atMagic,
    atExplosion,
    atSparks,
    atMatrix,
    atRainbow,
    // NEW ANIMATIONS
    atIce,          // Icy crystal particles falling
    atFlame,        // Blue flame effect
    atStars,        // Twinkling star burst
    atSmoke,        // Wispy smoke particles
    atNeon,         // Neon glow pulse
    atPlasma,       // Purple plasma energy
    atWind,         // Wind-blown particles
    atGold,         // Golden sparkle shower
    atLaser,        // Red laser beams
    atCrystal       // Crystal fragments
  );

  // Effect styles - EXPANDED
  TEffectStyle = (
    esFire,
    esLightning,
    esMagic,
    esExplosion,
    esSparks,
    esMatrix,
    esRainbow,
    // NEW EFFECT STYLES
    esIce,
    esFlame,
    esStars,
    esSmoke,
    esNeon,
    esPlasma,
    esWind,
    esGold,
    esLaser,
    esCrystal
  );

  // Trigger frequency
  TTriggerFrequency = (
    tfEveryKey,
    tfEveryOtherKey,
    tfEveryWord,
    tfEveryLine
  );

  // Main configuration record
  TTypeFXConfig = record
    EffectStyle: TEffectStyle;
    TriggerFrequency: TTriggerFrequency;
    AnimationSpeed: Integer;     // 10-200ms
    Duration: Integer;           // 500-3000ms
    ShowOnDelete: Boolean;
    Intensity: Integer;          // 1-10 (affects size/opacity)
    RandomOffset: Boolean;       // Add random positioning
  end;

  // Advanced particle structure for professional animations
  TParticle = record
    X, Y: Double;              // Position
    VelX, VelY: Double;        // Velocity
    AccX, AccY: Double;        // Acceleration
    Life: Double;              // Life remaining (0-1)
    MaxLife: Double;           // Initial life value
    Size: Double;              // Current size
    InitialSize: Double;       // Starting size
    Alpha: Double;             // Transparency
    Color: TColor;             // Particle color
    Angle: Double;             // Rotation angle
    AngularVel: Double;        // Rotation speed
    Phase: Double;             // Animation phase
    Data1, Data2: Double;      // Extra data for special effects
  end;

  // Professional particle system with enhanced rendering
  TParticleSystem = class
  private
    FParticles: array of TParticle;
    FParticleCount: Integer;
    FMaxParticles: Integer;
    FAnimationType: TAnimationType;
    FIntensity: Integer;
    FStartTime: Cardinal;
    FDuration: Integer;

    // Original initialization methods
    procedure InitializeFireParticles;
    procedure InitializeLightningParticles;
    procedure InitializeMagicParticles;
    procedure InitializeExplosionParticles;
    procedure InitializeSparksParticles;
    procedure InitializeMatrixParticles;
    procedure InitializeRainbowParticles;

    // NEW initialization methods
    procedure InitializeIceParticles;
    procedure InitializeFlameParticles;
    procedure InitializeStarsParticles;
    procedure InitializeSmokeParticles;
    procedure InitializeNeonParticles;
    procedure InitializePlasmaParticles;
    procedure InitializeWindParticles;
    procedure InitializeGoldParticles;
    procedure InitializeLaserParticles;
    procedure InitializeCrystalParticles;

    // Original update methods
    procedure UpdateFireParticles(DeltaTime: Double);
    procedure UpdateLightningParticles(DeltaTime: Double);
    procedure UpdateMagicParticles(DeltaTime: Double);
    procedure UpdateExplosionParticles(DeltaTime: Double);
    procedure UpdateSparksParticles(DeltaTime: Double);
    procedure UpdateMatrixParticles(DeltaTime: Double);
    procedure UpdateRainbowParticles(DeltaTime: Double);

    // NEW update methods
    procedure UpdateIceParticles(DeltaTime: Double);
    procedure UpdateFlameParticles(DeltaTime: Double);
    procedure UpdateStarsParticles(DeltaTime: Double);
    procedure UpdateSmokeParticles(DeltaTime: Double);
    procedure UpdateNeonParticles(DeltaTime: Double);
    procedure UpdatePlasmaParticles(DeltaTime: Double);
    procedure UpdateWindParticles(DeltaTime: Double);
    procedure UpdateGoldParticles(DeltaTime: Double);
    procedure UpdateLaserParticles(DeltaTime: Double);
    procedure UpdateCrystalParticles(DeltaTime: Double);

    // Original render methods
    procedure RenderFireParticles(Canvas: TCanvas; CenterX, CenterY: Integer);
    procedure RenderLightningParticles(Canvas: TCanvas; CenterX, CenterY: Integer);
    procedure RenderMagicParticles(Canvas: TCanvas; CenterX, CenterY: Integer);
    procedure RenderExplosionParticles(Canvas: TCanvas; CenterX, CenterY: Integer);
    procedure RenderSparksParticles(Canvas: TCanvas; CenterX, CenterY: Integer);
    procedure RenderMatrixParticles(Canvas: TCanvas; CenterX, CenterY: Integer);
    procedure RenderRainbowParticles(Canvas: TCanvas; CenterX, CenterY: Integer);

    // NEW render methods
    procedure RenderIceParticles(Canvas: TCanvas; CenterX, CenterY: Integer);
    procedure RenderFlameParticles(Canvas: TCanvas; CenterX, CenterY: Integer);
    procedure RenderStarsParticles(Canvas: TCanvas; CenterX, CenterY: Integer);
    procedure RenderSmokeParticles(Canvas: TCanvas; CenterX, CenterY: Integer);
    procedure RenderNeonParticles(Canvas: TCanvas; CenterX, CenterY: Integer);
    procedure RenderPlasmaParticles(Canvas: TCanvas; CenterX, CenterY: Integer);
    procedure RenderWindParticles(Canvas: TCanvas; CenterX, CenterY: Integer);
    procedure RenderGoldParticles(Canvas: TCanvas; CenterX, CenterY: Integer);
    procedure RenderLaserParticles(Canvas: TCanvas; CenterX, CenterY: Integer);
    procedure RenderCrystalParticles(Canvas: TCanvas; CenterX, CenterY: Integer);

    function SmoothStep(Edge0, Edge1, X: Double): Double;
    function Lerp(A, B, T: Double): Double;
    function EaseOutCubic(T: Double): Double;
    function EaseInOutQuad(T: Double): Double;
    procedure DrawGlow(Canvas: TCanvas; X, Y, Size: Integer; Color: TColor; Intensity: Double);

  public
    constructor Create(AAnimationType: TAnimationType; AIntensity: Integer; ADuration: Integer);
    destructor Destroy; override;

    procedure Update(DeltaTime: Double);
    procedure Render(Canvas: TCanvas; CenterX, CenterY: Integer);
    function IsAlive: Boolean;

    property AnimationType: TAnimationType read FAnimationType;
  end;

// Helper functions
function GetDefaultTypeFXConfig: TTypeFXConfig;
function GetAnimationName(AType: TAnimationType): string;
function GetEffectStyleName(AStyle: TEffectStyle): string;
function GetTriggerFrequencyName(AFreq: TTriggerFrequency): string;
function HSVtoRGB(H, S, V: Integer): TColor;
function BlendColor(Color1, Color2: TColor; Alpha: Double): TColor;
function RandomFloat(Min, Max: Double): Double;

implementation

{ Utility Functions }

function GetDefaultTypeFXConfig: TTypeFXConfig;
begin
  Result.EffectStyle := esFire;
  Result.TriggerFrequency := tfEveryKey;
  Result.AnimationSpeed := 50;
  Result.Duration := 1000;
  Result.ShowOnDelete := False;
  Result.Intensity := 5;
  Result.RandomOffset := True;
end;

function GetAnimationName(AType: TAnimationType): string;
begin
  case AType of
    atNone:      Result := 'None';
    atFire:      Result := 'Fire Burst';
    atLightning: Result := 'Lightning Strike';
    atMagic:     Result := 'Magic Sparkle';
    atExplosion: Result := 'Explosion';
    atSparks:    Result := 'Electric Sparks';
    atMatrix:    Result := 'Matrix Code';
    atRainbow:   Result := 'Rainbow Trail';
    // NEW ANIMATIONS
    atIce:       Result := 'Ice Crystals';
    atFlame:     Result := 'Blue Flame';
    atStars:     Result := 'Star Burst';
    atSmoke:     Result := 'Smoke Wisp';
    atNeon:      Result := 'Neon Pulse';
    atPlasma:    Result := 'Plasma Energy';
    atWind:      Result := 'Wind Blow';
    atGold:      Result := 'Gold Shower';
    atLaser:     Result := 'Laser Beam';
    atCrystal:   Result := 'Crystal Shards';
    else         Result := 'Unknown';
  end;
end;

function GetEffectStyleName(AStyle: TEffectStyle): string;
begin
  case AStyle of
    esFire:      Result := 'Fire Effects';
    esLightning: Result := 'Lightning Effects';
    esMagic:     Result := 'Magic Effects';
    esExplosion: Result := 'Explosion Effects';
    esSparks:    Result := 'Electric Sparks';
    esMatrix:    Result := 'Matrix Code Rain';
    esRainbow:   Result := 'Rainbow Trails';
    // NEW EFFECT STYLES
    esIce:       Result := 'Ice Crystal Effects';
    esFlame:     Result := 'Blue Flame Effects';
    esStars:     Result := 'Stellar Burst Effects';
    esSmoke:     Result := 'Smoke Wisp Effects';
    esNeon:      Result := 'Neon Glow Effects';
    esPlasma:    Result := 'Plasma Energy Effects';
    esWind:      Result := 'Wind Particle Effects';
    esGold:      Result := 'Golden Sparkle Effects';
    esLaser:     Result := 'Laser Beam Effects';
    esCrystal:   Result := 'Crystal Shard Effects';
    else         Result := 'Unknown';
  end;
end;

function GetTriggerFrequencyName(AFreq: TTriggerFrequency): string;
begin
  case AFreq of
    tfEveryKey:      Result := 'Every Keystroke';
    tfEveryOtherKey: Result := 'Every Other Key';
    tfEveryWord:     Result := 'Every Word (Space/Enter)';
    tfEveryLine:     Result := 'Every Line (Enter only)';
    else             Result := 'Unknown';
  end;
end;

function HSVtoRGB(H, S, V: Integer): TColor;
var
  r, g, b: Integer;
  i, f, p, q, t: Integer;
begin
  if S = 0 then
  begin
    r := V;
    g := V;
    b := V;
  end
  else
  begin
    H := H mod 360;
    i := H div 60;
    f := ((H mod 60) * 255) div 60;
    p := (V * (255 - S)) div 255;
    q := (V * (255 - (S * f) div 255)) div 255;
    t := (V * (255 - (S * (255 - f)) div 255)) div 255;

    case i of
      0: begin r := V; g := t; b := p; end;
      1: begin r := q; g := V; b := p; end;
      2: begin r := p; g := V; b := t; end;
      3: begin r := p; g := q; b := V; end;
      4: begin r := t; g := p; b := V; end;
      5: begin r := V; g := p; b := q; end;
      else begin r := V; g := V; b := V; end;
    end;
  end;

  Result := RGB(r, g, b);
end;

function BlendColor(Color1, Color2: TColor; Alpha: Double): TColor;
var
  R1, G1, B1, R2, G2, B2: Byte;
  R, G, B: Byte;
begin
  R1 := GetRValue(Color1);
  G1 := GetGValue(Color1);
  B1 := GetBValue(Color1);
  R2 := GetRValue(Color2);
  G2 := GetGValue(Color2);
  B2 := GetBValue(Color2);

  R := Round(R1 + (R2 - R1) * Alpha);
  G := Round(G1 + (G2 - G1) * Alpha);
  B := Round(B1 + (B2 - B1) * Alpha);

  Result := RGB(R, G, B);
end;

function RandomFloat(Min, Max: Double): Double;
begin
  Result := Min + Random * (Max - Min);
end;

{ TParticleSystem }

constructor TParticleSystem.Create(AAnimationType: TAnimationType; AIntensity: Integer; ADuration: Integer);
begin
  inherited Create;
  FAnimationType := AAnimationType;
  FIntensity := AIntensity;
  FDuration := ADuration;
  FStartTime := GetTickCount;

  // Use same small particle count for ALL effects (like fire)
  FMaxParticles := 12 + (FIntensity * 3); // Same as fire: 15-42 particles max

  SetLength(FParticles, FMaxParticles);
  FParticleCount := FMaxParticles;

  // Initialize particles based on animation type
  case FAnimationType of
    atFire: InitializeFireParticles;
    atLightning: InitializeLightningParticles;
    atMagic: InitializeMagicParticles;
    atExplosion: InitializeExplosionParticles;
    atSparks: InitializeSparksParticles;
    atMatrix: InitializeMatrixParticles;
    atRainbow: InitializeRainbowParticles;
    // NEW ANIMATIONS
    atIce: InitializeIceParticles;
    atFlame: InitializeFlameParticles;
    atStars: InitializeStarsParticles;
    atSmoke: InitializeSmokeParticles;
    atNeon: InitializeNeonParticles;
    atPlasma: InitializePlasmaParticles;
    atWind: InitializeWindParticles;
    atGold: InitializeGoldParticles;
    atLaser: InitializeLaserParticles;
    atCrystal: InitializeCrystalParticles;
  end;
end;

destructor TParticleSystem.Destroy;
begin
  SetLength(FParticles, 0);
  inherited;
end;

function TParticleSystem.SmoothStep(Edge0, Edge1, X: Double): Double;
begin
  X := Max(0, Min(1, (X - Edge0) / (Edge1 - Edge0)));
  Result := X * X * (3 - 2 * X);
end;

function TParticleSystem.Lerp(A, B, T: Double): Double;
begin
  Result := A + (B - A) * T;
end;

function TParticleSystem.EaseOutCubic(T: Double): Double;
begin
  T := T - 1;
  Result := T * T * T + 1;
end;

function TParticleSystem.EaseInOutQuad(T: Double): Double;
begin
  if T < 0.5 then
    Result := 2 * T * T
  else
    Result := -1 + (4 - 2 * T) * T;
end;

procedure TParticleSystem.DrawGlow(Canvas: TCanvas; X, Y, Size: Integer; Color: TColor; Intensity: Double);
var
  GlowSize: Integer;
  Alpha: Double;
  i: Integer;
begin
  Canvas.Brush.Style := bsSolid;
  Canvas.Pen.Style := psClear;

  // Draw multiple layers for glow effect
  for i := 3 downto 1 do
  begin
    GlowSize := Size * i;
    Alpha := Intensity / (i * 2);
    Canvas.Brush.Color := BlendColor(clBlack, Color, Alpha);
    Canvas.Ellipse(X - GlowSize, Y - GlowSize, X + GlowSize, Y + GlowSize);
  end;

  // Draw core
  Canvas.Brush.Color := Color;
  Canvas.Ellipse(X - Size, Y - Size, X + Size, Y + Size);
end;

// ORIGINAL PARTICLE INITIALIZATIONS (unchanged)

// PERFECT Fire Particles (keep exactly as is!)
procedure TParticleSystem.InitializeFireParticles;
var
  i: Integer;
  Angle, Speed: Double;
begin
  for i := 0 to FParticleCount - 1 do
  begin
    Angle := RandomFloat(-PI/4, PI/4); // Upward cone for realistic flame
    Speed := RandomFloat(20, 50);       // Enhanced speed for visibility

    FParticles[i].X := RandomFloat(-8, 8);   // Better spread
    FParticles[i].Y := RandomFloat(0, 12);   // Starting area
    FParticles[i].VelX := Sin(Angle) * Speed;
    FParticles[i].VelY := -Cos(Angle) * Speed;
    FParticles[i].AccX := RandomFloat(-15, 15); // Enhanced wind effect
    FParticles[i].AccY := -30; // Strong buoyancy
    FParticles[i].Life := 1.0;
    FParticles[i].MaxLife := RandomFloat(0.8, 1.4); // Longer duration
    FParticles[i].Size := RandomFloat(3, 8) * (FIntensity / 5.0); // Larger particles
    FParticles[i].InitialSize := FParticles[i].Size;
    FParticles[i].Alpha := 1.0;
    FParticles[i].Angle := RandomFloat(0, 2 * PI);
    FParticles[i].AngularVel := RandomFloat(-6, 6);
    FParticles[i].Phase := RandomFloat(0, 2 * PI);

    // Start white-hot
    FParticles[i].Color := RGB(255, 255, 255);
  end;
end;

// Lightning - simplified like fire
procedure TParticleSystem.InitializeLightningParticles;
var
  i: Integer;
begin
  for i := 0 to FParticleCount - 1 do
  begin
    // Small compact area like fire
    FParticles[i].X := RandomFloat(-8, 8);
    FParticles[i].Y := RandomFloat(-8, 8);
    FParticles[i].VelX := 0;
    FParticles[i].VelY := 0;
    FParticles[i].Life := 1.0;
    FParticles[i].MaxLife := RandomFloat(0.4, 0.8);
    FParticles[i].Size := RandomFloat(2, 5) * (FIntensity / 5.0); // Same size as fire
    FParticles[i].Alpha := 1.0;
    FParticles[i].Color := RGB(220 + Random(36), 220 + Random(36), 255);
    FParticles[i].Phase := RandomFloat(0, 2 * PI);
  end;
end;

// Magic - simplified like fire
procedure TParticleSystem.InitializeMagicParticles;
var
  i: Integer;
  Angle, Radius: Double;
begin
  for i := 0 to FParticleCount - 1 do
  begin
    Angle := (i / FParticleCount) * 2 * PI + RandomFloat(-0.2, 0.2);
    Radius := RandomFloat(6, 12); // Much smaller radius like fire size

    FParticles[i].X := Cos(Angle) * Radius;
    FParticles[i].Y := Sin(Angle) * Radius;
    FParticles[i].VelX := 0;
    FParticles[i].VelY := 0;
    FParticles[i].Life := 1.0;
    FParticles[i].MaxLife := RandomFloat(0.8, 1.4);
    FParticles[i].Size := RandomFloat(2, 5) * (FIntensity / 5.0); // Same size as fire
    FParticles[i].InitialSize := FParticles[i].Size;
    FParticles[i].Alpha := 1.0;
    FParticles[i].Angle := Angle;
    FParticles[i].AngularVel := RandomFloat(3, 6);
    FParticles[i].Phase := RandomFloat(0, 2 * PI);
    FParticles[i].Data1 := Radius;

    // Magical colors
    FParticles[i].Color := HSVtoRGB(Round(RandomFloat(240, 330)), 255, 255);
  end;
end;

// Explosion - simplified like fire
procedure TParticleSystem.InitializeExplosionParticles;
var
  i: Integer;
  Angle, Speed: Double;
begin
  for i := 0 to FParticleCount - 1 do
  begin
    Angle := RandomFloat(0, 2 * PI);
    Speed := RandomFloat(20, 50); // Same speed range as fire

    FParticles[i].X := RandomFloat(-3, 3); // Start near center like fire
    FParticles[i].Y := RandomFloat(-3, 3);
    FParticles[i].VelX := Cos(Angle) * Speed;
    FParticles[i].VelY := Sin(Angle) * Speed;
    FParticles[i].AccX := -FParticles[i].VelX * 1.2;
    FParticles[i].AccY := -FParticles[i].VelY * 1.2 + 30; // Less gravity
    FParticles[i].Life := 1.0;
    FParticles[i].MaxLife := RandomFloat(0.8, 1.4);
    FParticles[i].Size := RandomFloat(3, 8) * (FIntensity / 5.0); // Same size as fire
    FParticles[i].InitialSize := FParticles[i].Size;
    FParticles[i].Alpha := 1.0;

    // Explosion colors
    if i < FParticleCount div 4 then
      FParticles[i].Color := RGB(255, 255, 200)
    else if i < FParticleCount div 2 then
      FParticles[i].Color := RGB(255, 180, 0)
    else
      FParticles[i].Color := RGB(255, 80, 0);
  end;
end;

// Sparks - simplified like fire
procedure TParticleSystem.InitializeSparksParticles;
var
  i: Integer;
  Angle, Speed: Double;
begin
  for i := 0 to FParticleCount - 1 do
  begin
    Angle := (i / FParticleCount) * 2 * PI + RandomFloat(-0.3, 0.3);
    Speed := RandomFloat(20, 40); // Similar to fire

    FParticles[i].X := 0;
    FParticles[i].Y := 0;
    FParticles[i].VelX := Cos(Angle) * Speed;
    FParticles[i].VelY := Sin(Angle) * Speed;
    FParticles[i].AccX := -FParticles[i].VelX * 2;
    FParticles[i].AccY := -FParticles[i].VelY * 2;
    FParticles[i].Life := 1.0;
    FParticles[i].MaxLife := RandomFloat(0.8, 1.2);
    FParticles[i].Size := RandomFloat(2, 5) * (FIntensity / 5.0); // Same size as fire
    FParticles[i].Alpha := 1.0;
    FParticles[i].Color := RGB(255, 255, 150 + Random(106));
    FParticles[i].Phase := RandomFloat(0, 2 * PI);
  end;
end;

// Matrix - simplified like fire
procedure TParticleSystem.InitializeMatrixParticles;
var
  i: Integer;
begin
  for i := 0 to FParticleCount - 1 do
  begin
    FParticles[i].X := RandomFloat(-8, 8); // Same spread as fire
    FParticles[i].Y := RandomFloat(-12, -8); // Start just above
    FParticles[i].VelX := 0;
    FParticles[i].VelY := RandomFloat(30, 50); // Similar speed to fire
    FParticles[i].Life := 1.0;
    FParticles[i].MaxLife := RandomFloat(0.8, 1.4);
    FParticles[i].Size := RandomFloat(8, 12) * (FIntensity / 5.0); // Small text size
    FParticles[i].Alpha := 1.0;
    FParticles[i].Color := RGB(0, 255, 0);
    FParticles[i].Data1 := Random(26); // Character index (A-Z)
    FParticles[i].Data2 := Random(10); // Number index (0-9)
  end;
end;

// Rainbow - simplified like fire
procedure TParticleSystem.InitializeRainbowParticles;
var
  i: Integer;
  Angle: Double;
begin
  for i := 0 to FParticleCount - 1 do
  begin
    Angle := (i / FParticleCount) * 2 * PI;

    FParticles[i].X := Cos(Angle) * 8; // Small radius like fire
    FParticles[i].Y := Sin(Angle) * 8;
    FParticles[i].VelX := Cos(Angle + PI/2) * 20;
    FParticles[i].VelY := Sin(Angle + PI/2) * 20;
    FParticles[i].Life := 1.0;
    FParticles[i].MaxLife := RandomFloat(0.8, 1.4);
    FParticles[i].Size := RandomFloat(3, 6) * (FIntensity / 5.0); // Same size as fire
    FParticles[i].InitialSize := FParticles[i].Size;
    FParticles[i].Alpha := 1.0;
    FParticles[i].Angle := Angle;
    FParticles[i].AngularVel := 3.0;
    FParticles[i].Phase := (i / FParticleCount) * 360;
    FParticles[i].Color := HSVtoRGB(Round(FParticles[i].Phase), 255, 255);
  end;
end;

// NEW PARTICLE INITIALIZATIONS - All following the same compact size pattern

// Ice Crystals - Falling with crystalline shimmer
procedure TParticleSystem.InitializeIceParticles;
var
  i: Integer;
  Angle, Speed: Double;
begin
  for i := 0 to FParticleCount - 1 do
  begin
    Angle := RandomFloat(-PI/6, PI/6); // Slight angle for natural fall
    Speed := RandomFloat(15, 35);

    FParticles[i].X := RandomFloat(-8, 8);
    FParticles[i].Y := RandomFloat(-12, -8); // Start above
    FParticles[i].VelX := Sin(Angle) * Speed * 0.3; // Gentle drift
    FParticles[i].VelY := Cos(Angle) * Speed; // Downward
    FParticles[i].AccX := RandomFloat(-8, 8); // Light air currents
    FParticles[i].AccY := 15; // Light gravity
    FParticles[i].Life := 1.0;
    FParticles[i].MaxLife := RandomFloat(1.0, 1.6);
    FParticles[i].Size := RandomFloat(2, 6) * (FIntensity / 5.0);
    FParticles[i].InitialSize := FParticles[i].Size;
    FParticles[i].Alpha := 1.0;
    FParticles[i].Angle := RandomFloat(0, 2 * PI);
    FParticles[i].AngularVel := RandomFloat(-4, 4);
    FParticles[i].Phase := RandomFloat(0, 2 * PI);

    // Ice blue colors
    FParticles[i].Color := RGB(200 + Random(56), 230 + Random(26), 255);
  end;
end;

// Blue Flame - Like fire but blue
procedure TParticleSystem.InitializeFlameParticles;
var
  i: Integer;
  Angle, Speed: Double;
begin
  for i := 0 to FParticleCount - 1 do
  begin
    Angle := RandomFloat(-PI/4, PI/4);
    Speed := RandomFloat(20, 50);

    FParticles[i].X := RandomFloat(-8, 8);
    FParticles[i].Y := RandomFloat(0, 12);
    FParticles[i].VelX := Sin(Angle) * Speed;
    FParticles[i].VelY := -Cos(Angle) * Speed;
    FParticles[i].AccX := RandomFloat(-15, 15);
    FParticles[i].AccY := -30;
    FParticles[i].Life := 1.0;
    FParticles[i].MaxLife := RandomFloat(0.8, 1.4);
    FParticles[i].Size := RandomFloat(3, 8) * (FIntensity / 5.0);
    FParticles[i].InitialSize := FParticles[i].Size;
    FParticles[i].Alpha := 1.0;
    FParticles[i].Angle := RandomFloat(0, 2 * PI);
    FParticles[i].AngularVel := RandomFloat(-6, 6);
    FParticles[i].Phase := RandomFloat(0, 2 * PI);

    // Blue flame colors
    FParticles[i].Color := RGB(100 + Random(56), 150 + Random(106), 255);
  end;
end;

// Star Burst - Twinkling stars radiating outward
procedure TParticleSystem.InitializeStarsParticles;
var
  i: Integer;
  Angle, Speed: Double;
begin
  for i := 0 to FParticleCount - 1 do
  begin
    Angle := (i / FParticleCount) * 2 * PI + RandomFloat(-0.2, 0.2);
    Speed := RandomFloat(15, 35);

    FParticles[i].X := RandomFloat(-3, 3);
    FParticles[i].Y := RandomFloat(-3, 3);
    FParticles[i].VelX := Cos(Angle) * Speed;
    FParticles[i].VelY := Sin(Angle) * Speed;
    FParticles[i].AccX := -FParticles[i].VelX * 1.5;
    FParticles[i].AccY := -FParticles[i].VelY * 1.5;
    FParticles[i].Life := 1.0;
    FParticles[i].MaxLife := RandomFloat(0.8, 1.4);
    FParticles[i].Size := RandomFloat(2, 5) * (FIntensity / 5.0);
    FParticles[i].InitialSize := FParticles[i].Size;
    FParticles[i].Alpha := 1.0;
    FParticles[i].Angle := Angle;
    FParticles[i].AngularVel := RandomFloat(-8, 8);
    FParticles[i].Phase := RandomFloat(0, 2 * PI);

    // Bright star colors
    FParticles[i].Color := RGB(255, 255, 200 + Random(56));
  end;
end;

// Smoke Wisp - Gentle upward drift
procedure TParticleSystem.InitializeSmokeParticles;
var
  i: Integer;
  Angle, Speed: Double;
begin
  for i := 0 to FParticleCount - 1 do
  begin
    Angle := RandomFloat(-PI/3, PI/3);
    Speed := RandomFloat(10, 25);

    FParticles[i].X := RandomFloat(-6, 6);
    FParticles[i].Y := RandomFloat(0, 8);
    FParticles[i].VelX := Sin(Angle) * Speed * 0.5;
    FParticles[i].VelY := -Cos(Angle) * Speed;
    FParticles[i].AccX := RandomFloat(-10, 10);
    FParticles[i].AccY := -20; // Gentle rise
    FParticles[i].Life := 1.0;
    FParticles[i].MaxLife := RandomFloat(1.2, 2.0);
    FParticles[i].Size := RandomFloat(4, 10) * (FIntensity / 5.0);
    FParticles[i].InitialSize := FParticles[i].Size;
    FParticles[i].Alpha := 0.6;
    FParticles[i].Angle := RandomFloat(0, 2 * PI);
    FParticles[i].AngularVel := RandomFloat(-2, 2);
    FParticles[i].Phase := RandomFloat(0, 2 * PI);

    // Smoke gray colors
    FParticles[i].Color := RGB(120 + Random(86), 120 + Random(86), 130 + Random(76));
  end;
end;

// Neon Pulse - Pulsing neon glow
procedure TParticleSystem.InitializeNeonParticles;
var
  i: Integer;
  Angle, Radius: Double;
begin
  for i := 0 to FParticleCount - 1 do
  begin
    Angle := (i / FParticleCount) * 2 * PI;
    Radius := RandomFloat(4, 10);

    FParticles[i].X := Cos(Angle) * Radius;
    FParticles[i].Y := Sin(Angle) * Radius * 0.7;
    FParticles[i].VelX := 0;
    FParticles[i].VelY := 0;
    FParticles[i].Life := 1.0;
    FParticles[i].MaxLife := RandomFloat(0.8, 1.4);
    FParticles[i].Size := RandomFloat(3, 7) * (FIntensity / 5.0);
    FParticles[i].InitialSize := FParticles[i].Size;
    FParticles[i].Alpha := 1.0;
    FParticles[i].Angle := Angle;
    FParticles[i].AngularVel := 0;
    FParticles[i].Phase := RandomFloat(0, 2 * PI);
    FParticles[i].Data1 := Radius;

    // Neon cyan/pink colors
    if i mod 2 = 0 then
      FParticles[i].Color := RGB(0, 255, 255) // Cyan
    else
      FParticles[i].Color := RGB(255, 0, 255); // Magenta
  end;
end;

// Plasma Energy - Purple energy swirl
procedure TParticleSystem.InitializePlasmaParticles;
var
  i: Integer;
  Angle, Speed: Double;
begin
  for i := 0 to FParticleCount - 1 do
  begin
    Angle := RandomFloat(0, 2 * PI);
    Speed := RandomFloat(25, 45);

    FParticles[i].X := RandomFloat(-4, 4);
    FParticles[i].Y := RandomFloat(-4, 4);
    FParticles[i].VelX := Cos(Angle) * Speed;
    FParticles[i].VelY := Sin(Angle) * Speed;
    FParticles[i].AccX := -FParticles[i].X * 15; // Pull toward center
    FParticles[i].AccY := -FParticles[i].Y * 15;
    FParticles[i].Life := 1.0;
    FParticles[i].MaxLife := RandomFloat(0.6, 1.0);
    FParticles[i].Size := RandomFloat(2, 6) * (FIntensity / 5.0);
    FParticles[i].InitialSize := FParticles[i].Size;
    FParticles[i].Alpha := 1.0;
    FParticles[i].Angle := Angle;
    FParticles[i].AngularVel := RandomFloat(-10, 10);
    FParticles[i].Phase := RandomFloat(0, 2 * PI);

    // Purple plasma colors
    FParticles[i].Color := RGB(128 + Random(128), 0, 200 + Random(56));
  end;
end;

// Wind Blown - Horizontal drift particles
procedure TParticleSystem.InitializeWindParticles;
var
  i: Integer;
  Speed: Double;
begin
  for i := 0 to FParticleCount - 1 do
  begin
    Speed := RandomFloat(30, 60);

    FParticles[i].X := RandomFloat(-12, -8); // Start from left
    FParticles[i].Y := RandomFloat(-6, 6);
    FParticles[i].VelX := Speed; // Strong horizontal movement
    FParticles[i].VelY := RandomFloat(-10, 10);
    FParticles[i].AccX := -10; // Wind resistance
    FParticles[i].AccY := RandomFloat(-5, 5);
    FParticles[i].Life := 1.0;
    FParticles[i].MaxLife := RandomFloat(0.8, 1.2);
    FParticles[i].Size := RandomFloat(2, 5) * (FIntensity / 5.0);
    FParticles[i].InitialSize := FParticles[i].Size;
    FParticles[i].Alpha := 0.8;
    FParticles[i].Angle := RandomFloat(0, 2 * PI);
    FParticles[i].AngularVel := RandomFloat(-8, 8);
    FParticles[i].Phase := RandomFloat(0, 2 * PI);

    // Wind particle colors (light blue/white)
    FParticles[i].Color := RGB(220 + Random(36), 240 + Random(16), 255);
  end;
end;

// Gold Shower - Golden sparkles falling
procedure TParticleSystem.InitializeGoldParticles;
var
  i: Integer;
  Angle, Speed: Double;
begin
  for i := 0 to FParticleCount - 1 do
  begin
    Angle := RandomFloat(-PI/6, PI/6);
    Speed := RandomFloat(20, 40);

    FParticles[i].X := RandomFloat(-8, 8);
    FParticles[i].Y := RandomFloat(-12, -8);
    FParticles[i].VelX := Sin(Angle) * Speed * 0.4;
    FParticles[i].VelY := Cos(Angle) * Speed;
    FParticles[i].AccX := RandomFloat(-8, 8);
    FParticles[i].AccY := 25; // Gravity
    FParticles[i].Life := 1.0;
    FParticles[i].MaxLife := RandomFloat(1.0, 1.6);
    FParticles[i].Size := RandomFloat(2, 6) * (FIntensity / 5.0);
    FParticles[i].InitialSize := FParticles[i].Size;
    FParticles[i].Alpha := 1.0;
    FParticles[i].Angle := RandomFloat(0, 2 * PI);
    FParticles[i].AngularVel := RandomFloat(-6, 6);
    FParticles[i].Phase := RandomFloat(0, 2 * PI);

    // Golden colors
    FParticles[i].Color := RGB(255, 180 + Random(76), 0);
  end;
end;

// Laser Beams - Red laser lines
procedure TParticleSystem.InitializeLaserParticles;
var
  i: Integer;
  Angle, Speed: Double;
begin
  for i := 0 to FParticleCount - 1 do
  begin
    Angle := (i / FParticleCount) * 2 * PI + RandomFloat(-0.1, 0.1);
    Speed := RandomFloat(40, 70);

    FParticles[i].X := 0;
    FParticles[i].Y := 0;
    FParticles[i].VelX := Cos(Angle) * Speed;
    FParticles[i].VelY := Sin(Angle) * Speed;
    FParticles[i].AccX := 0;
    FParticles[i].AccY := 0;
    FParticles[i].Life := 1.0;
    FParticles[i].MaxLife := RandomFloat(0.4, 0.8);
    FParticles[i].Size := RandomFloat(1, 3) * (FIntensity / 5.0);
    FParticles[i].InitialSize := FParticles[i].Size;
    FParticles[i].Alpha := 1.0;
    FParticles[i].Angle := Angle;
    FParticles[i].AngularVel := 0;
    FParticles[i].Phase := RandomFloat(0, 2 * PI);
    FParticles[i].Data1 := Speed; // Store speed for rendering

    // Red laser colors
    FParticles[i].Color := RGB(255, 0, 0);
  end;
end;

// Crystal Shards - Sharp crystal fragments
procedure TParticleSystem.InitializeCrystalParticles;
var
  i: Integer;
  Angle, Speed: Double;
begin
  for i := 0 to FParticleCount - 1 do
  begin
    Angle := RandomFloat(0, 2 * PI);
    Speed := RandomFloat(20, 40);

    FParticles[i].X := RandomFloat(-3, 3);
    FParticles[i].Y := RandomFloat(-3, 3);
    FParticles[i].VelX := Cos(Angle) * Speed;
    FParticles[i].VelY := Sin(Angle) * Speed;
    FParticles[i].AccX := -FParticles[i].VelX * 2;
    FParticles[i].AccY := -FParticles[i].VelY * 2 + 20;
    FParticles[i].Life := 1.0;
    FParticles[i].MaxLife := RandomFloat(0.8, 1.4);
    FParticles[i].Size := RandomFloat(3, 7) * (FIntensity / 5.0);
    FParticles[i].InitialSize := FParticles[i].Size;
    FParticles[i].Alpha := 1.0;
    FParticles[i].Angle := Angle;
    FParticles[i].AngularVel := RandomFloat(-12, 12);
    FParticles[i].Phase := RandomFloat(0, 2 * PI);

    // Crystal colors (prismatic)
    case i mod 7 of
      0: FParticles[i].Color := RGB(255, 200, 200); // Light red
      1: FParticles[i].Color := RGB(200, 255, 200); // Light green
      2: FParticles[i].Color := RGB(200, 200, 255); // Light blue
      3: FParticles[i].Color := RGB(255, 255, 200); // Light yellow
      4: FParticles[i].Color := RGB(255, 200, 255); // Light magenta
      5: FParticles[i].Color := RGB(200, 255, 255); // Light cyan
      else FParticles[i].Color := RGB(255, 255, 255); // White
    end;
  end;
end;

// ORIGINAL UPDATE METHODS (unchanged)

procedure TParticleSystem.UpdateFireParticles(DeltaTime: Double);
var
  i: Integer;
  LifeRatio, Temp: Double;
begin
  for i := 0 to FParticleCount - 1 do
  begin
    if FParticles[i].Life <= 0 then Continue;

    // Enhanced physics
    FParticles[i].VelX := FParticles[i].VelX + FParticles[i].AccX * DeltaTime;
    FParticles[i].VelY := FParticles[i].VelY + FParticles[i].AccY * DeltaTime;
    FParticles[i].X := FParticles[i].X + FParticles[i].VelX * DeltaTime;
    FParticles[i].Y := FParticles[i].Y + FParticles[i].VelY * DeltaTime;
    FParticles[i].Angle := FParticles[i].Angle + FParticles[i].AngularVel * DeltaTime;

    // Update life
    FParticles[i].Life := FParticles[i].Life - (DeltaTime / FParticles[i].MaxLife);
    LifeRatio := FParticles[i].Life;

    // Enhanced size evolution
    if LifeRatio > 0.7 then
      FParticles[i].Size := FParticles[i].InitialSize * (1 + (1 - LifeRatio) * 0.8)
    else
      FParticles[i].Size := FParticles[i].InitialSize * LifeRatio * 1.8;

    // Enhanced alpha
    FParticles[i].Alpha := SmoothStep(0, 0.4, LifeRatio);

    // Enhanced temperature-based color transition
    Temp := LifeRatio;
    if Temp > 0.85 then
      FParticles[i].Color := RGB(255, 255, 255) // White hot
    else if Temp > 0.7 then
      FParticles[i].Color := RGB(255, 255, Round(150 + 105 * (Temp - 0.7) * 6.67)) // Bright yellow
    else if Temp > 0.5 then
      FParticles[i].Color := RGB(255, Round(180 + 75 * (Temp - 0.5) * 5), 0) // Orange
    else if Temp > 0.3 then
      FParticles[i].Color := RGB(255, Round(80 + 100 * (Temp - 0.3) * 5), 0) // Red-orange
    else if Temp > 0.1 then
      FParticles[i].Color := RGB(Round(200 + 55 * (Temp - 0.1) * 5), 0, 0) // Red
    else
      FParticles[i].Color := RGB(Round(100 + 100 * Temp * 10), 0, 0); // Dark red
  end;
end;

procedure TParticleSystem.UpdateLightningParticles(DeltaTime: Double);
var
  i: Integer;
  LifeRatio: Double;
begin
  for i := 0 to FParticleCount - 1 do
  begin
    if FParticles[i].Life <= 0 then Continue;

    FParticles[i].Life := FParticles[i].Life - (DeltaTime / FParticles[i].MaxLife);
    LifeRatio := FParticles[i].Life;

    // Simple flickering like fire
    FParticles[i].Alpha := 0.3 + 0.7 * Abs(Sin(GetTickCount * 0.08 + FParticles[i].Phase));
    FParticles[i].Size := FParticles[i].Size * (0.7 + 0.6 * Sin(GetTickCount * 0.05));
  end;
end;

procedure TParticleSystem.UpdateMagicParticles(DeltaTime: Double);
var
  i: Integer;
  LifeRatio, Radius: Double;
begin
  for i := 0 to FParticleCount - 1 do
  begin
    if FParticles[i].Life <= 0 then Continue;

    FParticles[i].Life := FParticles[i].Life - (DeltaTime / FParticles[i].MaxLife);
    LifeRatio := FParticles[i].Life;

    // Simple orbiting motion
    FParticles[i].Angle := FParticles[i].Angle + FParticles[i].AngularVel * DeltaTime;
    Radius := FParticles[i].Data1 * LifeRatio;

    FParticles[i].X := Cos(FParticles[i].Angle) * Radius;
    FParticles[i].Y := Sin(FParticles[i].Angle) * Radius * 0.7;

    // Simple size and alpha
    FParticles[i].Size := FParticles[i].InitialSize * LifeRatio;
    FParticles[i].Alpha := SmoothStep(0, 0.3, LifeRatio);

    // Color cycling
    FParticles[i].Color := HSVtoRGB(
      Round(240 + 90 * Sin(GetTickCount * 0.004 + FParticles[i].Phase)),
      255,
      Round(180 + 75 * LifeRatio)
    );
  end;
end;

procedure TParticleSystem.UpdateExplosionParticles(DeltaTime: Double);
var
  i: Integer;
  LifeRatio: Double;
begin
  for i := 0 to FParticleCount - 1 do
  begin
    if FParticles[i].Life <= 0 then Continue;

    // Simple physics like fire
    FParticles[i].VelX := FParticles[i].VelX + FParticles[i].AccX * DeltaTime;
    FParticles[i].VelY := FParticles[i].VelY + FParticles[i].AccY * DeltaTime;
    FParticles[i].X := FParticles[i].X + FParticles[i].VelX * DeltaTime;
    FParticles[i].Y := FParticles[i].Y + FParticles[i].VelY * DeltaTime;

    FParticles[i].Life := FParticles[i].Life - (DeltaTime / FParticles[i].MaxLife);
    LifeRatio := FParticles[i].Life;

    // Simple size and alpha
    FParticles[i].Size := FParticles[i].InitialSize * LifeRatio;
    FParticles[i].Alpha := EaseOutCubic(LifeRatio);
  end;
end;

procedure TParticleSystem.UpdateSparksParticles(DeltaTime: Double);
var
  i: Integer;
  LifeRatio: Double;
begin
  for i := 0 to FParticleCount - 1 do
  begin
    if FParticles[i].Life <= 0 then Continue;

    // Simple physics
    FParticles[i].VelX := FParticles[i].VelX + FParticles[i].AccX * DeltaTime;
    FParticles[i].VelY := FParticles[i].VelY + FParticles[i].AccY * DeltaTime;
    FParticles[i].X := FParticles[i].X + FParticles[i].VelX * DeltaTime;
    FParticles[i].Y := FParticles[i].Y + FParticles[i].VelY * DeltaTime;

    FParticles[i].Life := FParticles[i].Life - (DeltaTime / FParticles[i].MaxLife);
    LifeRatio := FParticles[i].Life;

    // Simple flickering alpha
    FParticles[i].Alpha := LifeRatio * (0.4 + 0.6 * Abs(Sin(GetTickCount * 0.08 + FParticles[i].Phase)));
  end;
end;

procedure TParticleSystem.UpdateMatrixParticles(DeltaTime: Double);
var
  i: Integer;
  LifeRatio: Double;
begin
  for i := 0 to FParticleCount - 1 do
  begin
    if FParticles[i].Life <= 0 then Continue;

    // Simple falling motion
    FParticles[i].Y := FParticles[i].Y + FParticles[i].VelY * DeltaTime;

    FParticles[i].Life := FParticles[i].Life - (DeltaTime / FParticles[i].MaxLife);
    LifeRatio := FParticles[i].Life;

    // Simple alpha fading
    FParticles[i].Alpha := SmoothStep(0, 0.4, LifeRatio);

    // Simple character changes
    if Random < 0.15 then
    begin
      FParticles[i].Data1 := Random(26);
      FParticles[i].Data2 := Random(10);
    end;
  end;
end;

procedure TParticleSystem.UpdateRainbowParticles(DeltaTime: Double);
var
  i: Integer;
  LifeRatio, Radius: Double;
begin
  for i := 0 to FParticleCount - 1 do
  begin
    if FParticles[i].Life <= 0 then Continue;

    // Simple spiral motion
    FParticles[i].Angle := FParticles[i].Angle + FParticles[i].AngularVel * DeltaTime;
    Radius := 8 + (1 - FParticles[i].Life) * 12; // Small spiral

    FParticles[i].X := Cos(FParticles[i].Angle) * Radius;
    FParticles[i].Y := Sin(FParticles[i].Angle) * Radius * 0.8;

    FParticles[i].Life := FParticles[i].Life - (DeltaTime / FParticles[i].MaxLife);
    LifeRatio := FParticles[i].Life;

    // Simple size and alpha
    FParticles[i].Size := FParticles[i].InitialSize * LifeRatio;
    FParticles[i].Alpha := SmoothStep(0, 0.3, LifeRatio);

    // Color cycling
    FParticles[i].Phase := FParticles[i].Phase + 180 * DeltaTime;
    if FParticles[i].Phase >= 360 then
      FParticles[i].Phase := FParticles[i].Phase - 360;

    FParticles[i].Color := HSVtoRGB(Round(FParticles[i].Phase), 255, Round(220 + 35 * LifeRatio));
  end;
end;

// NEW UPDATE METHODS - Following same simple patterns

procedure TParticleSystem.UpdateIceParticles(DeltaTime: Double);
var
  i: Integer;
  LifeRatio: Double;
begin
  for i := 0 to FParticleCount - 1 do
  begin
    if FParticles[i].Life <= 0 then Continue;

    // Simple physics like fire
    FParticles[i].VelX := FParticles[i].VelX + FParticles[i].AccX * DeltaTime;
    FParticles[i].VelY := FParticles[i].VelY + FParticles[i].AccY * DeltaTime;
    FParticles[i].X := FParticles[i].X + FParticles[i].VelX * DeltaTime;
    FParticles[i].Y := FParticles[i].Y + FParticles[i].VelY * DeltaTime;
    FParticles[i].Angle := FParticles[i].Angle + FParticles[i].AngularVel * DeltaTime;

    FParticles[i].Life := FParticles[i].Life - (DeltaTime / FParticles[i].MaxLife);
    LifeRatio := FParticles[i].Life;

    // Simple size and alpha
    FParticles[i].Size := FParticles[i].InitialSize * LifeRatio;
    FParticles[i].Alpha := SmoothStep(0, 0.4, LifeRatio);

    // Simple shimmer effect
    FParticles[i].Alpha := FParticles[i].Alpha * (0.6 + 0.4 * Sin(GetTickCount * 0.01 + FParticles[i].Phase));
  end;
end;

procedure TParticleSystem.UpdateFlameParticles(DeltaTime: Double);
var
  i: Integer;
  LifeRatio, Temp: Double;
begin
  for i := 0 to FParticleCount - 1 do
  begin
    if FParticles[i].Life <= 0 then Continue;

    // Same physics as fire
    FParticles[i].VelX := FParticles[i].VelX + FParticles[i].AccX * DeltaTime;
    FParticles[i].VelY := FParticles[i].VelY + FParticles[i].AccY * DeltaTime;
    FParticles[i].X := FParticles[i].X + FParticles[i].VelX * DeltaTime;
    FParticles[i].Y := FParticles[i].Y + FParticles[i].VelY * DeltaTime;
    FParticles[i].Angle := FParticles[i].Angle + FParticles[i].AngularVel * DeltaTime;

    FParticles[i].Life := FParticles[i].Life - (DeltaTime / FParticles[i].MaxLife);
    LifeRatio := FParticles[i].Life;

    // Same size evolution as fire
    if LifeRatio > 0.7 then
      FParticles[i].Size := FParticles[i].InitialSize * (1 + (1 - LifeRatio) * 0.8)
    else
      FParticles[i].Size := FParticles[i].InitialSize * LifeRatio * 1.8;

    FParticles[i].Alpha := SmoothStep(0, 0.4, LifeRatio);

    // Blue flame color transition
    Temp := LifeRatio;
    if Temp > 0.8 then
      FParticles[i].Color := RGB(200, 200, 255) // Light blue
    else if Temp > 0.6 then
      FParticles[i].Color := RGB(150, 180, 255) // Blue
    else if Temp > 0.4 then
      FParticles[i].Color := RGB(100, 150, 255) // Deep blue
    else
      FParticles[i].Color := RGB(50, 100, 255); // Dark blue
  end;
end;

procedure TParticleSystem.UpdateStarsParticles(DeltaTime: Double);
var
  i: Integer;
  LifeRatio: Double;
begin
  for i := 0 to FParticleCount - 1 do
  begin
    if FParticles[i].Life <= 0 then Continue;
  // Simple physics like explosion
    FParticles[i].VelX := FParticles[i].VelX + FParticles[i].AccX * DeltaTime;
    FParticles[i].VelY := FParticles[i].VelY + FParticles[i].AccY * DeltaTime;
    FParticles[i].X := FParticles[i].X + FParticles[i].VelX * DeltaTime;
    FParticles[i].Y := FParticles[i].Y + FParticles[i].VelY * DeltaTime;
    FParticles[i].Angle := FParticles[i].Angle + FParticles[i].AngularVel * DeltaTime;

    FParticles[i].Life := FParticles[i].Life - (DeltaTime / FParticles[i].MaxLife);
    LifeRatio := FParticles[i].Life;

    // Simple size and alpha with twinkling
    FParticles[i].Size := FParticles[i].InitialSize * LifeRatio;
    FParticles[i].Alpha := LifeRatio * (0.3 + 0.7 * Abs(Sin(GetTickCount * 0.02 + FParticles[i].Phase)));
  end;
end;

procedure TParticleSystem.UpdateSmokeParticles(DeltaTime: Double);
var
  i: Integer;
  LifeRatio: Double;
begin
  for i := 0 to FParticleCount - 1 do
  begin
    if FParticles[i].Life <= 0 then Continue;

    // Simple physics
    FParticles[i].VelX := FParticles[i].VelX + FParticles[i].AccX * DeltaTime;
    FParticles[i].VelY := FParticles[i].VelY + FParticles[i].AccY * DeltaTime;
    FParticles[i].X := FParticles[i].X + FParticles[i].VelX * DeltaTime;
    FParticles[i].Y := FParticles[i].Y + FParticles[i].VelY * DeltaTime;
    FParticles[i].Angle := FParticles[i].Angle + FParticles[i].AngularVel * DeltaTime;

    FParticles[i].Life := FParticles[i].Life - (DeltaTime / FParticles[i].MaxLife);
    LifeRatio := FParticles[i].Life;

    // Growing size, fading alpha
    FParticles[i].Size := FParticles[i].InitialSize * (1 + (1 - LifeRatio) * 1.5);
    FParticles[i].Alpha := 0.6 * LifeRatio;
  end;
end;

procedure TParticleSystem.UpdateNeonParticles(DeltaTime: Double);
var
  i: Integer;
  LifeRatio: Double;
begin
  for i := 0 to FParticleCount - 1 do
  begin
    if FParticles[i].Life <= 0 then Continue;

    FParticles[i].Life := FParticles[i].Life - (DeltaTime / FParticles[i].MaxLife);
    LifeRatio := FParticles[i].Life;

    // Pulsing size and alpha
    FParticles[i].Size := FParticles[i].InitialSize * (0.5 + 0.5 * Sin(GetTickCount * 0.01 + FParticles[i].Phase));
    FParticles[i].Alpha := LifeRatio * (0.4 + 0.6 * Sin(GetTickCount * 0.008 + FParticles[i].Phase));
  end;
end;

procedure TParticleSystem.UpdatePlasmaParticles(DeltaTime: Double);
var
  i: Integer;
  LifeRatio: Double;
begin
  for i := 0 to FParticleCount - 1 do
  begin
    if FParticles[i].Life <= 0 then Continue;

    // Physics with center attraction
    FParticles[i].VelX := FParticles[i].VelX + FParticles[i].AccX * DeltaTime;
    FParticles[i].VelY := FParticles[i].VelY + FParticles[i].AccY * DeltaTime;
    FParticles[i].X := FParticles[i].X + FParticles[i].VelX * DeltaTime;
    FParticles[i].Y := FParticles[i].Y + FParticles[i].VelY * DeltaTime;
    FParticles[i].Angle := FParticles[i].Angle + FParticles[i].AngularVel * DeltaTime;

    FParticles[i].Life := FParticles[i].Life - (DeltaTime / FParticles[i].MaxLife);
    LifeRatio := FParticles[i].Life;

    // Simple size and alpha
    FParticles[i].Size := FParticles[i].InitialSize * LifeRatio;
    FParticles[i].Alpha := SmoothStep(0, 0.4, LifeRatio);
  end;
end;

procedure TParticleSystem.UpdateWindParticles(DeltaTime: Double);
var
  i: Integer;
  LifeRatio: Double;
begin
  for i := 0 to FParticleCount - 1 do
  begin
    if FParticles[i].Life <= 0 then Continue;

    // Simple physics
    FParticles[i].VelX := FParticles[i].VelX + FParticles[i].AccX * DeltaTime;
    FParticles[i].VelY := FParticles[i].VelY + FParticles[i].AccY * DeltaTime;
    FParticles[i].X := FParticles[i].X + FParticles[i].VelX * DeltaTime;
    FParticles[i].Y := FParticles[i].Y + FParticles[i].VelY * DeltaTime;
    FParticles[i].Angle := FParticles[i].Angle + FParticles[i].AngularVel * DeltaTime;

    FParticles[i].Life := FParticles[i].Life - (DeltaTime / FParticles[i].MaxLife);
    LifeRatio := FParticles[i].Life;

    // Simple size and alpha
    FParticles[i].Size := FParticles[i].InitialSize * LifeRatio;
    FParticles[i].Alpha := 0.8 * LifeRatio;
  end;
end;

procedure TParticleSystem.UpdateGoldParticles(DeltaTime: Double);
var
  i: Integer;
  LifeRatio: Double;
begin
  for i := 0 to FParticleCount - 1 do
  begin
    if FParticles[i].Life <= 0 then Continue;

    // Simple physics like ice
    FParticles[i].VelX := FParticles[i].VelX + FParticles[i].AccX * DeltaTime;
    FParticles[i].VelY := FParticles[i].VelY + FParticles[i].AccY * DeltaTime;
    FParticles[i].X := FParticles[i].X + FParticles[i].VelX * DeltaTime;
    FParticles[i].Y := FParticles[i].Y + FParticles[i].VelY * DeltaTime;
    FParticles[i].Angle := FParticles[i].Angle + FParticles[i].AngularVel * DeltaTime;

    FParticles[i].Life := FParticles[i].Life - (DeltaTime / FParticles[i].MaxLife);
    LifeRatio := FParticles[i].Life;

    // Simple size and alpha with sparkle
    FParticles[i].Size := FParticles[i].InitialSize * LifeRatio;
    FParticles[i].Alpha := LifeRatio * (0.7 + 0.3 * Sin(GetTickCount * 0.015 + FParticles[i].Phase));
  end;
end;

procedure TParticleSystem.UpdateLaserParticles(DeltaTime: Double);
var
  i: Integer;
  LifeRatio: Double;
begin
  for i := 0 to FParticleCount - 1 do
  begin
    if FParticles[i].Life <= 0 then Continue;

    // Simple linear motion
    FParticles[i].X := FParticles[i].X + FParticles[i].VelX * DeltaTime;
    FParticles[i].Y := FParticles[i].Y + FParticles[i].VelY * DeltaTime;

    FParticles[i].Life := FParticles[i].Life - (DeltaTime / FParticles[i].MaxLife);
    LifeRatio := FParticles[i].Life;

    // Simple alpha fade
    FParticles[i].Alpha := LifeRatio;
  end;
end;

procedure TParticleSystem.UpdateCrystalParticles(DeltaTime: Double);
var
  i: Integer;
  LifeRatio: Double;
begin
  for i := 0 to FParticleCount - 1 do
  begin
    if FParticles[i].Life <= 0 then Continue;

    // Simple physics like explosion
    FParticles[i].VelX := FParticles[i].VelX + FParticles[i].AccX * DeltaTime;
    FParticles[i].VelY := FParticles[i].VelY + FParticles[i].AccY * DeltaTime;
    FParticles[i].X := FParticles[i].X + FParticles[i].VelX * DeltaTime;
    FParticles[i].Y := FParticles[i].Y + FParticles[i].VelY * DeltaTime;
    FParticles[i].Angle := FParticles[i].Angle + FParticles[i].AngularVel * DeltaTime;

    FParticles[i].Life := FParticles[i].Life - (DeltaTime / FParticles[i].MaxLife);
    LifeRatio := FParticles[i].Life;

    // Simple size and alpha with prismatic effect
    FParticles[i].Size := FParticles[i].InitialSize * LifeRatio;
    FParticles[i].Alpha := LifeRatio * (0.6 + 0.4 * Sin(GetTickCount * 0.012 + FParticles[i].Phase));
  end;
end;

// ORIGINAL RENDER METHODS (unchanged)

procedure TParticleSystem.RenderFireParticles(Canvas: TCanvas; CenterX, CenterY: Integer);
var
  i: Integer;
  X, Y, Size: Integer;
begin
  Canvas.Pen.Style := psClear;

  for i := 0 to FParticleCount - 1 do
  begin
    if FParticles[i].Life <= 0 then Continue;

    X := CenterX + Round(FParticles[i].X);
    Y := CenterY + Round(FParticles[i].Y);
    Size := Round(FParticles[i].Size);

    if Size > 0 then
    begin
      DrawGlow(Canvas, X, Y, Size, FParticles[i].Color, FParticles[i].Alpha * 0.8);
    end;
  end;
end;

procedure TParticleSystem.RenderLightningParticles(Canvas: TCanvas; CenterX, CenterY: Integer);
var
  i: Integer;
  X, Y, Size: Integer;
begin
  Canvas.Pen.Style := psClear;

  for i := 0 to FParticleCount - 1 do
  begin
    if FParticles[i].Life <= 0 then Continue;

    X := CenterX + Round(FParticles[i].X);
    Y := CenterY + Round(FParticles[i].Y);
    Size := Round(FParticles[i].Size);

    if Size > 0 then
    begin
      DrawGlow(Canvas, X, Y, Size, FParticles[i].Color, FParticles[i].Alpha);
    end;
  end;
end;

procedure TParticleSystem.RenderMagicParticles(Canvas: TCanvas; CenterX, CenterY: Integer);
var
  i: Integer;
  X, Y, Size: Integer;
begin
  Canvas.Pen.Style := psClear;

  for i := 0 to FParticleCount - 1 do
  begin
    if FParticles[i].Life <= 0 then Continue;

    X := CenterX + Round(FParticles[i].X);
    Y := CenterY + Round(FParticles[i].Y);
    Size := Round(FParticles[i].Size);

    if Size > 0 then
    begin
      DrawGlow(Canvas, X, Y, Size, FParticles[i].Color, FParticles[i].Alpha);

      // Simple star sparkle
      Canvas.Pen.Color := RGB(255, 255, 255);
      Canvas.Pen.Style := psSolid;
      Canvas.Pen.Width := 2;
      Canvas.MoveTo(X - Size - 2, Y);
      Canvas.LineTo(X + Size + 2, Y);
      Canvas.MoveTo(X, Y - Size - 2);
      Canvas.LineTo(X, Y + Size + 2);
    end;
  end;
end;

procedure TParticleSystem.RenderExplosionParticles(Canvas: TCanvas; CenterX, CenterY: Integer);
var
  i: Integer;
  X, Y, Size: Integer;
begin
  for i := 0 to FParticleCount - 1 do
  begin
    if FParticles[i].Life <= 0 then Continue;

    X := CenterX + Round(FParticles[i].X);
    Y := CenterY + Round(FParticles[i].Y);
    Size := Round(FParticles[i].Size);

    if Size > 0 then
    begin
      DrawGlow(Canvas, X, Y, Size, FParticles[i].Color, FParticles[i].Alpha);
    end;
  end;
end;

procedure TParticleSystem.RenderSparksParticles(Canvas: TCanvas; CenterX, CenterY: Integer);
var
  i: Integer;
  X, Y, Size: Integer;
begin
  Canvas.Pen.Style := psClear;

  for i := 0 to FParticleCount - 1 do
  begin
    if FParticles[i].Life <= 0 then Continue;

    X := CenterX + Round(FParticles[i].X);
    Y := CenterY + Round(FParticles[i].Y);
    Size := Round(FParticles[i].Size);

    if Size > 0 then
    begin
      DrawGlow(Canvas, X, Y, Size, FParticles[i].Color, FParticles[i].Alpha);
    end;
  end;

  // Simple electric lines
  Canvas.Pen.Style := psSolid;
  Canvas.Pen.Width := 2;
  Canvas.Pen.Color := RGB(255, 255, 200);
  for i := 0 to Min(7, FParticleCount - 1) do
  begin
    if FParticles[i].Life <= 0 then Continue;
    X := CenterX + Round(FParticles[i].X);
    Y := CenterY + Round(FParticles[i].Y);
    Canvas.MoveTo(CenterX, CenterY);
    Canvas.LineTo(X, Y);
  end;
end;

procedure TParticleSystem.RenderMatrixParticles(Canvas: TCanvas; CenterX, CenterY: Integer);
var
  i: Integer;
  X, Y: Integer;
  Ch: Char;
  TextSize: Integer;
begin
  Canvas.Brush.Style := bsClear;
  Canvas.Font.Name := 'Courier New';
  Canvas.Font.Style := [fsBold];

  for i := 0 to FParticleCount - 1 do
  begin
    if FParticles[i].Life <= 0 then Continue;

    X := CenterX + Round(FParticles[i].X);
    Y := CenterY + Round(FParticles[i].Y);
    TextSize := Round(FParticles[i].Size);

    Canvas.Font.Size := Max(8, TextSize);
    Canvas.Font.Color := RGB(0, Round(180 + 75 * FParticles[i].Life), 0);

    // Character selection
    if (GetTickCount + i * 100) mod 500 < 250 then
      Ch := Chr(Ord('A') + Round(FParticles[i].Data1))
    else
      Ch := Chr(Ord('0') + Round(FParticles[i].Data2));

    Canvas.TextOut(X, Y, Ch);
  end;
end;

procedure TParticleSystem.RenderRainbowParticles(Canvas: TCanvas; CenterX, CenterY: Integer);
var
  i: Integer;
  X, Y, Size: Integer;
begin
  for i := 0 to FParticleCount - 1 do
  begin
    if FParticles[i].Life <= 0 then Continue;

    X := CenterX + Round(FParticles[i].X);
    Y := CenterY + Round(FParticles[i].Y);
    Size := Round(FParticles[i].Size);

    if Size > 0 then
    begin
      DrawGlow(Canvas, X, Y, Size, FParticles[i].Color, FParticles[i].Alpha);
    end;
  end;
end;

// NEW RENDER METHODS - Following same patterns

procedure TParticleSystem.RenderIceParticles(Canvas: TCanvas; CenterX, CenterY: Integer);
var
  i: Integer;
  X, Y, Size: Integer;
begin
  Canvas.Pen.Style := psClear;

  for i := 0 to FParticleCount - 1 do
  begin
    if FParticles[i].Life <= 0 then Continue;

    X := CenterX + Round(FParticles[i].X);
    Y := CenterY + Round(FParticles[i].Y);
    Size := Round(FParticles[i].Size);

    if Size > 0 then
    begin
      DrawGlow(Canvas, X, Y, Size, FParticles[i].Color, FParticles[i].Alpha);

      // Crystal sparkle effect
      Canvas.Pen.Color := RGB(255, 255, 255);
      Canvas.Pen.Style := psSolid;
      Canvas.Pen.Width := 1;
      Canvas.MoveTo(X - Size, Y);
      Canvas.LineTo(X + Size, Y);
      Canvas.MoveTo(X, Y - Size);
      Canvas.LineTo(X, Y + Size);
    end;
  end;
end;

procedure TParticleSystem.RenderFlameParticles(Canvas: TCanvas; CenterX, CenterY: Integer);
var
  i: Integer;
  X, Y, Size: Integer;
begin
  Canvas.Pen.Style := psClear;

  for i := 0 to FParticleCount - 1 do
  begin
    if FParticles[i].Life <= 0 then Continue;

    X := CenterX + Round(FParticles[i].X);
    Y := CenterY + Round(FParticles[i].Y);
    Size := Round(FParticles[i].Size);

    if Size > 0 then
    begin
      DrawGlow(Canvas, X, Y, Size, FParticles[i].Color, FParticles[i].Alpha * 0.8);
    end;
  end;
end;

procedure TParticleSystem.RenderStarsParticles(Canvas: TCanvas; CenterX, CenterY: Integer);
var
  i: Integer;
  X, Y, Size: Integer;
begin
  Canvas.Pen.Style := psClear;

  for i := 0 to FParticleCount - 1 do
  begin
    if FParticles[i].Life <= 0 then Continue;

    X := CenterX + Round(FParticles[i].X);
    Y := CenterY + Round(FParticles[i].Y);
    Size := Round(FParticles[i].Size);

    if Size > 0 then
    begin
      DrawGlow(Canvas, X, Y, Size, FParticles[i].Color, FParticles[i].Alpha);

      // Star points
      Canvas.Pen.Color := RGB(255, 255, 255);
      Canvas.Pen.Style := psSolid;
      Canvas.Pen.Width := 2;
      Canvas.MoveTo(X - Size - 3, Y);
      Canvas.LineTo(X + Size + 3, Y);
      Canvas.MoveTo(X, Y - Size - 3);
      Canvas.LineTo(X, Y + Size + 3);
      Canvas.MoveTo(X - Size - 2, Y - Size - 2);
      Canvas.LineTo(X + Size + 2, Y + Size + 2);
      Canvas.MoveTo(X + Size + 2, Y - Size - 2);
      Canvas.LineTo(X - Size - 2, Y + Size + 2);
    end;
  end;
end;

procedure TParticleSystem.RenderSmokeParticles(Canvas: TCanvas; CenterX, CenterY: Integer);
var
  i: Integer;
  X, Y, Size: Integer;
begin
  Canvas.Pen.Style := psClear;

  for i := 0 to FParticleCount - 1 do
  begin
    if FParticles[i].Life <= 0 then Continue;

    X := CenterX + Round(FParticles[i].X);
    Y := CenterY + Round(FParticles[i].Y);
    Size := Round(FParticles[i].Size);

    if Size > 0 then
    begin
      // Softer rendering for smoke
      Canvas.Brush.Color := BlendColor(clBlack, FParticles[i].Color, FParticles[i].Alpha * 0.3);
      Canvas.Brush.Style := bsSolid;
      Canvas.Ellipse(X - Size, Y - Size, X + Size, Y + Size);
    end;
  end;
end;

procedure TParticleSystem.RenderNeonParticles(Canvas: TCanvas; CenterX, CenterY: Integer);
var
  i: Integer;
  X, Y, Size: Integer;
begin
  Canvas.Pen.Style := psClear;

  for i := 0 to FParticleCount - 1 do
  begin
    if FParticles[i].Life <= 0 then Continue;

    X := CenterX + Round(FParticles[i].X);
    Y := CenterY + Round(FParticles[i].Y);
    Size := Round(FParticles[i].Size);

    if Size > 0 then
    begin
      DrawGlow(Canvas, X, Y, Size, FParticles[i].Color, FParticles[i].Alpha);
    end;
  end;
end;

procedure TParticleSystem.RenderPlasmaParticles(Canvas: TCanvas; CenterX, CenterY: Integer);
var
  i: Integer;
  X, Y, Size: Integer;
begin
  Canvas.Pen.Style := psClear;

  for i := 0 to FParticleCount - 1 do
  begin
    if FParticles[i].Life <= 0 then Continue;

    X := CenterX + Round(FParticles[i].X);
    Y := CenterY + Round(FParticles[i].Y);
    Size := Round(FParticles[i].Size);

    if Size > 0 then
    begin
      DrawGlow(Canvas, X, Y, Size, FParticles[i].Color, FParticles[i].Alpha);
    end;
  end;
end;

procedure TParticleSystem.RenderWindParticles(Canvas: TCanvas; CenterX, CenterY: Integer);
var
  i: Integer;
  X, Y, Size: Integer;
begin
  Canvas.Pen.Style := psClear;

  for i := 0 to FParticleCount - 1 do
  begin
    if FParticles[i].Life <= 0 then Continue;

    X := CenterX + Round(FParticles[i].X);
    Y := CenterY + Round(FParticles[i].Y);
    Size := Round(FParticles[i].Size);

    if Size > 0 then
    begin
      // Streaky wind effect
      Canvas.Brush.Color := BlendColor(clBlack, FParticles[i].Color, FParticles[i].Alpha * 0.6);
      Canvas.Brush.Style := bsSolid;
      Canvas.Ellipse(X - Size * 2, Y - Size div 2, X + Size * 2, Y + Size div 2);
    end;
  end;
end;

procedure TParticleSystem.RenderGoldParticles(Canvas: TCanvas; CenterX, CenterY: Integer);
var
  i: Integer;
  X, Y, Size: Integer;
begin
  Canvas.Pen.Style := psClear;

  for i := 0 to FParticleCount - 1 do
  begin
    if FParticles[i].Life <= 0 then Continue;

    X := CenterX + Round(FParticles[i].X);
    Y := CenterY + Round(FParticles[i].Y);
    Size := Round(FParticles[i].Size);

    if Size > 0 then
    begin
      DrawGlow(Canvas, X, Y, Size, FParticles[i].Color, FParticles[i].Alpha);
    end;
  end;
end;

procedure TParticleSystem.RenderLaserParticles(Canvas: TCanvas; CenterX, CenterY: Integer);
var
  i: Integer;
  X, Y: Integer;
begin
  Canvas.Pen.Style := psSolid;
  Canvas.Pen.Width := 3;
  Canvas.Pen.Color := RGB(255, 0, 0);

  for i := 0 to FParticleCount - 1 do
  begin
    if FParticles[i].Life <= 0 then Continue;

    X := CenterX + Round(FParticles[i].X);
    Y := CenterY + Round(FParticles[i].Y);

    // Draw laser beam
    Canvas.MoveTo(CenterX, CenterY);
    Canvas.LineTo(X, Y);

    // Draw end glow
    Canvas.Pen.Style := psClear;
    Canvas.Brush.Color := RGB(255, 100, 100);
    Canvas.Brush.Style := bsSolid;
    Canvas.Ellipse(X - 2, Y - 2, X + 2, Y + 2);
    Canvas.Pen.Style := psSolid;
  end;
end;

procedure TParticleSystem.RenderCrystalParticles(Canvas: TCanvas; CenterX, CenterY: Integer);
var
  i: Integer;
  X, Y, Size: Integer;
begin
  Canvas.Pen.Style := psClear;

  for i := 0 to FParticleCount - 1 do
  begin
    if FParticles[i].Life <= 0 then Continue;

    X := CenterX + Round(FParticles[i].X);
    Y := CenterY + Round(FParticles[i].Y);
    Size := Round(FParticles[i].Size);

    if Size > 0 then
    begin
      DrawGlow(Canvas, X, Y, Size, FParticles[i].Color, FParticles[i].Alpha);

      // Crystal facets
      Canvas.Pen.Color := RGB(255, 255, 255);
      Canvas.Pen.Style := psSolid;
      Canvas.Pen.Width := 1;
      Canvas.MoveTo(X - Size, Y - Size);
      Canvas.LineTo(X + Size, Y + Size);
      Canvas.MoveTo(X + Size, Y - Size);
      Canvas.LineTo(X - Size, Y + Size);
    end;
  end;
end;

procedure TParticleSystem.Update(DeltaTime: Double);
begin
  case FAnimationType of
    atFire: UpdateFireParticles(DeltaTime);
    atLightning: UpdateLightningParticles(DeltaTime);
    atMagic: UpdateMagicParticles(DeltaTime);
    atExplosion: UpdateExplosionParticles(DeltaTime);
    atSparks: UpdateSparksParticles(DeltaTime);
    atMatrix: UpdateMatrixParticles(DeltaTime);
    atRainbow: UpdateRainbowParticles(DeltaTime);
    // NEW ANIMATIONS
    atIce: UpdateIceParticles(DeltaTime);
    atFlame: UpdateFlameParticles(DeltaTime);
    atStars: UpdateStarsParticles(DeltaTime);
    atSmoke: UpdateSmokeParticles(DeltaTime);
    atNeon: UpdateNeonParticles(DeltaTime);
    atPlasma: UpdatePlasmaParticles(DeltaTime);
    atWind: UpdateWindParticles(DeltaTime);
    atGold: UpdateGoldParticles(DeltaTime);
    atLaser: UpdateLaserParticles(DeltaTime);
    atCrystal: UpdateCrystalParticles(DeltaTime);
  end;
end;

procedure TParticleSystem.Render(Canvas: TCanvas; CenterX, CenterY: Integer);
begin
  case FAnimationType of
    atFire: RenderFireParticles(Canvas, CenterX, CenterY);
    atLightning: RenderLightningParticles(Canvas, CenterX, CenterY);
    atMagic: RenderMagicParticles(Canvas, CenterX, CenterY);
    atExplosion: RenderExplosionParticles(Canvas, CenterX, CenterY);
    atSparks: RenderSparksParticles(Canvas, CenterX, CenterY);
    atMatrix: RenderMatrixParticles(Canvas, CenterX, CenterY);
    atRainbow: RenderRainbowParticles(Canvas, CenterX, CenterY);
    // NEW ANIMATIONS
  atIce: RenderIceParticles(Canvas, CenterX, CenterY);
   atFlame: RenderFlameParticles(Canvas, CenterX, CenterY);
   atStars: RenderStarsParticles(Canvas, CenterX, CenterY);
   atSmoke: RenderSmokeParticles(Canvas, CenterX, CenterY);
   atNeon: RenderNeonParticles(Canvas, CenterX, CenterY);
   atPlasma: RenderPlasmaParticles(Canvas, CenterX, CenterY);
   atWind: RenderWindParticles(Canvas, CenterX, CenterY);
   atGold: RenderGoldParticles(Canvas, CenterX, CenterY);
   atLaser: RenderLaserParticles(Canvas, CenterX, CenterY);
   atCrystal: RenderCrystalParticles(Canvas, CenterX, CenterY);
 end;
end;

function TParticleSystem.IsAlive: Boolean;
var
 i: Integer;
begin
 Result := False;
 for i := 0 to FParticleCount - 1 do
 begin
   if FParticles[i].Life > 0 then
   begin
     Result := True;
     Exit;
   end;
 end;
end;

end.
