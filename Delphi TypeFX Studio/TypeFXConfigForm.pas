unit TypeFXConfigForm;

interface

uses
  Windows, SysUtils, Classes, Controls, Graphics, Forms, Dialogs,
  StdCtrls, ExtCtrls, ComCtrls, Spin, Math, TypeFXAnimations, Vcl.ExtDlgs;

type
  TfrmTypeFXConfig = class(TForm)
    pnlMain: TPanel;

    // Effect Style Group
    grpEffectStyle: TGroupBox;
    lblEffectStyle: TLabel;
    cmbEffectStyle: TComboBox;
    lblEffectDescription: TLabel;

    // Trigger Settings Group
    grpTriggerSettings: TGroupBox;
    lblTriggerFrequency: TLabel;
    cmbTriggerFrequency: TComboBox;
    chkShowOnDelete: TCheckBox;
    chkRandomOffset: TCheckBox;

    // Animation Settings Group
    grpAnimationSettings: TGroupBox;
    lblAnimationSpeed: TLabel;
    trkAnimationSpeed: TTrackBar;
    lblSpeedValue: TLabel;
    lblSpeedHint: TLabel;

    lblDuration: TLabel;
    trkDuration: TTrackBar;
    lblDurationValue: TLabel;
    lblDurationHint: TLabel;

    lblIntensity: TLabel;
    trkIntensity: TTrackBar;
    lblIntensityValue: TLabel;
    lblIntensityHint: TLabel;

    // NEW: Sound Settings Group
    grpSoundSettings: TGroupBox;
    chkEnableSounds: TCheckBox;

    lblBasicKeySound: TLabel;
    edtBasicKeySound: TEdit;
    btnBrowseBasicKey: TButton;
    btnTestBasicKey: TButton;

    lblEnterKeySound: TLabel;
    edtEnterKeySound: TEdit;
    btnBrowseEnterKey: TButton;
    btnTestEnterKey: TButton;

    lblBackspaceSound: TLabel;
    edtBackspaceSound: TEdit;
    btnBrowseBackspace: TButton;
    btnTestBackspace: TButton;

    // Preview Group
    grpPreview: TGroupBox;
    pnlPreview: TPanel;
    imgPreview: TImage;
    btnTestAnimation: TButton;
    lblPreviewHint: TLabel;

    // Buttons
    pnlButtons: TPanel;
    btnOK: TButton;
    btnCancel: TButton;
    btnReset: TButton;
    btnAbout: TButton;

    // NEW: File dialog for sound files
    dlgOpenSound: TOpenDialog;

    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure btnResetClick(Sender: TObject);
    procedure btnAboutClick(Sender: TObject);
    procedure btnTestAnimationClick(Sender: TObject);

    procedure cmbEffectStyleChange(Sender: TObject);
    procedure cmbTriggerFrequencyChange(Sender: TObject);
    procedure trkAnimationSpeedChange(Sender: TObject);
    procedure trkDurationChange(Sender: TObject);
    procedure trkIntensityChange(Sender: TObject);

    // NEW: Sound event handlers
    procedure chkEnableSoundsClick(Sender: TObject);
    procedure trkSoundVolumeChange(Sender: TObject);
    procedure btnBrowseBasicKeyClick(Sender: TObject);
    procedure btnBrowseEnterKeyClick(Sender: TObject);
    procedure btnBrowseBackspaceClick(Sender: TObject);
    procedure btnTestBasicKeyClick(Sender: TObject);
    procedure btnTestEnterKeyClick(Sender: TObject);
    procedure btnTestBackspaceClick(Sender: TObject);

    procedure UpdatePreview;
    procedure UpdateControls;
    procedure UpdateSoundControls; // NEW

  private
    FConfig: TTypeFXConfig;
    FPreviewTimer: TTimer;
    FStopTimer: TTimer;
    FPreviewFrame: Integer;
    FAnimationType: TAnimationType;
    FPreviewParticles: array[0..11] of record
      X, Y: Double;
      VelX, VelY: Double;
      Life: Double;
      Size: Double;
      Color: TColor;
      Angle: Double;
      Phase: Double;
      Data1: Double;
    end;

    procedure CreatePreviewBitmap;
    procedure ResetToDefaults;
    procedure StartPreviewAnimation;
    procedure StopPreviewAnimation;
    procedure OnPreviewTimer(Sender: TObject);
    procedure OnStopTimer(Sender: TObject);
    procedure DrawPreviewEffect(Canvas: TCanvas; Frame: Integer);
    procedure InitializePreviewParticles;

    // NEW: Sound helper methods
    procedure BrowseSoundFile(EditControl: TEdit; const Title: string);
    procedure TestSoundFile(const FileName: string);

  public
    property Config: TTypeFXConfig read FConfig write FConfig;

    class function ShowConfigDialog(var AConfig: TTypeFXConfig): Boolean;
  end;

implementation

{$R *.dfm}

uses
TypeFXPlugin;

{ TfrmTypeFXConfig }

class function TfrmTypeFXConfig.ShowConfigDialog(var AConfig: TTypeFXConfig): Boolean;
var
  Form: TfrmTypeFXConfig;
begin
  Result := False;
  Form := TfrmTypeFXConfig.Create(nil);
  try
    Form.Config := AConfig;

    // Load current settings into form
    Form.cmbEffectStyle.ItemIndex := Ord(AConfig.EffectStyle);
    Form.cmbTriggerFrequency.ItemIndex := Ord(AConfig.TriggerFrequency);
    Form.trkAnimationSpeed.Position := AConfig.AnimationSpeed;
    Form.trkDuration.Position := AConfig.Duration;
    Form.trkIntensity.Position := AConfig.Intensity;
    Form.chkShowOnDelete.Checked := AConfig.ShowOnDelete;
    Form.chkRandomOffset.Checked := AConfig.RandomOffset;

    // NEW: Load sound settings
    Form.chkEnableSounds.Checked := AConfig.SoundSettings.EnableSounds;
    Form.edtBasicKeySound.Text := AConfig.SoundSettings.BasicKeySound;
    Form.edtEnterKeySound.Text := AConfig.SoundSettings.EnterKeySound;
    Form.edtBackspaceSound.Text := AConfig.SoundSettings.BackspaceSound;

    Form.UpdateControls;
    Form.UpdateSoundControls;
    Form.UpdatePreview;

    if Form.ShowModal = mrOK then
    begin
      AConfig := Form.Config;
      Result := True;
    end;
  finally
    Form.Free;
  end;
