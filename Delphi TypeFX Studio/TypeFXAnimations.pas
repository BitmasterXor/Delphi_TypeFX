unit TypeFXAnimations;

interface

uses
  Windows, SysUtils, Classes, Graphics, Types, Math, MMSystem;

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

  // Sound settings for different key types
  TSoundSettings = record
    BasicKeySound: string;       // WAV file for normal key presses
    EnterKeySound: string;       // WAV file for Enter/Return key
    BackspaceSound: string;      // WAV file for Backspace key
    EnableSounds: Boolean;       // Master sound enable/disable
    SoundVolume: Integer;        // Volume level 0-100
  end;

  // Main configuration record - UPDATED with sound support
  TTypeFXConfig = record
    EffectStyle: TEffectStyle;
    TriggerFrequency: TTriggerFrequency;
    AnimationSpeed: Integer;     // 10-200ms
    Duration: Integer;           // 500-3000ms
    ShowOnDelete: Boolean;
    Intensity: Integer;          // 1-10 (affects size/opacity)
    RandomOffset: Boolean;       // Add random positioning
    SoundSettings: TSoundSettings; // NEW: Sound configuration
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



// BULLETPROOF sound manager - fire and forget approach
TSoundManager = class
private
  FMasterVolume: Integer;
  FEnabled: Boolean;
  // REMOVED: FLastSoundTime, FMinSoundInterval, FSoundChannels, FCurrentChannel, etc.

  class var FInstance: TSoundManager;

public
  constructor Create;
  destructor Destroy; override;

  class function GetInstance: TSoundManager;
  class procedure FreeInstance;

  procedure PlaySound(const FileName: string; Volume: Integer = 100);
  procedure PlayBasicKeySound(const Config: TTypeFXConfig);
  procedure PlayEnterKeySound(const Config: TTypeFXConfig);
  procedure PlayBackspaceSound(const Config: TTypeFXConfig);

  procedure SetMasterVolume(Volume: Integer);
  procedure SetEnabled(Enabled: Boolean);
  procedure EmergencyShutdown;

  property MasterVolume: Integer read FMasterVolume write SetMasterVolume;
  property Enabled: Boolean read FEnabled write SetEnabled;
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

  // NEW: Default sound settings
  Result.SoundSettings.BasicKeySound := '';
  Result.SoundSettings.EnterKeySound := '';
  Result.SoundSettings.BackspaceSound := '';
  Result.SoundSettings.EnableSounds := False;
  Result.SoundSettings.SoundVolume := 75;
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

{ TSoundChannel - BULLETPROOF Implementation }



{ TSoundManager - BULLETPROOF Implementation }

constructor TSoundManager.Create;
begin
  inherited Create;
  FMasterVolume := 100;
  FEnabled := True;
  // NO MORE CHANNELS, NO MORE VARIABLES, NO MORE BULLSHIT
end;

destructor TSoundManager.Destroy;
begin
  inherited Destroy;
end;

class function TSoundManager.GetInstance: TSoundManager;
begin
  if not Assigned(FInstance) then
    FInstance := TSoundManager.Create;
  Result := FInstance;
end;

class procedure TSoundManager.FreeInstance;
begin
  if Assigned(FInstance) then
  begin
    FInstance.Free;
    FInstance := nil;
  end;
end;

procedure TSoundManager.SetMasterVolume(Volume: Integer);
begin
  FMasterVolume := Max(0, Min(100, Volume));
end;

procedure TSoundManager.SetEnabled(Enabled: Boolean);
begin
  FEnabled := Enabled;
end;

procedure TSoundManager.EmergencyShutdown;
begin
  // Do nothing - let Windows handle it
end;


