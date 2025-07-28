object frmTypeFXConfig: TfrmTypeFXConfig
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'TypeFX Studio Settings'
  ClientHeight = 750
  ClientWidth = 600
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Segoe UI'
  Font.Style = []
  Position = poScreenCenter
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  TextHeight = 13
  object pnlMain: TPanel
    Left = 8
    Top = 8
    Width = 584
    Height = 700
    BevelOuter = bvNone
    TabOrder = 0
    object grpEffectStyle: TGroupBox
      Left = 0
      Top = 0
      Width = 584
      Height = 100
      Caption = ' Effect Style Selection '
      TabOrder = 0
      object lblEffectStyle: TLabel
        Left = 12
        Top = 20
        Width = 59
        Height = 13
        Caption = 'Effect Style:'
      end
      object lblEffectDescription: TLabel
        Left = 12
        Top = 70
        Width = 179
        Height = 13
        Caption = 'Select an effect style to see description'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clGray
        Font.Height = -11
        Font.Name = 'Segoe UI'
        Font.Style = [fsItalic]
        ParentFont = False
      end
      object cmbEffectStyle: TComboBox
        Left = 12
        Top = 39
        Width = 200
        Height = 21
        Style = csDropDownList
        TabOrder = 0
        OnChange = cmbEffectStyleChange
      end
    end
    object grpTriggerSettings: TGroupBox
      Left = 0
      Top = 110
      Width = 584
      Height = 120
      Caption = ' Trigger Settings '
      TabOrder = 1
      object lblTriggerFrequency: TLabel
        Left = 12
        Top = 20
        Width = 94
        Height = 13
        Caption = 'Trigger Frequency:'
      end
      object cmbTriggerFrequency: TComboBox
        Left = 12
        Top = 39
        Width = 200
        Height = 21
        Style = csDropDownList
        TabOrder = 0
        OnChange = cmbTriggerFrequencyChange
      end
      object chkShowOnDelete: TCheckBox
        Left = 12
        Top = 70
        Width = 200
        Height = 17
        Caption = 'Show effects on delete/backspace'
        TabOrder = 1
      end
      object chkRandomOffset: TCheckBox
        Left = 12
        Top = 93
        Width = 200
        Height = 17
        Caption = 'Add random position offset'
        TabOrder = 2
      end
    end
    object grpAnimationSettings: TGroupBox
      Left = 0
      Top = 240
      Width = 584
      Height = 180
      Caption = ' Animation Settings '
      TabOrder = 2
      object lblAnimationSpeed: TLabel
        Left = 12
        Top = 20
        Width = 91
        Height = 13
        Caption = 'Animation Speed:'
      end
      object lblSpeedValue: TLabel
        Left = 200
        Top = 20
        Width = 30
        Height = 13
        Caption = '50 ms'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlue
        Font.Height = -11
        Font.Name = 'Segoe UI'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object lblSpeedHint: TLabel
        Left = 240
        Top = 20
        Width = 42
        Height = 13
        Caption = '(Normal)'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clGray
        Font.Height = -11
        Font.Name = 'Segoe UI'
        Font.Style = [fsItalic]
        ParentFont = False
      end
      object lblDuration: TLabel
        Left = 12
        Top = 70
        Width = 49
        Height = 13
        Caption = 'Duration:'
      end
      object lblDurationValue: TLabel
        Left = 200
        Top = 70
        Width = 34
        Height = 13
        Caption = '1.0 sec'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlue
        Font.Height = -11
        Font.Name = 'Segoe UI'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object lblDurationHint: TLabel
        Left = 240
        Top = 70
        Width = 42
        Height = 13
        Caption = '(Normal)'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clGray
        Font.Height = -11
        Font.Name = 'Segoe UI'
        Font.Style = [fsItalic]
        ParentFont = False
      end
      object lblIntensity: TLabel
        Left = 12
        Top = 120
        Width = 47
        Height = 13
        Caption = 'Intensity:'
      end
      object lblIntensityValue: TLabel
        Left = 200
        Top = 120
        Width = 23
        Height = 13
        Caption = '5/10'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlue
        Font.Height = -11
        Font.Name = 'Segoe UI'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object lblIntensityHint: TLabel
        Left = 240
        Top = 116
        Width = 42
        Height = 13
        Caption = '(Normal)'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clGray
        Font.Height = -11
        Font.Name = 'Segoe UI'
        Font.Style = [fsItalic]
        ParentFont = False
      end
      object trkAnimationSpeed: TTrackBar
        Left = 12
        Top = 35
        Width = 300
        Height = 25
        Max = 200
        Min = 10
        Position = 50
        TabOrder = 0
        OnChange = trkAnimationSpeedChange
      end
      object trkDuration: TTrackBar
        Left = 12
        Top = 85
        Width = 300
        Height = 25
        Max = 3000
        Min = 500
        Position = 1000
        TabOrder = 1
        OnChange = trkDurationChange
      end
      object trkIntensity: TTrackBar
        Left = 12
        Top = 135
        Width = 300
        Height = 25
        Min = 1
        Position = 5
        TabOrder = 2
        OnChange = trkIntensityChange
      end
    end
    object grpSoundSettings: TGroupBox
      Left = 0
      Top = 430
      Width = 584
      Height = 131
      Caption = ' Sound Settings '
      TabOrder = 3
      object lblBasicKeySound: TLabel
        Left = 12
        Top = 46
        Width = 86
        Height = 13
        Caption = 'Basic Key Sound:'
      end
      object lblEnterKeySound: TLabel
        Left = 12
        Top = 76
        Width = 87
        Height = 13
        Caption = 'Enter Key Sound:'
      end
      object lblBackspaceSound: TLabel
        Left = 12
        Top = 106
        Width = 93
        Height = 13
        Caption = 'Backspace Sound:'
      end
      object chkEnableSounds: TCheckBox
        Left = 12
        Top = 20
        Width = 200
        Height = 17
        Caption = 'Enable sound effects for typing'
        TabOrder = 0
        OnClick = chkEnableSoundsClick
      end
      object edtBasicKeySound: TEdit
        Left = 115
        Top = 43
        Width = 300
        Height = 21
        TabOrder = 1
      end
      object btnBrowseBasicKey: TButton
        Left = 420
        Top = 41
        Width = 60
        Height = 25
        Caption = 'Browse...'
        TabOrder = 2
        OnClick = btnBrowseBasicKeyClick
      end
      object btnTestBasicKey: TButton
        Left = 485
        Top = 41
        Width = 40
        Height = 25
        Caption = 'Test'
        TabOrder = 3
        OnClick = btnTestBasicKeyClick
      end
      object edtEnterKeySound: TEdit
        Left = 115
        Top = 73
        Width = 300
        Height = 21
        TabOrder = 4
      end
      object btnBrowseEnterKey: TButton
        Left = 420
        Top = 71
        Width = 60
        Height = 25
        Caption = 'Browse...'
        TabOrder = 5
        OnClick = btnBrowseEnterKeyClick
      end
      object btnTestEnterKey: TButton
        Left = 485
        Top = 71
        Width = 40
        Height = 25
        Caption = 'Test'
        TabOrder = 6
        OnClick = btnTestEnterKeyClick
      end
      object edtBackspaceSound: TEdit
        Left = 115
        Top = 103
        Width = 300
        Height = 21
        TabOrder = 7
      end
      object btnBrowseBackspace: TButton
        Left = 420
        Top = 101
        Width = 60
        Height = 25
        Caption = 'Browse...'
        TabOrder = 8
        OnClick = btnBrowseBackspaceClick
      end
      object btnTestBackspace: TButton
        Left = 485
        Top = 101
        Width = 40
        Height = 25
        Caption = 'Test'
        TabOrder = 9
        OnClick = btnTestBackspaceClick
      end
    end
    object grpPreview: TGroupBox
      Left = 390
      Top = 110
      Width = 194
      Height = 310
      Caption = ' Animation Preview '
      TabOrder = 4
      object lblPreviewHint: TLabel
        Left = 12
        Top = 190
        Width = 154
        Height = 26
        Caption = 'Click Test Animation to see how the effect will look'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clGray
        Font.Height = -11
        Font.Name = 'Segoe UI'
        Font.Style = [fsItalic]
        ParentFont = False
        WordWrap = True
      end
      object pnlPreview: TPanel
        Left = 12
        Top = 20
        Width = 170
        Height = 120
        BevelOuter = bvLowered
        Color = clBlack
        ParentBackground = False
        TabOrder = 0
        object imgPreview: TImage
          Left = 1
          Top = 1
          Width = 168
          Height = 118
          Align = alClient
          Center = True
          Transparent = True
        end
      end
      object btnTestAnimation: TButton
        Left = 12
        Top = 150
        Width = 170
        Height = 30
        Caption = 'Test Animation'
        TabOrder = 1
        OnClick = btnTestAnimationClick
      end
    end
    object pnlButtons: TPanel
      Left = 0
      Top = 648
      Width = 584
      Height = 52
      BevelOuter = bvNone
      TabOrder = 5
      object btnOK: TButton
        Left = 335
        Top = 2
        Width = 75
        Height = 30
        Caption = 'OK'
        Default = True
        ModalResult = 1
        TabOrder = 0
        OnClick = btnOKClick
      end
      object btnCancel: TButton
        Left = 416
        Top = 2
        Width = 75
        Height = 30
        Cancel = True
        Caption = 'Cancel'
        ModalResult = 2
        TabOrder = 1
        OnClick = btnCancelClick
      end
      object btnReset: TButton
        Left = 497
        Top = 2
        Width = 75
        Height = 30
        Caption = 'Reset'
        TabOrder = 2
        OnClick = btnResetClick
      end
      object btnAbout: TButton
        Left = 0
        Top = 2
        Width = 75
        Height = 30
        Caption = 'About'
        TabOrder = 3
        OnClick = btnAboutClick
      end
    end
  end
  object dlgOpenSound: TOpenDialog
    DefaultExt = 'wav'
    Filter = 'WAV Audio Files (*.wav)|*.wav|All Files (*.*)|*.*'
    Left = 544
    Top = 8
  end
end