end;

procedure TfrmTypeFXConfig.FormCreate(Sender: TObject);
var
  EffectStyle: TEffectStyle;
  TriggerFreq: TTriggerFrequency;
begin
  FPreviewFrame := 0;

  // Create preview timer
  FPreviewTimer := TTimer.Create(Self);
  FPreviewTimer.Enabled := False;
  FPreviewTimer.OnTimer := OnPreviewTimer;
  FPreviewTimer.Interval := 100;

  // Create stop timer
  FStopTimer := TTimer.Create(Self);
  FStopTimer.Enabled := False;
  FStopTimer.OnTimer := OnStopTimer;

  // Setup Effect Style combo
  cmbEffectStyle.Items.Clear;
  for EffectStyle := Low(TEffectStyle) to High(TEffectStyle) do
    cmbEffectStyle.Items.Add(GetEffectStyleName(EffectStyle));

  // Setup Trigger Frequency combo
  cmbTriggerFrequency.Items.Clear;
  for TriggerFreq := Low(TTriggerFrequency) to High(TTriggerFrequency) do
    cmbTriggerFrequency.Items.Add(GetTriggerFrequencyName(TriggerFreq));

  // Setup trackbars
  trkAnimationSpeed.Min := 10;
  trkAnimationSpeed.Max := 200;
  trkAnimationSpeed.Position := 50;

  trkDuration.Min := 500;
  trkDuration.Max := 3000;
  trkDuration.Position := 1000;

  trkIntensity.Min := 1;
  trkIntensity.Max := 10;
  trkIntensity.Position := 5;

  // NEW: Setup sound file dialog
  dlgOpenSound.Filter := 'WAV Audio Files (*.wav)|*.wav|All Files (*.*)|*.*';
  dlgOpenSound.DefaultExt := 'wav';

  // Set defaults
  ResetToDefaults;

  // Setup preview
  pnlPreview.Color := clBlack;
  imgPreview.Transparent := False;
  imgPreview.Center := True;

  UpdateControls;
  UpdateSoundControls;
end;

procedure TfrmTypeFXConfig.FormDestroy(Sender: TObject);
begin
  StopPreviewAnimation;
  if Assigned(FStopTimer) then
    FStopTimer.Free;
  if Assigned(FPreviewTimer) then
    FPreviewTimer.Free;
end;

procedure TfrmTypeFXConfig.ResetToDefaults;
begin
  FConfig := GetDefaultTypeFXConfig;

  cmbEffectStyle.ItemIndex := Ord(FConfig.EffectStyle);
  cmbTriggerFrequency.ItemIndex := Ord(FConfig.TriggerFrequency);
  trkAnimationSpeed.Position := FConfig.AnimationSpeed;
  trkDuration.Position := FConfig.Duration;
  trkIntensity.Position := FConfig.Intensity;
  chkShowOnDelete.Checked := FConfig.ShowOnDelete;
  chkRandomOffset.Checked := FConfig.RandomOffset;

  // NEW: Reset sound settings
  chkEnableSounds.Checked := FConfig.SoundSettings.EnableSounds;
  edtBasicKeySound.Text := FConfig.SoundSettings.BasicKeySound;
  edtEnterKeySound.Text := FConfig.SoundSettings.EnterKeySound;
  edtBackspaceSound.Text := FConfig.SoundSettings.BackspaceSound;

  UpdateControls;
  UpdateSoundControls;
  UpdatePreview;
end;

procedure TfrmTypeFXConfig.UpdateControls;
begin
  // Update speed value
  lblSpeedValue.Caption := Format('%d ms', [trkAnimationSpeed.Position]);

  if trkAnimationSpeed.Position <= 30 then
    lblSpeedHint.Caption := '(Very Fast)'
  else if trkAnimationSpeed.Position <= 70 then
    lblSpeedHint.Caption := '(Fast)'
  else if trkAnimationSpeed.Position <= 120 then
    lblSpeedHint.Caption := '(Normal)'
  else
    lblSpeedHint.Caption := '(Slow)';

  // Update duration value
  lblDurationValue.Caption := Format('%.1f sec', [trkDuration.Position / 1000.0]);

  if trkDuration.Position <= 800 then
    lblDurationHint.Caption := '(Quick Flash)'
  else if trkDuration.Position <= 1500 then
    lblDurationHint.Caption := '(Normal)'
  else
    lblDurationHint.Caption := '(Long Fade)';

  // Update intensity value
  lblIntensityValue.Caption := Format('%d/10', [trkIntensity.Position]);

  if trkIntensity.Position <= 3 then
    lblIntensityHint.Caption := '(Subtle)'
  else if trkIntensity.Position <= 7 then
    lblIntensityHint.Caption := '(Normal)'
  else
    lblIntensityHint.Caption := '(Dramatic)';

  // Update effect description
  if cmbEffectStyle.ItemIndex >= 0 then
  begin
    case TEffectStyle(cmbEffectStyle.ItemIndex) of
      esFire:
        lblEffectDescription.Caption := 'Small fiery particles rising above cursor';
      esLightning:
        lblEffectDescription.Caption := 'Electric sparkles flickering at cursor';
      esMagic:
        lblEffectDescription.Caption := 'Magical sparkles orbiting cursor position';
      esExplosion:
        lblEffectDescription.Caption := 'Small burst of particles radiating outward';
      esSparks:
        lblEffectDescription.Caption := 'Electric sparks radiating from cursor';
      esMatrix:
        lblEffectDescription.Caption := 'Small falling code characters';
      esRainbow:
        lblEffectDescription.Caption := 'Colorful particles in small spiral pattern';
      // NEW EFFECT DESCRIPTIONS
      esIce:
        lblEffectDescription.Caption := 'Sparkling ice crystals falling with shimmer';
      esFlame:
        lblEffectDescription.Caption := 'Cool blue flame particles rising upward';
      esStars:
        lblEffectDescription.Caption := 'Bright twinkling stars bursting outward';
      esSmoke:
        lblEffectDescription.Caption := 'Gentle wispy smoke drifting upward';
      esNeon:
        lblEffectDescription.Caption := 'Pulsing neon glow around cursor';
      esPlasma:
        lblEffectDescription.Caption := 'Purple plasma energy swirling inward';
      esWind:
        lblEffectDescription.Caption := 'Light particles blown by wind';
      esGold:
        lblEffectDescription.Caption := 'Golden sparkles showering downward';
      esLaser:
        lblEffectDescription.Caption := 'Red laser beams shooting outward';
      esCrystal:
        lblEffectDescription.Caption := 'Prismatic crystal shards exploding';
    end;
  end;