procedure TSoundManager.PlaySound(const FileName: string; Volume: Integer = 100);
begin
  if not FEnabled then Exit;
  if not FileExists(FileName) then Exit;

  // FUCK PlaySound - Use sndPlaySound which ACTUALLY supports overlapping
  TThread.CreateAnonymousThread(
    procedure
    begin
      try
        // sndPlaySound with SND_NOSTOP actually works for overlapping
        sndPlaySound(PChar(FileName), SND_FILENAME or SND_ASYNC);
      except
        // Fallback to MMSystem if sndPlaySound not available
        try
          MMSystem.PlaySound(PChar(FileName), 0, SND_FILENAME or SND_ASYNC or SND_NOSTOP);
        except
          // Ignore all errors
        end;
      end;
    end
  ).Start;
end;


procedure TSoundManager.PlayBasicKeySound(const Config: TTypeFXConfig);
begin
  if Config.SoundSettings.EnableSounds and (Trim(Config.SoundSettings.BasicKeySound) <> '') then
    PlaySound(Config.SoundSettings.BasicKeySound, Config.SoundSettings.SoundVolume);
end;

procedure TSoundManager.PlayEnterKeySound(const Config: TTypeFXConfig);
begin
  if Config.SoundSettings.EnableSounds and (Trim(Config.SoundSettings.EnterKeySound) <> '') then
    PlaySound(Config.SoundSettings.EnterKeySound, Config.SoundSettings.SoundVolume);
end;

procedure TSoundManager.PlayBackspaceSound(const Config: TTypeFXConfig);
begin
  if Config.SoundSettings.EnableSounds and (Trim(Config.SoundSettings.BackspaceSound) <> '') then
    PlaySound(Config.SoundSettings.BackspaceSound, Config.SoundSettings.SoundVolume);
end;

{ TParticleSystem }

constructor TParticleSystem.Create(AAnimationType: TAnimationType; AIntensity: Integer; ADuration: Integer);
begin
  inherited Create;
  FAnimationType := AAnimationType;
  FIntensity := AIntensity;
  FDuration := ADuration;
  FStartTime := GetTickCount;

  FMaxParticles := 12 + (FIntensity * 3);
  SetLength(FParticles, FMaxParticles);
  FParticleCount := FMaxParticles;

  case FAnimationType of
    atFire: InitializeFireParticles;
    atLightning: InitializeLightningParticles;
    atMagic: InitializeMagicParticles;
    atExplosion: InitializeExplosionParticles;
    atSparks: InitializeSparksParticles;
    atMatrix: InitializeMatrixParticles;
    atRainbow: InitializeRainbowParticles;
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

  for i := 3 downto 1 do
  begin
    GlowSize := Size * i;
    Alpha := Intensity / (i * 2);
    Canvas.Brush.Color := BlendColor(clBlack, Color, Alpha);
    Canvas.Ellipse(X - GlowSize, Y - GlowSize, X + GlowSize, Y + GlowSize);
  end;

  Canvas.Brush.Color := Color;
  Canvas.Ellipse(X - Size, Y - Size, X + Size, Y + Size);
end;

// PARTICLE INITIALIZATIONS

procedure TParticleSystem.InitializeFireParticles;
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
    FParticles[i].Color := RGB(255, 255, 255);
  end;
end;

procedure TParticleSystem.InitializeLightningParticles;
var
  i: Integer;
begin
  for i := 0 to FParticleCount - 1 do
  begin
    FParticles[i].X := RandomFloat(-8, 8);
    FParticles[i].Y := RandomFloat(-8, 8);
    FParticles[i].VelX := 0;
    FParticles[i].VelY := 0;
    FParticles[i].Life := 1.0;
    FParticles[i].MaxLife := RandomFloat(0.4, 0.8);
    FParticles[i].Size := RandomFloat(2, 5) * (FIntensity / 5.0);
    FParticles[i].Alpha := 1.0;
    FParticles[i].Color := RGB(220 + Random(36), 220 + Random(36), 255);
    FParticles[i].Phase := RandomFloat(0, 2 * PI);
  end;
end;

procedure TParticleSystem.InitializeMagicParticles;
var
  i: Integer;
  Angle, Radius: Double;