end;

// NEW: Update sound controls
procedure TfrmTypeFXConfig.UpdateSoundControls;
var
  SoundsEnabled: Boolean;
begin
  SoundsEnabled := chkEnableSounds.Checked;

  lblBasicKeySound.Enabled := SoundsEnabled;
  edtBasicKeySound.Enabled := SoundsEnabled;
  btnBrowseBasicKey.Enabled := SoundsEnabled;
  btnTestBasicKey.Enabled := SoundsEnabled and (edtBasicKeySound.Text <> '');

  lblEnterKeySound.Enabled := SoundsEnabled;
  edtEnterKeySound.Enabled := SoundsEnabled;
  btnBrowseEnterKey.Enabled := SoundsEnabled;
  btnTestEnterKey.Enabled := SoundsEnabled and (edtEnterKeySound.Text <> '');

  lblBackspaceSound.Enabled := SoundsEnabled;
  edtBackspaceSound.Enabled := SoundsEnabled;
  btnBrowseBackspace.Enabled := SoundsEnabled;
  btnTestBackspace.Enabled := SoundsEnabled and (edtBackspaceSound.Text <> '');
end;

procedure TfrmTypeFXConfig.UpdatePreview;
begin
  CreatePreviewBitmap;
end;

// NEW: Sound event handlers
procedure TfrmTypeFXConfig.chkEnableSoundsClick(Sender: TObject);
begin
  UpdateSoundControls;
end;

procedure TfrmTypeFXConfig.trkSoundVolumeChange(Sender: TObject);
begin
  UpdateSoundControls;
end;

procedure TfrmTypeFXConfig.btnBrowseBasicKeyClick(Sender: TObject);
begin
  BrowseSoundFile(edtBasicKeySound, 'Select Basic Key Sound');
end;

procedure TfrmTypeFXConfig.btnBrowseEnterKeyClick(Sender: TObject);
begin
  BrowseSoundFile(edtEnterKeySound, 'Select Enter Key Sound');
end;

procedure TfrmTypeFXConfig.btnBrowseBackspaceClick(Sender: TObject);
begin
  BrowseSoundFile(edtBackspaceSound, 'Select Backspace Key Sound');
end;

procedure TfrmTypeFXConfig.btnTestBasicKeyClick(Sender: TObject);
begin
  TestSoundFile(edtBasicKeySound.Text);
end;

procedure TfrmTypeFXConfig.btnTestEnterKeyClick(Sender: TObject);
begin
  TestSoundFile(edtEnterKeySound.Text);
end;

procedure TfrmTypeFXConfig.btnTestBackspaceClick(Sender: TObject);
begin
  TestSoundFile(edtBackspaceSound.Text);
end;

// NEW: Sound helper methods
procedure TfrmTypeFXConfig.BrowseSoundFile(EditControl: TEdit; const Title: string);
begin
  dlgOpenSound.Title := Title;
  if (EditControl.Text <> '') and FileExists(EditControl.Text) then
    dlgOpenSound.FileName := EditControl.Text;

  if dlgOpenSound.Execute then
  begin
    EditControl.Text := dlgOpenSound.FileName;
    UpdateSoundControls;
  end;
end;

procedure TfrmTypeFXConfig.TestSoundFile(const FileName: string);
begin
  if FileExists(FileName) then
  begin
    TSoundManager.GetInstance.PlaySound(FileName, 100);
  end
  else
  begin
    ShowMessage('Sound file not found: ' + FileName);
  end;
end;

// Rest of the implementation remains the same as before...
// [Include all the existing preview methods: InitializePreviewParticles, CreatePreviewBitmap, etc.]

procedure TfrmTypeFXConfig.InitializePreviewParticles;
var
  i: Integer;
  Angle: Double;