begin
  for i := 0 to FParticleCount - 1 do
  begin
    Angle := (i / FParticleCount) * 2 * PI + RandomFloat(-0.2, 0.2);
    Radius := RandomFloat(6, 12);

    FParticles[i].X := Cos(Angle) * Radius;
    FParticles[i].Y := Sin(Angle) * Radius;
    FParticles[i].VelX := 0;
    FParticles[i].VelY := 0;
    FParticles[i].Life := 1.0;
    FParticles[i].MaxLife := RandomFloat(0.8, 1.4);
    FParticles[i].Size := RandomFloat(2, 5) * (FIntensity / 5.0);
    FParticles[i].InitialSize := FParticles[i].Size;
    FParticles[i].Alpha := 1.0;
    FParticles[i].Angle := Angle;
    FParticles[i].AngularVel := RandomFloat(3, 6);
    FParticles[i].Phase := RandomFloat(0, 2 * PI);
    FParticles[i].Data1 := Radius;
    FParticles[i].Color := HSVtoRGB(Round(RandomFloat(240, 330)), 255, 255);
  end;
end;

procedure TParticleSystem.InitializeExplosionParticles;
var
  i: Integer;
  Angle, Speed: Double;
begin
  for i := 0 to FParticleCount - 1 do
  begin
    Angle := RandomFloat(0, 2 * PI);
    Speed := RandomFloat(20, 50);

    FParticles[i].X := RandomFloat(-3, 3);
    FParticles[i].Y := RandomFloat(-3, 3);
    FParticles[i].VelX := Cos(Angle) * Speed;
    FParticles[i].VelY := Sin(Angle) * Speed;
    FParticles[i].AccX := -FParticles[i].VelX * 1.2;
    FParticles[i].AccY := -FParticles[i].VelY * 1.2 + 30;
    FParticles[i].Life := 1.0;
    FParticles[i].MaxLife := RandomFloat(0.8, 1.4);
    FParticles[i].Size := RandomFloat(3, 8) * (FIntensity / 5.0);
    FParticles[i].InitialSize := FParticles[i].Size;
    FParticles[i].Alpha := 1.0;

    if i < FParticleCount div 4 then
      FParticles[i].Color := RGB(255, 255, 200)
    else if i < FParticleCount div 2 then
      FParticles[i].Color := RGB(255, 180, 0)
    else
      FParticles[i].Color := RGB(255, 80, 0);
  end;
end;

procedure TParticleSystem.InitializeSparksParticles;
var
  i: Integer;
  Angle, Speed: Double;
begin
  for i := 0 to FParticleCount - 1 do
  begin
    Angle := (i / FParticleCount) * 2 * PI + RandomFloat(-0.3, 0.3);
    Speed := RandomFloat(20, 40);

    FParticles[i].X := 0;
    FParticles[i].Y := 0;
    FParticles[i].VelX := Cos(Angle) * Speed;
    FParticles[i].VelY := Sin(Angle) * Speed;
    FParticles[i].AccX := -FParticles[i].VelX * 2;
    FParticles[i].AccY := -FParticles[i].VelY * 2;
    FParticles[i].Life := 1.0;
    FParticles[i].MaxLife := RandomFloat(0.8, 1.2);
    FParticles[i].Size := RandomFloat(2, 5) * (FIntensity / 5.0);
    FParticles[i].Alpha := 1.0;
    FParticles[i].Color := RGB(255, 255, 150 + Random(106));
    FParticles[i].Phase := RandomFloat(0, 2 * PI);
  end;
end;

procedure TParticleSystem.InitializeMatrixParticles;
var
  i: Integer;
begin
  for i := 0 to FParticleCount - 1 do
  begin
    FParticles[i].X := RandomFloat(-8, 8);
    FParticles[i].Y := RandomFloat(-12, -8);
    FParticles[i].VelX := 0;
    FParticles[i].VelY := RandomFloat(30, 50);
    FParticles[i].Life := 1.0;
    FParticles[i].MaxLife := RandomFloat(0.8, 1.4);
    FParticles[i].Size := RandomFloat(8, 12) * (FIntensity / 5.0);
    FParticles[i].Alpha := 1.0;
    FParticles[i].Color := RGB(0, 255, 0);
    FParticles[i].Data1 := Random(26);
    FParticles[i].Data2 := Random(10);
  end;
end;

procedure TParticleSystem.InitializeRainbowParticles;
var
  i: Integer;
  Angle: Double;
begin
  for i := 0 to FParticleCount - 1 do
  begin
    Angle := (i / FParticleCount) * 2 * PI;

    FParticles[i].X := Cos(Angle) * 8;
    FParticles[i].Y := Sin(Angle) * 8;
    FParticles[i].VelX := Cos(Angle + PI/2) * 20;
    FParticles[i].VelY := Sin(Angle + PI/2) * 20;
    FParticles[i].Life := 1.0;
    FParticles[i].MaxLife := RandomFloat(0.8, 1.4);
    FParticles[i].Size := RandomFloat(3, 6) * (FIntensity / 5.0);
    FParticles[i].InitialSize := FParticles[i].Size;
    FParticles[i].Alpha := 1.0;
    FParticles[i].Angle := Angle;
    FParticles[i].AngularVel := 3.0;
    FParticles[i].Phase := (i / FParticleCount) * 360;
    FParticles[i].Color := HSVtoRGB(Round(FParticles[i].Phase), 255, 255);
  end;
end;

procedure TParticleSystem.InitializeIceParticles;
var
  i: Integer;
  Angle, Speed: Double;
begin
  for i := 0 to FParticleCount - 1 do
  begin
    Angle := RandomFloat(-PI/6, PI/6);
    Speed := RandomFloat(15, 35);

    FParticles[i].X := RandomFloat(-8, 8);
    FParticles[i].Y := RandomFloat(-12, -8);
    FParticles[i].VelX := Sin(Angle) * Speed * 0.3;
    FParticles[i].VelY := Cos(Angle) * Speed;
    FParticles[i].AccX := RandomFloat(-8, 8);
    FParticles[i].AccY := 15;
    FParticles[i].Life := 1.0;
    FParticles[i].MaxLife := RandomFloat(1.0, 1.6);
    FParticles[i].Size := RandomFloat(2, 6) * (FIntensity / 5.0);
    FParticles[i].InitialSize := FParticles[i].Size;
    FParticles[i].Alpha := 1.0;
    FParticles[i].Angle := RandomFloat(0, 2 * PI);
    FParticles[i].AngularVel := RandomFloat(-4, 4);
    FParticles[i].Phase := RandomFloat(0, 2 * PI);
    FParticles[i].Color := RGB(200 + Random(56), 230 + Random(26), 255);
  end;
end;

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
    FParticles[i].Color := RGB(100 + Random(56), 150 + Random(106), 255);
  end;
end;

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
    FParticles[i].Color := RGB(255, 255, 200 + Random(56));
  end;
end;

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
    FParticles[i].AccY := -20;
    FParticles[i].Life := 1.0;
    FParticles[i].MaxLife := RandomFloat(1.2, 2.0);
    FParticles[i].Size := RandomFloat(4, 10) * (FIntensity / 5.0);
    FParticles[i].InitialSize := FParticles[i].Size;
    FParticles[i].Alpha := 0.6;
    FParticles[i].Angle := RandomFloat(0, 2 * PI);
    FParticles[i].AngularVel := RandomFloat(-2, 2);
    FParticles[i].Phase := RandomFloat(0, 2 * PI);
    FParticles[i].Color := RGB(120 + Random(86), 120 + Random(86), 130 + Random(76));
  end;
end;

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

    if i mod 2 = 0 then
      FParticles[i].Color := RGB(0, 255, 255)
    else
      FParticles[i].Color := RGB(255, 0, 255);
  end;