begin
  for i := 0 to 11 do
  begin
    case FAnimationType of
      atFire:
      begin
        Angle := Random * (PI/2) - PI/4; // Upward cone
        FPreviewParticles[i].X := Random * 16 - 8;
        FPreviewParticles[i].Y := Random * 12;
        FPreviewParticles[i].VelX := Sin(Angle) * 30;
        FPreviewParticles[i].VelY := -Cos(Angle) * 30;
        FPreviewParticles[i].Life := 1.0;
        FPreviewParticles[i].Size := 3 + Random * 5;
        FPreviewParticles[i].Color := RGB(255, 255, 255);
        FPreviewParticles[i].Phase := Random * 6.28;
      end;

      atLightning:
      begin
        FPreviewParticles[i].X := Random * 16 - 8;
        FPreviewParticles[i].Y := Random * 16 - 8;
        FPreviewParticles[i].VelX := 0;
        FPreviewParticles[i].VelY := 0;
        FPreviewParticles[i].Life := 1.0;
        FPreviewParticles[i].Size := 2 + Random * 3;
        FPreviewParticles[i].Color := RGB(220 + Random(36), 220 + Random(36), 255);
        FPreviewParticles[i].Phase := Random * 6.28;
      end;

      atMagic:
      begin
        Angle := (i / 12) * 6.28;
        FPreviewParticles[i].X := Cos(Angle) * 10;
        FPreviewParticles[i].Y := Sin(Angle) * 10;
        FPreviewParticles[i].VelX := 0;
        FPreviewParticles[i].VelY := 0;
        FPreviewParticles[i].Life := 1.0;
        FPreviewParticles[i].Size := 2 + Random * 3;
        FPreviewParticles[i].Angle := Angle;
        FPreviewParticles[i].Color := HSVtoRGB(240 + Random(90), 255, 255);
        FPreviewParticles[i].Phase := Random * 6.28;
      end;

      atExplosion:
      begin
        Angle := Random * 6.28;
        FPreviewParticles[i].X := Random * 6 - 3;
        FPreviewParticles[i].Y := Random * 6 - 3;
        FPreviewParticles[i].VelX := Cos(Angle) * 30;
        FPreviewParticles[i].VelY := Sin(Angle) * 30;
        FPreviewParticles[i].Life := 1.0;
        FPreviewParticles[i].Size := 3 + Random * 5;
        if i < 3 then
          FPreviewParticles[i].Color := RGB(255, 255, 200)
        else if i < 6 then
          FPreviewParticles[i].Color := RGB(255, 180, 0)
        else
          FPreviewParticles[i].Color := RGB(255, 80, 0);
      end;

      atSparks:
      begin
        Angle := (i / 12) * 6.28;
        FPreviewParticles[i].X := 0;
        FPreviewParticles[i].Y := 0;
        FPreviewParticles[i].VelX := Cos(Angle) * 25;
        FPreviewParticles[i].VelY := Sin(Angle) * 25;
        FPreviewParticles[i].Life := 1.0;
        FPreviewParticles[i].Size := 2 + Random * 3;
        FPreviewParticles[i].Color := RGB(255, 255, 150 + Random(106));
        FPreviewParticles[i].Phase := Random * 6.28;
      end;

      atMatrix:
      begin
        FPreviewParticles[i].X := Random * 16 - 8;
        FPreviewParticles[i].Y := -12 - Random * 4;
        FPreviewParticles[i].VelX := 0;
        FPreviewParticles[i].VelY := 30 + Random * 20;
        FPreviewParticles[i].Life := 1.0;
        FPreviewParticles[i].Size := 8 + Random * 4;
        FPreviewParticles[i].Color := RGB(0, 255, 0);
        FPreviewParticles[i].Data1 := Random(26); // Character
      end;

      atRainbow:
      begin
        Angle := (i / 12) * 6.28;
        FPreviewParticles[i].X := Cos(Angle) * 8;
        FPreviewParticles[i].Y := Sin(Angle) * 8;
        FPreviewParticles[i].VelX := Cos(Angle + PI/2) * 20;
        FPreviewParticles[i].VelY := Sin(Angle + PI/2) * 20;
        FPreviewParticles[i].Life := 1.0;
        FPreviewParticles[i].Size := 3 + Random * 3;
        FPreviewParticles[i].Angle := Angle;
        FPreviewParticles[i].Phase := (i / 12) * 360;
        FPreviewParticles[i].Color := HSVtoRGB(Round(FPreviewParticles[i].Phase), 255, 255);
      end;

      // NEW ANIMATION PREVIEWS
      atIce:
      begin
        Angle := Random * (PI/6) - PI/12;
        FPreviewParticles[i].X := Random * 16 - 8;
        FPreviewParticles[i].Y := -12 - Random * 4;
        FPreviewParticles[i].VelX := Sin(Angle) * 10;
        FPreviewParticles[i].VelY := 25 + Random * 15;
        FPreviewParticles[i].Life := 1.0;
        FPreviewParticles[i].Size := 2 + Random * 4;
        FPreviewParticles[i].Color := RGB(200 + Random(56), 230 + Random(26), 255);
        FPreviewParticles[i].Phase := Random * 6.28;
      end;

      atFlame:
      begin
        Angle := Random * (PI/2) - PI/4;
        FPreviewParticles[i].X := Random * 16 - 8;
        FPreviewParticles[i].Y := Random * 12;
        FPreviewParticles[i].VelX := Sin(Angle) * 30;
        FPreviewParticles[i].VelY := -Cos(Angle) * 30;
        FPreviewParticles[i].Life := 1.0;
        FPreviewParticles[i].Size := 3 + Random * 5;
        FPreviewParticles[i].Color := RGB(100 + Random(56), 150 + Random(106), 255);
        FPreviewParticles[i].Phase := Random * 6.28;
      end;

      atStars:
      begin
        Angle := (i / 12) * 6.28 + Random * 0.4 - 0.2;
        FPreviewParticles[i].X := Random * 6 - 3;
        FPreviewParticles[i].Y := Random * 6 - 3;
        FPreviewParticles[i].VelX := Cos(Angle) * 25;
        FPreviewParticles[i].VelY := Sin(Angle) * 25;
        FPreviewParticles[i].Life := 1.0;
        FPreviewParticles[i].Size := 2 + Random * 4;
        FPreviewParticles[i].Color := RGB(255, 255, 200 + Random(56));
        FPreviewParticles[i].Phase := Random * 6.28;
      end;

      atSmoke:
      begin
        Angle := Random * (PI/3) - PI/6;
        FPreviewParticles[i].X := Random * 12 - 6;
        FPreviewParticles[i].Y := Random * 8;
        FPreviewParticles[i].VelX := Sin(Angle) * 12;
        FPreviewParticles[i].VelY := -Cos(Angle) * 20;
        FPreviewParticles[i].Life := 1.0;
        FPreviewParticles[i].Size := 4 + Random * 6;
        FPreviewParticles[i].Color := RGB(120 + Random(86), 120 + Random(86), 130 + Random(76));
        FPreviewParticles[i].Phase := Random * 6.28;
      end;

      atNeon:
      begin
        Angle := (i / 12) * 6.28;
        FPreviewParticles[i].X := Cos(Angle) * 8;
        FPreviewParticles[i].Y := Sin(Angle) * 8 * 0.7;
        FPreviewParticles[i].VelX := 0;
        FPreviewParticles[i].VelY := 0;
        FPreviewParticles[i].Life := 1.0;
        FPreviewParticles[i].Size := 3 + Random * 4;
        if i mod 2 = 0 then
          FPreviewParticles[i].Color := RGB(0, 255, 255)
        else
          FPreviewParticles[i].Color := RGB(255, 0, 255);
        FPreviewParticles[i].Phase := Random * 6.28;
      end;

      atPlasma:
      begin
        Angle := Random * 6.28;
        FPreviewParticles[i].X := Random * 8 - 4;
        FPreviewParticles[i].Y := Random * 8 - 4;
        FPreviewParticles[i].VelX := Cos(Angle) * 35;
        FPreviewParticles[i].VelY := Sin(Angle) * 35;
        FPreviewParticles[i].Life := 1.0;
        FPreviewParticles[i].Size := 2 + Random * 4;
        FPreviewParticles[i].Color := RGB(128 + Random(128), 0, 200 + Random(56));
        FPreviewParticles[i].Phase := Random * 6.28;
      end;

      atWind:
      begin
        FPreviewParticles[i].X := -12 - Random * 4;
        FPreviewParticles[i].Y := Random * 12 - 6;
        FPreviewParticles[i].VelX := 50 + Random * 20;
        FPreviewParticles[i].VelY := Random * 20 - 10;
        FPreviewParticles[i].Life := 1.0;
        FPreviewParticles[i].Size := 2 + Random * 3;
        FPreviewParticles[i].Color := RGB(220 + Random(36), 240 + Random(16), 255);
        FPreviewParticles[i].Phase := Random * 6.28;
      end;

      atGold:
      begin
        Angle := Random * (PI/6) - PI/12;
        FPreviewParticles[i].X := Random * 16 - 8;
        FPreviewParticles[i].Y := -12 - Random * 4;
        FPreviewParticles[i].VelX := Sin(Angle) * 12;
        FPreviewParticles[i].VelY := 30 + Random * 15;
        FPreviewParticles[i].Life := 1.0;
        FPreviewParticles[i].Size := 2 + Random * 4;
        FPreviewParticles[i].Color := RGB(255, 180 + Random(76), 0);
        FPreviewParticles[i].Phase := Random * 6.28;
      end;

      atLaser:
      begin
        Angle := (i / 12) * 6.28 + Random * 0.2 - 0.1;
        FPreviewParticles[i].X := 0;
        FPreviewParticles[i].Y := 0;
        FPreviewParticles[i].VelX := Cos(Angle) * 50;
        FPreviewParticles[i].VelY := Sin(Angle) * 50;
        FPreviewParticles[i].Life := 1.0;
        FPreviewParticles[i].Size := 1 + Random * 2;
        FPreviewParticles[i].Color := RGB(255, 0, 0);
        FPreviewParticles[i].Phase := Random * 6.28;
      end;

      atCrystal:
      begin
        Angle := Random * 6.28;
        FPreviewParticles[i].X := Random * 6 - 3;
        FPreviewParticles[i].Y := Random * 6 - 3;
        FPreviewParticles[i].VelX := Cos(Angle) * 30;
        FPreviewParticles[i].VelY := Sin(Angle) * 30;
        FPreviewParticles[i].Life := 1.0;
        FPreviewParticles[i].Size := 3 + Random * 4;
        case i mod 7 of
          0: FPreviewParticles[i].Color := RGB(255, 200, 200);
          1: FPreviewParticles[i].Color := RGB(200, 255, 200);
          2: FPreviewParticles[i].Color := RGB(200, 200, 255);
          3: FPreviewParticles[i].Color := RGB(255, 255, 200);
          4: FPreviewParticles[i].Color := RGB(255, 200, 255);
          5: FPreviewParticles[i].Color := RGB(200, 255, 255);
          else FPreviewParticles[i].Color := RGB(255, 255, 255);
        end;
        FPreviewParticles[i].Phase := Random * 6.28;
      end;
    end;
  end;