end;

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
    FParticles[i].AccX := -FParticles[i].X * 15;
    FParticles[i].AccY := -FParticles[i].Y * 15;
    FParticles[i].Life := 1.0;
    FParticles[i].MaxLife := RandomFloat(0.6, 1.0);
    FParticles[i].Size := RandomFloat(2, 6) * (FIntensity / 5.0);
    FParticles[i].InitialSize := FParticles[i].Size;
    FParticles[i].Alpha := 1.0;
    FParticles[i].Angle := Angle;
    FParticles[i].AngularVel := RandomFloat(-10, 10);
    FParticles[i].Phase := RandomFloat(0, 2 * PI);
    FParticles[i].Color := RGB(128 + Random(128), 0, 200 + Random(56));
  end;
end;

procedure TParticleSystem.InitializeWindParticles;
var
  i: Integer;
  Speed: Double;
begin
  for i := 0 to FParticleCount - 1 do
  begin
    Speed := RandomFloat(30, 60);

    FParticles[i].X := RandomFloat(-12, -8);
    FParticles[i].Y := RandomFloat(-6, 6);
    FParticles[i].VelX := Speed;
    FParticles[i].VelY := RandomFloat(-10, 10);
    FParticles[i].AccX := -10;
    FParticles[i].AccY := RandomFloat(-5, 5);
    FParticles[i].Life := 1.0;
    FParticles[i].MaxLife := RandomFloat(0.8, 1.2);
    FParticles[i].Size := RandomFloat(2, 5) * (FIntensity / 5.0);
    FParticles[i].InitialSize := FParticles[i].Size;
    FParticles[i].Alpha := 0.8;
    FParticles[i].Angle := RandomFloat(0, 2 * PI);
    FParticles[i].AngularVel := RandomFloat(-8, 8);
    FParticles[i].Phase := RandomFloat(0, 2 * PI);
    FParticles[i].Color := RGB(220 + Random(36), 240 + Random(16), 255);
  end;
end;

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
    FParticles[i].AccY := 25;
    FParticles[i].Life := 1.0;
    FParticles[i].MaxLife := RandomFloat(1.0, 1.6);
    FParticles[i].Size := RandomFloat(2, 6) * (FIntensity / 5.0);
    FParticles[i].InitialSize := FParticles[i].Size;
    FParticles[i].Alpha := 1.0;
    FParticles[i].Angle := RandomFloat(0, 2 * PI);
    FParticles[i].AngularVel := RandomFloat(-6, 6);
    FParticles[i].Phase := RandomFloat(0, 2 * PI);
    FParticles[i].Color := RGB(255, 180 + Random(76), 0);
  end;
end;

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
    FParticles[i].Data1 := Speed;
    FParticles[i].Color := RGB(255, 0, 0);
  end;
end;

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

    case i mod 7 of
      0: FParticles[i].Color := RGB(255, 200, 200);
      1: FParticles[i].Color := RGB(200, 255, 200);
      2: FParticles[i].Color := RGB(200, 200, 255);
      3: FParticles[i].Color := RGB(255, 255, 200);
      4: FParticles[i].Color := RGB(255, 200, 255);
      5: FParticles[i].Color := RGB(200, 255, 255);
      else FParticles[i].Color := RGB(255, 255, 255);
    end;
  end;
end;

// UPDATE METHODS

procedure TParticleSystem.UpdateFireParticles(DeltaTime: Double);
var
  i: Integer;
  LifeRatio, Temp: Double;
begin
  for i := 0 to FParticleCount - 1 do
  begin
    if FParticles[i].Life <= 0 then Continue;

    FParticles[i].VelX := FParticles[i].VelX + FParticles[i].AccX * DeltaTime;
    FParticles[i].VelY := FParticles[i].VelY + FParticles[i].AccY * DeltaTime;
    FParticles[i].X := FParticles[i].X + FParticles[i].VelX * DeltaTime;
    FParticles[i].Y := FParticles[i].Y + FParticles[i].VelY * DeltaTime;
    FParticles[i].Angle := FParticles[i].Angle + FParticles[i].AngularVel * DeltaTime;

    FParticles[i].Life := FParticles[i].Life - (DeltaTime / FParticles[i].MaxLife);
    LifeRatio := FParticles[i].Life;

    if LifeRatio > 0.7 then
      FParticles[i].Size := FParticles[i].InitialSize * (1 + (1 - LifeRatio) * 0.8)
    else
      FParticles[i].Size := FParticles[i].InitialSize * LifeRatio * 1.8;

    FParticles[i].Alpha := SmoothStep(0, 0.4, LifeRatio);

    Temp := LifeRatio;
    if Temp > 0.85 then
      FParticles[i].Color := RGB(255, 255, 255)
    else if Temp > 0.7 then
      FParticles[i].Color := RGB(255, 255, Round(150 + 105 * (Temp - 0.7) * 6.67))
    else if Temp > 0.5 then
      FParticles[i].Color := RGB(255, Round(180 + 75 * (Temp - 0.5) * 5), 0)
    else if Temp > 0.3 then
      FParticles[i].Color := RGB(255, Round(80 + 100 * (Temp - 0.3) * 5), 0)
    else if Temp > 0.1 then
      FParticles[i].Color := RGB(Round(200 + 55 * (Temp - 0.1) * 5), 0, 0)
    else
      FParticles[i].Color := RGB(Round(100 + 100 * Temp * 10), 0, 0);
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

    FParticles[i].Angle := FParticles[i].Angle + FParticles[i].AngularVel * DeltaTime;
    Radius := FParticles[i].Data1 * LifeRatio;

    FParticles[i].X := Cos(FParticles[i].Angle) * Radius;
    FParticles[i].Y := Sin(FParticles[i].Angle) * Radius * 0.7;

    FParticles[i].Size := FParticles[i].InitialSize * LifeRatio;
    FParticles[i].Alpha := SmoothStep(0, 0.3, LifeRatio);

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

    FParticles[i].VelX := FParticles[i].VelX + FParticles[i].AccX * DeltaTime;
    FParticles[i].VelY := FParticles[i].VelY + FParticles[i].AccY * DeltaTime;
    FParticles[i].X := FParticles[i].X + FParticles[i].VelX * DeltaTime;
    FParticles[i].Y := FParticles[i].Y + FParticles[i].VelY * DeltaTime;

    FParticles[i].Life := FParticles[i].Life - (DeltaTime / FParticles[i].MaxLife);
    LifeRatio := FParticles[i].Life;

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

    FParticles[i].VelX := FParticles[i].VelX + FParticles[i].AccX * DeltaTime;
    FParticles[i].VelY := FParticles[i].VelY + FParticles[i].AccY * DeltaTime;
    FParticles[i].X := FParticles[i].X + FParticles[i].VelX * DeltaTime;
    FParticles[i].Y := FParticles[i].Y + FParticles[i].VelY * DeltaTime;

    FParticles[i].Life := FParticles[i].Life - (DeltaTime / FParticles[i].MaxLife);
    LifeRatio := FParticles[i].Life;

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

    FParticles[i].Y := FParticles[i].Y + FParticles[i].VelY * DeltaTime;

    FParticles[i].Life := FParticles[i].Life - (DeltaTime / FParticles[i].MaxLife);
    LifeRatio := FParticles[i].Life;

    FParticles[i].Alpha := SmoothStep(0, 0.4, LifeRatio);

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

    FParticles[i].Angle := FParticles[i].Angle + FParticles[i].AngularVel * DeltaTime;
    Radius := 8 + (1 - FParticles[i].Life) * 12;

    FParticles[i].X := Cos(FParticles[i].Angle) * Radius;
    FParticles[i].Y := Sin(FParticles[i].Angle) * Radius * 0.8;

    FParticles[i].Life := FParticles[i].Life - (DeltaTime / FParticles[i].MaxLife);
    LifeRatio := FParticles[i].Life;

    FParticles[i].Size := FParticles[i].InitialSize * LifeRatio;
    FParticles[i].Alpha := SmoothStep(0, 0.3, LifeRatio);

    FParticles[i].Phase := FParticles[i].Phase + 180 * DeltaTime;
    if FParticles[i].Phase >= 360 then
      FParticles[i].Phase := FParticles[i].Phase - 360;

    FParticles[i].Color := HSVtoRGB(Round(FParticles[i].Phase), 255, Round(220 + 35 * LifeRatio));
  end;