end;

procedure TfrmTypeFXConfig.CreatePreviewBitmap;
var
  Bitmap: TBitmap;
begin
  StopPreviewAnimation;

  if cmbEffectStyle.ItemIndex < 0 then Exit;

  // Convert effect style to animation type
  case TEffectStyle(cmbEffectStyle.ItemIndex) of
    esFire: FAnimationType := atFire;
    esLightning: FAnimationType := atLightning;
    esMagic: FAnimationType := atMagic;
    esExplosion: FAnimationType := atExplosion;
    esSparks: FAnimationType := atSparks;
    esMatrix: FAnimationType := atMatrix;
    esRainbow: FAnimationType := atRainbow;
    // NEW ANIMATION TYPES
    esIce: FAnimationType := atIce;
    esFlame: FAnimationType := atFlame;
    esStars: FAnimationType := atStars;
    esSmoke: FAnimationType := atSmoke;
    esNeon: FAnimationType := atNeon;
    esPlasma: FAnimationType := atPlasma;
    esWind: FAnimationType := atWind;
    esGold: FAnimationType := atGold;
    esLaser: FAnimationType := atLaser;
    esCrystal: FAnimationType := atCrystal;
    else FAnimationType := atFire;
  end;

  // Initialize particles for this effect
  InitializePreviewParticles;

  // Create preview bitmap
  Bitmap := TBitmap.Create;
  try
    Bitmap.Width := pnlPreview.Width - 4;
    Bitmap.Height := pnlPreview.Height - 4;
    Bitmap.Canvas.Brush.Color := clBlack;
    Bitmap.Canvas.FillRect(Rect(0, 0, Bitmap.Width, Bitmap.Height));

    // Draw static preview
    DrawPreviewEffect(Bitmap.Canvas, 0);

    imgPreview.Picture.Assign(Bitmap);
  finally
    Bitmap.Free;
  end;
end;

procedure TfrmTypeFXConfig.DrawPreviewEffect(Canvas: TCanvas; Frame: Integer);
var
  centerX, centerY: Integer;
  i, x, y, size: Integer;
  DeltaTime: Double;
  LifeRatio: Double;
  Ch: Char;
begin
  centerX := Canvas.ClipRect.Width div 2;
  centerY := Canvas.ClipRect.Height div 2;
  DeltaTime := 0.1;

  // Update particles for animation
  for i := 0 to 11 do
  begin
    case FAnimationType of
      atFire:
      begin
        // Update fire particles
        FPreviewParticles[i].X := FPreviewParticles[i].X + FPreviewParticles[i].VelX * DeltaTime;
        FPreviewParticles[i].Y := FPreviewParticles[i].Y + FPreviewParticles[i].VelY * DeltaTime;
        FPreviewParticles[i].VelY := FPreviewParticles[i].VelY - 30 * DeltaTime; // Buoyancy
        FPreviewParticles[i].Life := FPreviewParticles[i].Life - DeltaTime * 0.8;

        if FPreviewParticles[i].Life <= 0 then
        begin
          // Reset particle
          FPreviewParticles[i].X := Random * 16 - 8;
          FPreviewParticles[i].Y := Random * 12;
          FPreviewParticles[i].VelX := Sin(Random * PI/2 - PI/4) * 30;
          FPreviewParticles[i].VelY := -Cos(Random * PI/2 - PI/4) * 30;
          FPreviewParticles[i].Life := 1.0;
        end;

        LifeRatio := FPreviewParticles[i].Life;
        if LifeRatio > 0.7 then
          FPreviewParticles[i].Color := RGB(255, 255, 255)
        else if LifeRatio > 0.5 then
          FPreviewParticles[i].Color := RGB(255, 255, 150)
        else if LifeRatio > 0.3 then
          FPreviewParticles[i].Color := RGB(255, 180, 0)
        else
          FPreviewParticles[i].Color := RGB(255, 80, 0);
      end;

      atLightning:
      begin
        FPreviewParticles[i].Life := FPreviewParticles[i].Life - DeltaTime * 1.5;
        if FPreviewParticles[i].Life <= 0 then
        begin
          FPreviewParticles[i].X := Random * 16 - 8;
          FPreviewParticles[i].Y := Random * 16 - 8;
          FPreviewParticles[i].Life := 1.0;
        end;
      end;

      atMagic:
      begin
        FPreviewParticles[i].Angle := FPreviewParticles[i].Angle + 3 * DeltaTime;
        FPreviewParticles[i].X := Cos(FPreviewParticles[i].Angle) * 10;
        FPreviewParticles[i].Y := Sin(FPreviewParticles[i].Angle) * 10 * 0.7;
        FPreviewParticles[i].Life := FPreviewParticles[i].Life - DeltaTime * 0.7;
        if FPreviewParticles[i].Life <= 0 then
          FPreviewParticles[i].Life := 1.0;
      end;

      atExplosion:
      begin
        FPreviewParticles[i].X := FPreviewParticles[i].X + FPreviewParticles[i].VelX * DeltaTime;
        FPreviewParticles[i].Y := FPreviewParticles[i].Y + FPreviewParticles[i].VelY * DeltaTime;
        FPreviewParticles[i].VelX := FPreviewParticles[i].VelX * 0.95; // Drag
        FPreviewParticles[i].VelY := FPreviewParticles[i].VelY * 0.95;
        FPreviewParticles[i].Life := FPreviewParticles[i].Life - DeltaTime * 0.8;
        if FPreviewParticles[i].Life <= 0 then
        begin
          FPreviewParticles[i].X := Random * 6 - 3;
          FPreviewParticles[i].Y := Random * 6 - 3;
          FPreviewParticles[i].VelX := Cos(Random * 6.28) * 30;
          FPreviewParticles[i].VelY := Sin(Random * 6.28) * 30;
          FPreviewParticles[i].Life := 1.0;
        end;
      end;

      atSparks:
      begin
        FPreviewParticles[i].X := FPreviewParticles[i].X + FPreviewParticles[i].VelX * DeltaTime;
        FPreviewParticles[i].Y := FPreviewParticles[i].Y + FPreviewParticles[i].VelY * DeltaTime;
        FPreviewParticles[i].VelX := FPreviewParticles[i].VelX * 0.9; // Drag
        FPreviewParticles[i].VelY := FPreviewParticles[i].VelY * 0.9;
        FPreviewParticles[i].Life := FPreviewParticles[i].Life - DeltaTime * 1.0;
        if FPreviewParticles[i].Life <= 0 then
        begin
          FPreviewParticles[i].X := 0;
          FPreviewParticles[i].Y := 0;
          FPreviewParticles[i].VelX := Cos((i / 12) * 6.28) * 25;
          FPreviewParticles[i].VelY := Sin((i / 12) * 6.28) * 25;
          FPreviewParticles[i].Life := 1.0;
        end;
      end;

      atMatrix:
      begin
        FPreviewParticles[i].Y := FPreviewParticles[i].Y + FPreviewParticles[i].VelY * DeltaTime;
        FPreviewParticles[i].Life := FPreviewParticles[i].Life - DeltaTime * 0.6;
        if FPreviewParticles[i].Life <= 0 then
        begin
          FPreviewParticles[i].Y := -12 - Random * 4;
          FPreviewParticles[i].Life := 1.0;
          FPreviewParticles[i].Data1 := Random(26);
        end;
      end;

      atRainbow:
      begin
        FPreviewParticles[i].Angle := FPreviewParticles[i].Angle + 3 * DeltaTime;
        FPreviewParticles[i].X := Cos(FPreviewParticles[i].Angle) * (8 + (1 - FPreviewParticles[i].Life) * 12);
        FPreviewParticles[i].Y := Sin(FPreviewParticles[i].Angle) * (8 + (1 - FPreviewParticles[i].Life) * 12) * 0.8;
        FPreviewParticles[i].Phase := FPreviewParticles[i].Phase + 180 * DeltaTime;
        if FPreviewParticles[i].Phase >= 360 then
          FPreviewParticles[i].Phase := FPreviewParticles[i].Phase - 360;
        FPreviewParticles[i].Color := HSVtoRGB(Round(FPreviewParticles[i].Phase), 255, 255);
        FPreviewParticles[i].Life := FPreviewParticles[i].Life - DeltaTime * 0.7;
        if FPreviewParticles[i].Life <= 0 then
          FPreviewParticles[i].Life := 1.0;
      end;

      // NEW ANIMATION UPDATES
      atIce:
      begin
        FPreviewParticles[i].X := FPreviewParticles[i].X + FPreviewParticles[i].VelX * DeltaTime;
        FPreviewParticles[i].Y := FPreviewParticles[i].Y + FPreviewParticles[i].VelY * DeltaTime;
        FPreviewParticles[i].Life := FPreviewParticles[i].Life - DeltaTime * 0.6;
        if FPreviewParticles[i].Life <= 0 then
        begin
          FPreviewParticles[i].X := Random * 16 - 8;
          FPreviewParticles[i].Y := -12 - Random * 4;
          FPreviewParticles[i].Life := 1.0;
        end;
      end;

      atFlame:
      begin
        FPreviewParticles[i].X := FPreviewParticles[i].X + FPreviewParticles[i].VelX * DeltaTime;
        FPreviewParticles[i].Y := FPreviewParticles[i].Y + FPreviewParticles[i].VelY * DeltaTime;
        FPreviewParticles[i].VelY := FPreviewParticles[i].VelY - 30 * DeltaTime;
        FPreviewParticles[i].Life := FPreviewParticles[i].Life - DeltaTime * 0.8;
        if FPreviewParticles[i].Life <= 0 then
        begin
          FPreviewParticles[i].X := Random * 16 - 8;
          FPreviewParticles[i].Y := Random * 12;
          FPreviewParticles[i].VelX := Sin(Random * PI/2 - PI/4) * 30;
          FPreviewParticles[i].VelY := -Cos(Random * PI/2 - PI/4) * 30;
          FPreviewParticles[i].Life := 1.0;
        end;
      end;

      atStars:
      begin
        FPreviewParticles[i].X := FPreviewParticles[i].X + FPreviewParticles[i].VelX * DeltaTime;
        FPreviewParticles[i].Y := FPreviewParticles[i].Y + FPreviewParticles[i].VelY * DeltaTime;
        FPreviewParticles[i].VelX := FPreviewParticles[i].VelX * 0.9;
        FPreviewParticles[i].VelY := FPreviewParticles[i].VelY * 0.9;
        FPreviewParticles[i].Life := FPreviewParticles[i].Life - DeltaTime * 0.7;
        if FPreviewParticles[i].Life <= 0 then
        begin
          FPreviewParticles[i].X := Random * 6 - 3;
          FPreviewParticles[i].Y := Random * 6 - 3;
          FPreviewParticles[i].Life := 1.0;
        end;
      end;

      atSmoke:
      begin
        FPreviewParticles[i].X := FPreviewParticles[i].X + FPreviewParticles[i].VelX * DeltaTime;
        FPreviewParticles[i].Y := FPreviewParticles[i].Y + FPreviewParticles[i].VelY * DeltaTime;
        FPreviewParticles[i].Life := FPreviewParticles[i].Life - DeltaTime * 0.5;
        if FPreviewParticles[i].Life <= 0 then
        begin
          FPreviewParticles[i].X := Random * 12 - 6;
          FPreviewParticles[i].Y := Random * 8;
          FPreviewParticles[i].Life := 1.0;
        end;
      end;

      atNeon:
      begin
        FPreviewParticles[i].Life := FPreviewParticles[i].Life - DeltaTime * 0.7;
        if FPreviewParticles[i].Life <= 0 then
          FPreviewParticles[i].Life := 1.0;
      end;

      atPlasma:
      begin
        FPreviewParticles[i].X := FPreviewParticles[i].X + FPreviewParticles[i].VelX * DeltaTime;
        FPreviewParticles[i].Y := FPreviewParticles[i].Y + FPreviewParticles[i].VelY * DeltaTime;
        FPreviewParticles[i].VelX := FPreviewParticles[i].VelX - FPreviewParticles[i].X * 10 * DeltaTime;
        FPreviewParticles[i].VelY := FPreviewParticles[i].VelY - FPreviewParticles[i].Y * 10 * DeltaTime;
        FPreviewParticles[i].Life := FPreviewParticles[i].Life - DeltaTime * 1.2;
        if FPreviewParticles[i].Life <= 0 then
        begin
          FPreviewParticles[i].X := Random * 8 - 4;
          FPreviewParticles[i].Y := Random * 8 - 4;
          FPreviewParticles[i].Life := 1.0;
        end;
      end;

      atWind:
      begin
        FPreviewParticles[i].X := FPreviewParticles[i].X + FPreviewParticles[i].VelX * DeltaTime;
        FPreviewParticles[i].Y := FPreviewParticles[i].Y + FPreviewParticles[i].VelY * DeltaTime;
        FPreviewParticles[i].VelX := FPreviewParticles[i].VelX * 0.95;
        FPreviewParticles[i].Life := FPreviewParticles[i].Life - DeltaTime * 0.8;
        if FPreviewParticles[i].Life <= 0 then
        begin
          FPreviewParticles[i].X := -12 - Random * 4;
          FPreviewParticles[i].Y := Random * 12 - 6;
          FPreviewParticles[i].Life := 1.0;
        end;
      end;

      atGold:
      begin
        FPreviewParticles[i].X := FPreviewParticles[i].X + FPreviewParticles[i].VelX * DeltaTime;
        FPreviewParticles[i].Y := FPreviewParticles[i].Y + FPreviewParticles[i].VelY * DeltaTime;
        FPreviewParticles[i].Life := FPreviewParticles[i].Life - DeltaTime * 0.6;
        if FPreviewParticles[i].Life <= 0 then
        begin
          FPreviewParticles[i].X := Random * 16 - 8;
          FPreviewParticles[i].Y := -12 - Random * 4;
          FPreviewParticles[i].Life := 1.0;
        end;
      end;

      atLaser:
      begin
        FPreviewParticles[i].X := FPreviewParticles[i].X + FPreviewParticles[i].VelX * DeltaTime;
        FPreviewParticles[i].Y := FPreviewParticles[i].Y + FPreviewParticles[i].VelY * DeltaTime;
        FPreviewParticles[i].Life := FPreviewParticles[i].Life - DeltaTime * 2.0;
        if FPreviewParticles[i].Life <= 0 then
        begin
          FPreviewParticles[i].X := 0;
          FPreviewParticles[i].Y := 0;
          FPreviewParticles[i].Life := 1.0;
        end;
      end;

      atCrystal:
      begin
        FPreviewParticles[i].X := FPreviewParticles[i].X + FPreviewParticles[i].VelX * DeltaTime;
        FPreviewParticles[i].Y := FPreviewParticles[i].Y + FPreviewParticles[i].VelY * DeltaTime;
        FPreviewParticles[i].VelX := FPreviewParticles[i].VelX * 0.9;
        FPreviewParticles[i].VelY := FPreviewParticles[i].VelY * 0.9;
        FPreviewParticles[i].Life := FPreviewParticles[i].Life - DeltaTime * 0.8;
        if FPreviewParticles[i].Life <= 0 then
        begin
          FPreviewParticles[i].X := Random * 6 - 3;
          FPreviewParticles[i].Y := Random * 6 - 3;
          FPreviewParticles[i].Life := 1.0;
        end;
      end;
    end;
  end;

  // Render particles
  Canvas.Pen.Style := psClear;
  Canvas.Brush.Style := bsSolid;

  for i := 0 to 11 do
  begin
    if FPreviewParticles[i].Life <= 0 then Continue;

    x := centerX + Round(FPreviewParticles[i].X);
    y := centerY + Round(FPreviewParticles[i].Y);
    size := Round(FPreviewParticles[i].Size * FPreviewParticles[i].Life);

    if size > 0 then
    begin
      case FAnimationType of
       atMatrix:
        begin
          Canvas.Font.Name := 'Courier New';
          Canvas.Font.Size := size;
          Canvas.Font.Color := FPreviewParticles[i].Color;
          Canvas.Brush.Style := bsClear;
          Ch := Chr(Ord('A') + Round(FPreviewParticles[i].Data1));
          Canvas.TextOut(x, y, Ch);
        end;

        atMagic, atStars:
        begin
          // Draw glow
          Canvas.Brush.Color := FPreviewParticles[i].Color;
          Canvas.Ellipse(x - size, y - size, x + size, y + size);
          // Draw sparkle
          Canvas.Pen.Style := psSolid;
          Canvas.Pen.Color := RGB(255, 255, 255);
          Canvas.Pen.Width := 1;
          Canvas.MoveTo(x - size - 2, y);
          Canvas.LineTo(x + size + 2, y);
          Canvas.MoveTo(x, y - size - 2);
          Canvas.LineTo(x, y + size + 2);
          Canvas.Pen.Style := psClear;
        end;

        atLaser:
        begin
          // Draw laser beam
          Canvas.Pen.Style := psSolid;
          Canvas.Pen.Width := 2;
          Canvas.Pen.Color := RGB(255, 0, 0);
          Canvas.MoveTo(centerX, centerY);
          Canvas.LineTo(x, y);
          Canvas.Pen.Style := psClear;
        end;

        else
        begin
          // Simple glow effect for other types
          Canvas.Brush.Color := FPreviewParticles[i].Color;
          Canvas.Ellipse(x - size, y - size, x + size, y + size);
        end;
      end;
    end;
  end;

  // Special rendering for sparks (draw lines)
  if FAnimationType = atSparks then
  begin
    Canvas.Pen.Style := psSolid;
    Canvas.Pen.Width := 1;
    Canvas.Pen.Color := RGB(255, 255, 200);
    for i := 0 to 7 do
    begin
      if FPreviewParticles[i].Life <= 0 then Continue;
      x := centerX + Round(FPreviewParticles[i].X);
      y := centerY + Round(FPreviewParticles[i].Y);
      Canvas.MoveTo(centerX, centerY);
      Canvas.LineTo(x, y);
    end;
  end;