end;

procedure TParticleSystem.UpdateIceParticles(DeltaTime: Double);
var
  i: Integer;
  LifeRatio: Double;
begin
  for i := 0 to FParticleCount - 1 do
  begin
    if FParticles[i].Life <= 0 then Continue;

    FParticles[i].VelX := FParticles[i].VelX + FParticles[i].AccX * DeltaTime;
    FParticles[i].VelY := FParticles[i].VelY + FParticles[i].AccY * DeltaTime;
    FParticles[i].X := FParticles[i].X + FParticles[i].VelX * DeltaTime;
    FParticles[i].Y := FParticles[i].Y + FParticles[i].VelY * DeltaTime;
    FParticles[i].Angle := FParticles[i].Angle + FParticles[i].AngularVel * DeltaTime;

    FParticles[i].Life := FParticles[i].Life - (DeltaTime / FParticles[i].MaxLife);
    LifeRatio := FParticles[i].Life;

    FParticles[i].Size := FParticles[i].InitialSize * LifeRatio;
    FParticles[i].Alpha := SmoothStep(0, 0.4, LifeRatio);

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

    FParticles[i].VelX := FParticles[i].VelX + FParticles[i].AccX * DeltaTime;
    FParticles[i].VelY := FParticles[i].VelY + FParticles[i].AccY * DeltaTime;
    FParticles[i].X := FParticles[i].X + FParticles[i].VelX * DeltaTime;
    FParticles[i].Y := FParticles[i].Y + FParticles[i].VelY * DeltaTime;
    FParticles[i].Angle := FParticles[i].Angle + FParticles[i].AngularVel * DeltaTime;

    FParticles[i].Life := FParticles[i].Life - (DeltaTime / FParticles[i].MaxLife);
    LifeRatio := FParticles[i].Life;

    if LifeRatio > 0.7 then
      FParticles[i].Size := FParticles[i].InitialSize * (1 + (1 - LifeRatio) * 0.8)
    else
      FParticles[i].Size := FParticles[i].InitialSize * LifeRatio * 1.8;

    FParticles[i].Alpha := SmoothStep(0, 0.4, LifeRatio);

    Temp := LifeRatio;
    if Temp > 0.8 then
      FParticles[i].Color := RGB(200, 200, 255)
    else if Temp > 0.6 then
      FParticles[i].Color := RGB(150, 180, 255)
    else if Temp > 0.4 then
      FParticles[i].Color := RGB(100, 150, 255)
    else
      FParticles[i].Color := RGB(50, 100, 255);
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

    FParticles[i].VelX := FParticles[i].VelX + FParticles[i].AccX * DeltaTime;
    FParticles[i].VelY := FParticles[i].VelY + FParticles[i].AccY * DeltaTime;
    FParticles[i].X := FParticles[i].X + FParticles[i].VelX * DeltaTime;
    FParticles[i].Y := FParticles[i].Y + FParticles[i].VelY * DeltaTime;
    FParticles[i].Angle := FParticles[i].Angle + FParticles[i].AngularVel * DeltaTime;

    FParticles[i].Life := FParticles[i].Life - (DeltaTime / FParticles[i].MaxLife);
    LifeRatio := FParticles[i].Life;

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

    FParticles[i].VelX := FParticles[i].VelX + FParticles[i].AccX * DeltaTime;
    FParticles[i].VelY := FParticles[i].VelY + FParticles[i].AccY * DeltaTime;
    FParticles[i].X := FParticles[i].X + FParticles[i].VelX * DeltaTime;
    FParticles[i].Y := FParticles[i].Y + FParticles[i].VelY * DeltaTime;
    FParticles[i].Angle := FParticles[i].Angle + FParticles[i].AngularVel * DeltaTime;

    FParticles[i].Life := FParticles[i].Life - (DeltaTime / FParticles[i].MaxLife);
    LifeRatio := FParticles[i].Life;

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

    FParticles[i].VelX := FParticles[i].VelX + FParticles[i].AccX * DeltaTime;
    FParticles[i].VelY := FParticles[i].VelY + FParticles[i].AccY * DeltaTime;
    FParticles[i].X := FParticles[i].X + FParticles[i].VelX * DeltaTime;
    FParticles[i].Y := FParticles[i].Y + FParticles[i].VelY * DeltaTime;
    FParticles[i].Angle := FParticles[i].Angle + FParticles[i].AngularVel * DeltaTime;

    FParticles[i].Life := FParticles[i].Life - (DeltaTime / FParticles[i].MaxLife);
    LifeRatio := FParticles[i].Life;

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

    FParticles[i].VelX := FParticles[i].VelX + FParticles[i].AccX * DeltaTime;
    FParticles[i].VelY := FParticles[i].VelY + FParticles[i].AccY * DeltaTime;
    FParticles[i].X := FParticles[i].X + FParticles[i].VelX * DeltaTime;
    FParticles[i].Y := FParticles[i].Y + FParticles[i].VelY * DeltaTime;
    FParticles[i].Angle := FParticles[i].Angle + FParticles[i].AngularVel * DeltaTime;

    FParticles[i].Life := FParticles[i].Life - (DeltaTime / FParticles[i].MaxLife);
    LifeRatio := FParticles[i].Life;

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

    FParticles[i].VelX := FParticles[i].VelX + FParticles[i].AccX * DeltaTime;
    FParticles[i].VelY := FParticles[i].VelY + FParticles[i].AccY * DeltaTime;
    FParticles[i].X := FParticles[i].X + FParticles[i].VelX * DeltaTime;
    FParticles[i].Y := FParticles[i].Y + FParticles[i].VelY * DeltaTime;
    FParticles[i].Angle := FParticles[i].Angle + FParticles[i].AngularVel * DeltaTime;

    FParticles[i].Life := FParticles[i].Life - (DeltaTime / FParticles[i].MaxLife);
    LifeRatio := FParticles[i].Life;

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

    FParticles[i].X := FParticles[i].X + FParticles[i].VelX * DeltaTime;
    FParticles[i].Y := FParticles[i].Y + FParticles[i].VelY * DeltaTime;

    FParticles[i].Life := FParticles[i].Life - (DeltaTime / FParticles[i].MaxLife);
    LifeRatio := FParticles[i].Life;

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

    FParticles[i].VelX := FParticles[i].VelX + FParticles[i].AccX * DeltaTime;
    FParticles[i].VelY := FParticles[i].VelY + FParticles[i].AccY * DeltaTime;
    FParticles[i].X := FParticles[i].X + FParticles[i].VelX * DeltaTime;
    FParticles[i].Y := FParticles[i].Y + FParticles[i].VelY * DeltaTime;
    FParticles[i].Angle := FParticles[i].Angle + FParticles[i].AngularVel * DeltaTime;

    FParticles[i].Life := FParticles[i].Life - (DeltaTime / FParticles[i].MaxLife);
    LifeRatio := FParticles[i].Life;

    FParticles[i].Size := FParticles[i].InitialSize * LifeRatio;
    FParticles[i].Alpha := LifeRatio * (0.6 + 0.4 * Sin(GetTickCount * 0.012 + FParticles[i].Phase));
  end;
end;

// RENDER METHODS

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

    Canvas.MoveTo(CenterX, CenterY);
    Canvas.LineTo(X, Y);

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

initialization

finalization
  // Clean up sound manager on shutdown
  TSoundManager.FreeInstance;

end.