end;

procedure TfrmTypeFXConfig.StartPreviewAnimation;
begin
  FPreviewFrame := 0;
  InitializePreviewParticles; // Reset particles
  FPreviewTimer.Interval := trkAnimationSpeed.Position;
  FPreviewTimer.Enabled := True;
end;

procedure TfrmTypeFXConfig.StopPreviewAnimation;
begin
  FPreviewTimer.Enabled := False;
  FStopTimer.Enabled := False;
  btnTestAnimation.Caption := 'Test Animation';
end;

procedure TfrmTypeFXConfig.OnPreviewTimer(Sender: TObject);
var
  Bitmap: TBitmap;
begin
  Inc(FPreviewFrame);

  // Create animated frame
  Bitmap := TBitmap.Create;
  try
    Bitmap.Width := pnlPreview.Width - 4;
    Bitmap.Height := pnlPreview.Height - 4;
    Bitmap.Canvas.Brush.Color := clBlack;
    Bitmap.Canvas.FillRect(Rect(0, 0, Bitmap.Width, Bitmap.Height));

    DrawPreviewEffect(Bitmap.Canvas, FPreviewFrame);

    imgPreview.Picture.Assign(Bitmap);
  finally
    Bitmap.Free;
  end;
end;

procedure TfrmTypeFXConfig.OnStopTimer(Sender: TObject);
begin
  StopPreviewAnimation;
  CreatePreviewBitmap; // Return to static preview
end;

procedure TfrmTypeFXConfig.btnTestAnimationClick(Sender: TObject);
begin
  if FPreviewTimer.Enabled then
    StopPreviewAnimation
  else
  begin
    StartPreviewAnimation;
    btnTestAnimation.Caption := 'Stop Preview';

    // Auto-stop after duration
    FStopTimer.Interval := trkDuration.Position;
    FStopTimer.Enabled := True;
  end;
end;

procedure TfrmTypeFXConfig.btnOKClick(Sender: TObject);
begin
  // Save configuration
  if cmbEffectStyle.ItemIndex >= 0 then
    FConfig.EffectStyle := TEffectStyle(cmbEffectStyle.ItemIndex);
  if cmbTriggerFrequency.ItemIndex >= 0 then
    FConfig.TriggerFrequency := TTriggerFrequency(cmbTriggerFrequency.ItemIndex);
  FConfig.AnimationSpeed := trkAnimationSpeed.Position;
  FConfig.Duration := trkDuration.Position;
  FConfig.Intensity := trkIntensity.Position;
  FConfig.ShowOnDelete := chkShowOnDelete.Checked;
  FConfig.RandomOffset := chkRandomOffset.Checked;

  // NEW: Save sound settings
  FConfig.SoundSettings.EnableSounds := chkEnableSounds.Checked;
  FConfig.SoundSettings.BasicKeySound := edtBasicKeySound.Text;
  FConfig.SoundSettings.EnterKeySound := edtEnterKeySound.Text;
  FConfig.SoundSettings.BackspaceSound := edtBackspaceSound.Text;

  ModalResult := mrOK;  // 👈 ADD THIS LINE - IMPORTANT!

  if Assigned(TypeFXWizard) then
    TypeFXWizard.ShowNotification('TypeFX Studio Settings Saved Successfully!', 2500);
end;

procedure TfrmTypeFXConfig.btnCancelClick(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

procedure TfrmTypeFXConfig.btnResetClick(Sender: TObject);
begin
  if MessageDlg('Reset all settings to defaults?', mtConfirmation, [mbYes, mbNo], 0) = mrYes then
    ResetToDefaults;
end;

procedure TfrmTypeFXConfig.btnAboutClick(Sender: TObject);
begin
  MessageDlg(
    'TypeFX Studio v2.0' + #13#10 +
    'Visual Typing Effects for Delphi IDE' + #13#10 + #13#10 +
    'Brings magical visual effects to your coding experience!' + #13#10 +
    'Every keystroke becomes a visual celebration.' + #13#10 + #13#10 +
    'Features:' + #13#10 +
    '• Multiple animation styles (17 total!)' + #13#10 +
    '• Configurable trigger frequency' + #13#10 +
    '• Adjustable speed and duration' + #13#10 +
    '• Intensity control' + #13#10 +
    '• Random positioning' + #13#10 +
    '• Sound effects for key presses' + #13#10 + #13#10 +
    'Created with passion for the Delphi community!',
    mtInformation, [mbOK], 0);
end;

// Event handlers
procedure TfrmTypeFXConfig.cmbEffectStyleChange(Sender: TObject);
begin
  UpdateControls;
  UpdatePreview;
end;

procedure TfrmTypeFXConfig.cmbTriggerFrequencyChange(Sender: TObject);
begin
  UpdateControls;
end;

procedure TfrmTypeFXConfig.trkAnimationSpeedChange(Sender: TObject);
begin
  UpdateControls;
end;

procedure TfrmTypeFXConfig.trkDurationChange(Sender: TObject);
begin
  UpdateControls;
end;

procedure TfrmTypeFXConfig.trkIntensityChange(Sender: TObject);
begin
  UpdateControls;
end;

end.
