unit TypeFXPlugin;

interface

uses
  Windows, SysUtils, Classes, Controls, Graphics, Forms, ExtCtrls, Messages,
  ToolsAPI, DesignIntf, Menus, Math, Vcl.Dialogs, TypeFXConfigForm,
  TypeFXAnimations, System.Generics.Collections, Vcl.ActnList,
  System.Types, Registry, System.Threading;

type
  // Base notifier class
  TBaseNotifier = class(TInterfacedObject, IOTANotifier)
  protected
    procedure AfterSave; virtual;
    procedure BeforeSave; virtual;
    procedure Destroyed; virtual;
    procedure Modified; virtual;
  end;

  // Forward declarations
  TTypeFXWizard = class;
  TTransparentAnimationOverlay = class;

  // Menu handler class
  TMenuHandler = class
  strict private
    Item: TMenuItem;
    Action: TProc;
    procedure OnExecute(Sender: TObject);
    constructor Create(aCaption: String; aAction: TProc; aShortcut: String);
  class var
    MenuHandlers: TObjectList<TMenuHandler>;
    FActionList: TActionList;
  public
    destructor Destroy; override;
    class constructor Create;
    class destructor Destroy;
    class procedure AddMenuItem(NTAServices: INTAServices; aCaption: String; aAction: TProc; aShortcut: String = '');
  end;

  // Enhanced cursor position info
  TCursorInfo = record
    ScreenX, ScreenY: Integer;    // Screen coordinates
    EditorX, EditorY: Integer;    // Editor client coordinates
    CharWidth, LineHeight: Integer; // Font metrics
    Valid: Boolean;               // Whether position is valid
  end;

  // TRULY TRANSPARENT overlay that WORKS
  TTransparentAnimationOverlay = class(TCustomControl)
  private
    FParticleSystem: TParticleSystem;
    FAnimationTimer: TTimer;
    FLastUpdateTime: Cardinal;
    FAnimationType: TAnimationType;
    FIntensity: Integer;
    FDuration: Integer;

  protected
    procedure CreateParams(var Params: TCreateParams); override;
    procedure Paint; override;
    procedure OnAnimationTimer(Sender: TObject);

  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    procedure StartAnimation(AType: TAnimationType; X, Y: Integer; ASpeed: Integer = 50; ADuration: Integer = 1000; AIntensity: Integer = 5);
    procedure StopAnimation;

    property AnimationType: TAnimationType read FAnimationType;
  end;

  // Keyboard hook for global keystroke detection
  TTypeFXKeyboardNotifier = class
  private
    FWizard: TTypeFXWizard;
    FHook: HHOOK;
    class var FInstance: TTypeFXKeyboardNotifier;

  public
    constructor Create(AWizard: TTypeFXWizard);
    destructor Destroy; override;

    procedure InstallHook;
    procedure UninstallHook;

    class function KeyboardProc(nCode: Integer; wParam: WPARAM; lParam: LPARAM): LRESULT; stdcall; static;
  end;

  // Main TypeFX wizard with enhanced cursor detection and sound support
  TTypeFXWizard = class(TBaseNotifier, IOTAWizard, IOTAMenuWizard)
  private
    FAnimationOverlays: TObjectList<TTransparentAnimationOverlay>;
    FKeyboardNotifier: TTypeFXKeyboardNotifier;
    FEnabled: Boolean;
    FConfig: TTypeFXConfig;
    FLastKeystrokeTime: Cardinal;
    FKeystrokeCount: Integer;

    function GetCurrentSourceEditor: IOTASourceEditor;
    function GetCurrentEditView: IOTAEditView;
    function GetEditorControlFromView(const View: IOTAEditView): TWinControl;
    function GetCursorScreenPosition: TCursorInfo;
    function GetEditorFontMetrics(EditorControl: TWinControl): TCursorInfo;
    function FindEditorControl(Form: TCustomForm): TWinControl;
    procedure LoadSettings;
    procedure SaveSettings;

  public
    constructor Create;
    destructor Destroy; override;

    // IOTAWizard methods
    function GetIDString: string;
    function GetName: string;
    function GetState: TWizardState;
    procedure Execute;

    // IOTAMenuWizard
    function GetMenuText: string;

    // Custom methods
    procedure OnKeystroke(Ch: Char; IsKeyDown: Boolean);
    procedure TriggerTypingEffect;
    procedure ToggleEnabled;
    procedure ShowConfigDialog;
    procedure CleanupOverlays;

    // NEW: Sound-related methods
    procedure PlayKeystrokeSound(Ch: Char);

    property Enabled: Boolean read FEnabled write FEnabled;
    property Config: TTypeFXConfig read FConfig write FConfig;
  end;

var
  TypeFXWizard: TTypeFXWizard;
  TypeFXWizardIndex: Integer = -1;
  MenusCreated: Boolean = False;
  GlobalNTAServices: INTAServices;

// Wrapper procedures for TProc compatibility
procedure DoToggleTypeFX;
procedure DoShowTypeFXConfig;

// Helper procedures
procedure CreateMenuItems;

procedure Register;

implementation

// Helper procedures
procedure CreateMenuItems;
begin
  if not MenusCreated and Assigned(GlobalNTAServices) then
  begin
    TMenuHandler.AddMenuItem(GlobalNTAServices, '-', nil);
    TMenuHandler.AddMenuItem(GlobalNTAServices, 'TypeFX Studio &Settings...', DoShowTypeFXConfig);
    TMenuHandler.AddMenuItem(GlobalNTAServices, 'Toggle TypeFX &Effects', DoToggleTypeFX, 'Ctrl+Shift+T');
    MenusCreated := True;
  end;
end;

// Wrapper procedures for TProc compatibility
procedure DoToggleTypeFX;
begin
  if Assigned(TypeFXWizard) then
    TypeFXWizard.ToggleEnabled;
end;

procedure DoShowTypeFXConfig;
begin
  if Assigned(TypeFXWizard) then
    TypeFXWizard.ShowConfigDialog;
end;

procedure Register;
begin
  // Create the wizard
  TypeFXWizard := TTypeFXWizard.Create;
  TypeFXWizardIndex := (BorlandIDEServices as IOTAWizardServices).AddWizard(TypeFXWizard);

  if not Supports(BorlandIDEServices, INTAServices, GlobalNTAServices) then
    Exit;

  // Create menu items after a delay
  TThread.CreateAnonymousThread(
    procedure
    begin
      Sleep(2000); // Give IDE time to initialize
      TThread.Synchronize(TThread.CurrentThread, CreateMenuItems);
    end).Start;
end;

{ TMenuHandler }

class constructor TMenuHandler.Create;
begin
  MenuHandlers := TObjectList<TMenuHandler>.Create;
  FActionList := TActionList.Create(nil);
end;

class destructor TMenuHandler.Destroy;
begin
  MenuHandlers.Free;
  FActionList.Free;
end;

constructor TMenuHandler.Create(aCaption: String; aAction: TProc; aShortcut: String);
var
  MyAction: TAction;
begin
  inherited Create;
  Action := aAction;
  MyAction := TAction.Create(FActionList);
  MyAction.Caption := aCaption;
  MyAction.OnExecute := OnExecute;
  MyAction.ActionList := FActionList;

  Item := TMenuItem.Create(nil);
  Item.Action := MyAction;
  Item.Caption := aCaption;

  if aShortcut <> '' then
    Item.Caption := aCaption + #9 + aShortcut;
end;

destructor TMenuHandler.Destroy;
begin
  FreeAndNil(Item);
  inherited;
end;

procedure TMenuHandler.OnExecute(Sender: TObject);
begin
  if Assigned(Action) then
    Action;
end;

class procedure TMenuHandler.AddMenuItem(NTAServices: INTAServices; aCaption: String; aAction: TProc; aShortcut: String = '');
begin
  var handler := TMenuHandler.Create(aCaption, aAction, aShortcut);
  MenuHandlers.Add(handler);
  NTAServices.AddActionMenu('ToolsMenu', nil, handler.Item, False, True);
end;

{ TBaseNotifier }

procedure TBaseNotifier.AfterSave;
begin
end;

procedure TBaseNotifier.BeforeSave;
begin
end;

procedure TBaseNotifier.Destroyed;
begin
end;

procedure TBaseNotifier.Modified;
begin
end;

{ TTransparentAnimationOverlay }

constructor TTransparentAnimationOverlay.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FAnimationType := atNone;
  FIntensity := 5;
  FDuration := 1000;
  FLastUpdateTime := GetTickCount;

  // Larger size for better visibility
  Width := 100;
  Height := 80;

  // Create animation timer
  FAnimationTimer := TTimer.Create(Self);
  FAnimationTimer.Enabled := False;
  FAnimationTimer.OnTimer := OnAnimationTimer;
  FAnimationTimer.Interval := 16; // ~60 FPS

  // Set control style for transparency
  ControlStyle := ControlStyle + [csOpaque];
  SetBounds(0, 0, Width, Height);
end;

procedure TTransparentAnimationOverlay.CreateParams(var Params: TCreateParams);
begin
  inherited CreateParams(Params);

  // CRITICAL: Make it truly transparent and click-through
  Params.ExStyle := Params.ExStyle or WS_EX_TRANSPARENT or WS_EX_LAYERED;

  // Remove all window decorations
  Params.Style := Params.Style and not (WS_BORDER or WS_DLGFRAME);

  // Set transparent window class
  Params.WindowClass.hbrBackground := 0;
end;

destructor TTransparentAnimationOverlay.Destroy;
begin
  StopAnimation;
  if Assigned(FParticleSystem) then
    FParticleSystem.Free;
  FAnimationTimer.Free;
  inherited Destroy;
end;

procedure TTransparentAnimationOverlay.OnAnimationTimer(Sender: TObject);
var
  CurrentTime: Cardinal;
  DeltaTime: Double;
begin
  if not Assigned(FParticleSystem) then Exit;

  CurrentTime := GetTickCount;
  DeltaTime := (CurrentTime - FLastUpdateTime) / 1000.0;
  FLastUpdateTime := CurrentTime;

  if DeltaTime > 0.1 then
    DeltaTime := 0.1;

  FParticleSystem.Update(DeltaTime);

  // Check if animation is complete
  if not FParticleSystem.IsAlive then
  begin
    StopAnimation;
    Exit;
  end;

  // Force repaint
  Invalidate;
end;

procedure TTransparentAnimationOverlay.Paint;
begin
  // DON'T call inherited Paint to avoid background

  if not Assigned(FParticleSystem) or (FAnimationType = atNone) or not Visible then
    Exit;

  try
    // Set up canvas for transparency
    Canvas.Brush.Style := bsClear;

    // Make the background TRULY transparent by using the color key
    Canvas.Brush.Color := RGB(1, 1, 1); // Very dark color as transparent key
    Canvas.FillRect(ClientRect);

    // Set layered window attributes for REAL transparency
    if HandleAllocated then
      SetLayeredWindowAttributes(Handle, RGB(1, 1, 1), 255, LWA_COLORKEY);

    // Render particle system
    FParticleSystem.Render(Canvas, Width div 2, Height div 2);

  except
    // Ignore paint errors
  end;
end;

procedure TTransparentAnimationOverlay.StartAnimation(AType: TAnimationType; X, Y: Integer; ASpeed: Integer = 50; ADuration: Integer = 1000; AIntensity: Integer = 5);
begin
  StopAnimation;

  FAnimationType := AType;
  FIntensity := AIntensity;
  FDuration := ADuration;
  FLastUpdateTime := GetTickCount;

  // Position the overlay above the cursor
  Left := X - (Width div 2);
  Top := Y - Height + 20; // Position above cursor

  // Ensure it's within parent bounds
  if Assigned(Parent) then
  begin
    if Left < 0 then Left := 0;
    if Top < 0 then Top := 0;
    if Left + Width > Parent.Width then Left := Parent.Width - Width;
    if Top + Height > Parent.Height then Top := Parent.Height - Height;
  end;

  // Create new particle system
  if Assigned(FParticleSystem) then
    FParticleSystem.Free;

  FParticleSystem := TParticleSystem.Create(FAnimationType, FIntensity, FDuration);

  // Show the overlay
  Visible := True;
  BringToFront;

  // CRITICAL: Apply transparency AFTER showing
  if HandleAllocated then
  begin
    SetLayeredWindowAttributes(Handle, RGB(1, 1, 1), 255, LWA_COLORKEY);
  end;

  // Start animation
  FAnimationTimer.Enabled := True;
end;

procedure TTransparentAnimationOverlay.StopAnimation;
begin
  FAnimationTimer.Enabled := False;
  FAnimationType := atNone;
  Visible := False;

  if Assigned(FParticleSystem) then
  begin
    FParticleSystem.Free;
    FParticleSystem := nil;
  end;
end;

{ TTypeFXKeyboardNotifier }

constructor TTypeFXKeyboardNotifier.Create(AWizard: TTypeFXWizard);
begin
  inherited Create;
  FWizard := AWizard;
  FHook := 0;
  FInstance := Self;
end;

destructor TTypeFXKeyboardNotifier.Destroy;
begin
  UninstallHook;
  FInstance := nil;
  inherited Destroy;
end;

procedure TTypeFXKeyboardNotifier.InstallHook;
begin
  if FHook = 0 then
    FHook := SetWindowsHookEx(WH_KEYBOARD, @KeyboardProc, HInstance, GetCurrentThreadId);
end;

procedure TTypeFXKeyboardNotifier.UninstallHook;
begin
  if FHook <> 0 then
  begin
    UnhookWindowsHookEx(FHook);
    FHook := 0;
  end;
end;

class function TTypeFXKeyboardNotifier.KeyboardProc(nCode: Integer; wParam: WPARAM; lParam: LPARAM): LRESULT;
var
  Ch: Char;
  IsKeyDown: Boolean;
begin
  Result := CallNextHookEx(0, nCode, wParam, lParam);

  if (nCode >= 0) and (nCode = HC_ACTION) and Assigned(FInstance) and Assigned(FInstance.FWizard) then
  begin
    IsKeyDown := (lParam and $80000000) = 0;

    if IsKeyDown and (wParam >= 32) and (wParam <= 126) then // Printable characters on key down
    begin
      Ch := Chr(wParam);
      FInstance.FWizard.OnKeystroke(Ch, IsKeyDown);
    end
    else if IsKeyDown then
    begin
      // Handle special keys - EXPANDED VERSION
      case wParam of
        VK_RETURN: // Enter key
        begin
          Ch := #13;
          FInstance.FWizard.OnKeystroke(Ch, IsKeyDown);
        end;
        VK_BACK: // Backspace key
        begin
          Ch := #8;
          FInstance.FWizard.OnKeystroke(Ch, IsKeyDown);
        end;
        VK_TAB: // Tab key
        begin
          Ch := #9;
          FInstance.FWizard.OnKeystroke(Ch, IsKeyDown);
        end;
        VK_ESCAPE: // Escape key
        begin
          Ch := #27;
          FInstance.FWizard.OnKeystroke(Ch, IsKeyDown);
        end;
        VK_DELETE: // Delete key
        begin
          Ch := #127;
          FInstance.FWizard.OnKeystroke(Ch, IsKeyDown);
        end;
        VK_INSERT: // Insert key
        begin
          Ch := #45; // Use a unique character for Insert
          FInstance.FWizard.OnKeystroke(Ch, IsKeyDown);
        end;
        VK_HOME: // Home key
        begin
          Ch := #36; // Use a unique character for Home
          FInstance.FWizard.OnKeystroke(Ch, IsKeyDown);
        end;
        VK_END: // End key
        begin
          Ch := #35; // Use a unique character for End
          FInstance.FWizard.OnKeystroke(Ch, IsKeyDown);
        end;
        VK_PRIOR: // Page Up
        begin
          Ch := #33; // Use a unique character for Page Up
          FInstance.FWizard.OnKeystroke(Ch, IsKeyDown);
        end;
        VK_NEXT: // Page Down
        begin
          Ch := #34; // Use a unique character for Page Down
          FInstance.FWizard.OnKeystroke(Ch, IsKeyDown);
        end;
        VK_UP, VK_DOWN, VK_LEFT, VK_RIGHT: // Arrow keys
        begin
          Ch := Chr(wParam); // Use the virtual key code as character
          FInstance.FWizard.OnKeystroke(Ch, IsKeyDown);
        end;
        VK_F1..VK_F12: // Function keys F1-F12
        begin
          Ch := Chr(wParam); // Use the virtual key code as character
          FInstance.FWizard.OnKeystroke(Ch, IsKeyDown);
        end;
        // SPECIAL SYMBOLS that might not be in ASCII 32-126 range
        VK_OEM_MINUS: // - key
        begin
          Ch := '-';
          FInstance.FWizard.OnKeystroke(Ch, IsKeyDown);
        end;
        VK_OEM_PLUS: // = key (+ when shifted)
        begin
          Ch := '=';
          FInstance.FWizard.OnKeystroke(Ch, IsKeyDown);
        end;
        VK_OEM_1: // ; key (: when shifted)
        begin
          Ch := ';';
          FInstance.FWizard.OnKeystroke(Ch, IsKeyDown);
        end;
        VK_OEM_2: // / key (? when shifted)
        begin
          Ch := '/';
          FInstance.FWizard.OnKeystroke(Ch, IsKeyDown);
        end;
        VK_OEM_3: // ` key (~ when shifted)
        begin
          Ch := '`';
          FInstance.FWizard.OnKeystroke(Ch, IsKeyDown);
        end;
        VK_OEM_4: // [ key ({ when shifted)
        begin
          Ch := '[';
          FInstance.FWizard.OnKeystroke(Ch, IsKeyDown);
        end;
        VK_OEM_5: // \ key (| when shifted)
        begin
          Ch := '\';
          FInstance.FWizard.OnKeystroke(Ch, IsKeyDown);
        end;
        VK_OEM_6: // ] key (} when shifted)
        begin
          Ch := ']';
          FInstance.FWizard.OnKeystroke(Ch, IsKeyDown);
        end;
        VK_OEM_7: // ' key (" when shifted)
        begin
          Ch := '''';
          FInstance.FWizard.OnKeystroke(Ch, IsKeyDown);
        end;
        VK_OEM_COMMA: // , key (< when shifted)
        begin
          Ch := ',';
          FInstance.FWizard.OnKeystroke(Ch, IsKeyDown);
        end;
        VK_OEM_PERIOD: // . key (> when shifted)
        begin
          Ch := '.';
          FInstance.FWizard.OnKeystroke(Ch, IsKeyDown);
        end;
        // NUMPAD KEYS
        VK_NUMPAD0..VK_NUMPAD9:
        begin
          Ch := Chr(Ord('0') + (wParam - VK_NUMPAD0));
          FInstance.FWizard.OnKeystroke(Ch, IsKeyDown);
        end;
        VK_MULTIPLY: // Numpad *
        begin
          Ch := '*';
          FInstance.FWizard.OnKeystroke(Ch, IsKeyDown);
        end;
        VK_ADD: // Numpad +
        begin
          Ch := '+';
          FInstance.FWizard.OnKeystroke(Ch, IsKeyDown);
        end;
        VK_SUBTRACT: // Numpad -
        begin
          Ch := '-';
          FInstance.FWizard.OnKeystroke(Ch, IsKeyDown);
        end;
        VK_DECIMAL: // Numpad .
        begin
          Ch := '.';
          FInstance.FWizard.OnKeystroke(Ch, IsKeyDown);
        end;
        VK_DIVIDE: // Numpad /
        begin
          Ch := '/';
          FInstance.FWizard.OnKeystroke(Ch, IsKeyDown);
        end;
      end;
    end;
  end;
end;

{ TTypeFXWizard }

constructor TTypeFXWizard.Create;
begin
  inherited Create;
  FAnimationOverlays := TObjectList<TTransparentAnimationOverlay>.Create(True);
  FEnabled := True;
  FLastKeystrokeTime := 0;
  FKeystrokeCount := 0;

  // Initialize default config
  FConfig := GetDefaultTypeFXConfig;

  LoadSettings;

  // Create keyboard notifier
  FKeyboardNotifier := TTypeFXKeyboardNotifier.Create(Self);
  FKeyboardNotifier.InstallHook;
end;

destructor TTypeFXWizard.Destroy;
begin
  SaveSettings;
  CleanupOverlays;

  if Assigned(FKeyboardNotifier) then
    FKeyboardNotifier.Free;

  FAnimationOverlays.Free;

  inherited Destroy;
end;

function TTypeFXWizard.GetIDString: string;
begin
  Result := 'TypeFXStudio.Plugin.TypingEffects.v2.3'; // Updated version
end;

function TTypeFXWizard.GetName: string;
begin
  Result := 'TypeFX Studio - Professional Visual Typing Effects with Sound';
end;

function TTypeFXWizard.GetMenuText: string;
begin
  Result := 'TypeFX Studio - Professional Typing Animation Effects with Sound';
end;

function TTypeFXWizard.GetState: TWizardState;
begin
  Result := [wsEnabled];
end;

function TTypeFXWizard.GetCurrentSourceEditor: IOTASourceEditor;
var
  ModuleServices: IOTAModuleServices;
  Module: IOTAModule;
  Editor: IOTAEditor;
  i: Integer;
begin
  Result := nil;
  if not Supports(BorlandIDEServices, IOTAModuleServices, ModuleServices) then
    Exit;

  Module := ModuleServices.CurrentModule;
  if not Assigned(Module) then
    Exit;

  for i := 0 to Module.ModuleFileCount - 1 do
  begin
    Editor := Module.ModuleFileEditors[i];
    if Supports(Editor, IOTASourceEditor, Result) then
      Break;
  end;
end;

function TTypeFXWizard.GetCurrentEditView: IOTAEditView;
var
  SourceEditor: IOTASourceEditor;
begin
  Result := nil;
  SourceEditor := GetCurrentSourceEditor;
  if Assigned(SourceEditor) and (SourceEditor.EditViewCount > 0) then
    Result := SourceEditor.EditViews[0];
end;

function TTypeFXWizard.GetEditorControlFromView(const View: IOTAEditView): TWinControl;
var
  EditWindow: INTAEditWindow;
  Form: TCustomForm;
begin
  Result := nil;

  if Supports(View, INTAEditWindow, EditWindow) then
  begin
    Form := EditWindow.Form;
    if Assigned(Form) then
      Result := FindEditorControl(Form);
  end;
end;

function TTypeFXWizard.FindEditorControl(Form: TCustomForm): TWinControl;

  function SearchControlRecursive(Parent: TWinControl): TWinControl;
  var
    i: Integer;
    Control: TControl;
    ChildResult: TWinControl;
  begin
    Result := nil;

    for i := 0 to Parent.ControlCount - 1 do
    begin
      Control := Parent.Controls[i];

      // Check if this is the editor control we're looking for
      if (Control.ClassName = 'TEditorControl') or
         (Control.ClassName = 'TEditControl') or
         (Control.ClassName = 'TSynEdit') or
         (Control.ClassName = 'TCustomSynEdit') or
         (Pos('Editor', Control.ClassName) > 0) then
      begin
        Result := TWinControl(Control);
        Exit;
      end;

      // Recursively search child controls
      if Control is TWinControl then
      begin
        ChildResult := SearchControlRecursive(TWinControl(Control));
        if Assigned(ChildResult) then
        begin
          Result := ChildResult;
          Exit;
        end;
      end;
    end;
  end;

begin
  Result := nil;

  if not Assigned(Form) then Exit;

  // Search recursively through all controls
  Result := SearchControlRecursive(Form);

  // If still not found, use the form itself as fallback
  if not Assigned(Result) then
    Result := Form;
end;

function TTypeFXWizard.GetEditorFontMetrics(EditorControl: TWinControl): TCursorInfo;
var
  DC: HDC;
  TextMetrics: TTextMetric;
  SaveFont: HFONT;
begin
  Result.Valid := False;
  Result.CharWidth := 7;   // Conservative default
  Result.LineHeight := 14; // Conservative default

  if not Assigned(EditorControl) then Exit;

  try
    // Try to get font metrics from the control's device context
    if EditorControl.HandleAllocated then
    begin
      DC := GetDC(EditorControl.Handle);
      try
        // Try to get the actual font being used
        SaveFont := GetCurrentObject(DC, OBJ_FONT);
        if SaveFont <> 0 then
        begin
          if GetTextMetrics(DC, TextMetrics) then
          begin
            Result.CharWidth := TextMetrics.tmAveCharWidth;
            Result.LineHeight := TextMetrics.tmHeight;
            Result.Valid := True;
          end;
        end;
      finally
        ReleaseDC(EditorControl.Handle, DC);
      end;
    end;

    // If we got valid metrics, we're done
    if Result.Valid then Exit;

    // Fallback: Use more conservative estimates for typical IDE fonts
    Result.CharWidth := 7;   // Typical for Consolas/Courier New at 10pt
    Result.LineHeight := 14; // Typical line height
    Result.Valid := True;

  except
    // Use safe defaults on any error
    Result.CharWidth := 7;
    Result.LineHeight := 14;
    Result.Valid := True;
  end;
end;

function TTypeFXWizard.GetCursorScreenPosition: TCursorInfo;
var
  EditView: IOTAEditView;
  EditorControl: TWinControl;
  CursorPos: TOTAEditPos;
  FontMetrics: TCursorInfo;
  TopRow, LeftCol: Integer;
  DC: HDC;
  TextMetrics: TTextMetric;
  i: Integer;
  Control: TControl;
  ActualEditor: TWinControl;
begin
  Result.Valid := False;

  try
    EditView := GetCurrentEditView;
    if not Assigned(EditView) then Exit;

    EditorControl := GetEditorControlFromView(EditView);
    if not Assigned(EditorControl) then Exit;

    // Find the ACTUAL text editor control (not just the form)
    ActualEditor := nil;
    if EditorControl is TCustomForm then
    begin
      // Search for the real editor control within the form
      for i := 0 to TCustomForm(EditorControl).ControlCount - 1 do
      begin
        Control := TCustomForm(EditorControl).Controls[i];
        if (Control is TWinControl) and
           ((Pos('Edit', Control.ClassName) > 0) or
            (Pos('Syn', Control.ClassName) > 0) or
            (Control.ClassName = 'TEditorControl')) then
        begin
          ActualEditor := TWinControl(Control);
          Break;
        end;
      end;
    end;

    if not Assigned(ActualEditor) then
      ActualEditor := EditorControl;

    // Get font metrics
    Result.CharWidth := 8;  // Safe default
    Result.LineHeight := 16; // Safe default

    if ActualEditor.HandleAllocated then
    begin
      DC := GetDC(ActualEditor.Handle);
      try
        if GetTextMetrics(DC, TextMetrics) then
        begin
          Result.CharWidth := TextMetrics.tmAveCharWidth;
          Result.LineHeight := TextMetrics.tmHeight;
        end;
      finally
        ReleaseDC(ActualEditor.Handle, DC);
      end;
    end;

    // Get cursor position and view info
    CursorPos := EditView.CursorPos;
    TopRow := EditView.TopRow;

    try
      LeftCol := EditView.LeftColumn;
    except
      LeftCol := 1;
    end;

    // Simple calculation with minimal offset
    Result.EditorX := (CursorPos.Col - LeftCol) * Result.CharWidth + 5;
    Result.EditorY := (CursorPos.Line - TopRow) * Result.LineHeight + 5;

    // Keep within reasonable bounds
    if Result.EditorX < 5 then Result.EditorX := 5;
    if Result.EditorY < 5 then Result.EditorY := 5;
    if Result.EditorX > ActualEditor.Width - 50 then
      Result.EditorX := ActualEditor.Width - 50;
    if Result.EditorY > ActualEditor.Height - 50 then
      Result.EditorY := ActualEditor.Height - 50;

    Result.ScreenX := Result.EditorX;
    Result.ScreenY := Result.EditorY;
    Result.Valid := True;

  except
    Result.Valid := False;
  end;
end;

procedure TTypeFXWizard.Execute;
begin
  ShowConfigDialog;
end;

// NEW: Sound playback method
procedure TTypeFXWizard.PlayKeystrokeSound(Ch: Char);
begin
  if not FConfig.SoundSettings.EnableSounds then
    Exit;

  // Determine which sound to play based on the character
  case Ch of
    #13: // Enter key
      TSoundManager.GetInstance.PlayEnterKeySound(FConfig);
    #8:  // Backspace key
      TSoundManager.GetInstance.PlayBackspaceSound(FConfig);
    else // All other keys
      TSoundManager.GetInstance.PlayBasicKeySound(FConfig);
  end;
end;

procedure TTypeFXWizard.OnKeystroke(Ch: Char; IsKeyDown: Boolean);
var
  CurrentTime: Cardinal;
  ShouldTrigger: Boolean;
begin
  if not FEnabled or not IsKeyDown then
    Exit;

  CurrentTime := GetTickCount;
  Inc(FKeystrokeCount);

  // NEW: Play sound for keystroke
  PlayKeystrokeSound(Ch);

  // Implement frequency control
  case FConfig.TriggerFrequency of
    tfEveryKey:
      ShouldTrigger := True;
    tfEveryOtherKey:
      ShouldTrigger := (FKeystrokeCount mod 2) = 0;
    tfEveryWord:
      ShouldTrigger := (Ch = ' ') or (Ch = #13) or (Ch = #9);
    tfEveryLine:
      ShouldTrigger := (Ch = #13);
  else
    ShouldTrigger := True;
  end;

  // Handle backspace effects
  if (Ch = #8) and not FConfig.ShowOnDelete then
    ShouldTrigger := False;

  if ShouldTrigger and ((CurrentTime - FLastKeystrokeTime) > 100) then // Throttle to prevent spam
  begin
    FLastKeystrokeTime := CurrentTime;
    TriggerTypingEffect;
  end;
end;

procedure TTypeFXWizard.TriggerTypingEffect;
var
  Overlay: TTransparentAnimationOverlay;
  EditView: IOTAEditView;
  AnimType: TAnimationType;
  CursorPos: TOTAEditPos;
  X, Y: Integer;
  CharWidth, LineHeight: Integer;
  FocusedWindow: HWND;
  CaretPos: TPoint;
  ScreenPos: TPoint;
  ParentWindow: HWND;
  WindowRect: TRect;
begin
  EditView := GetCurrentEditView;
  if not Assigned(EditView) then Exit;

  // Choose animation type based on config
  case FConfig.EffectStyle of
    esFire: AnimType := atFire;
    esLightning: AnimType := atLightning;
    esMagic: AnimType := atMagic;
    esExplosion: AnimType := atExplosion;
    esSparks: AnimType := atSparks;
    esMatrix: AnimType := atMatrix;
    esRainbow: AnimType := atRainbow;
    esIce: AnimType := atIce;
    esFlame: AnimType := atFlame;
    esStars: AnimType := atStars;
    esSmoke: AnimType := atSmoke;
    esNeon: AnimType := atNeon;
    esPlasma: AnimType := atPlasma;
    esWind: AnimType := atWind;
    esGold: AnimType := atGold;
    esLaser: AnimType := atLaser;
    esCrystal: AnimType := atCrystal;
    else AnimType := atFire;
  end;

  try
    // Get the ACTUAL focused window (where user is typing)
    FocusedWindow := GetFocus;
    if FocusedWindow = 0 then Exit;

    // Try to get the actual caret position
    if GetCaretPos(CaretPos) then
    begin
      // Convert to screen coordinates
      if ClientToScreen(FocusedWindow, CaretPos) then
      begin
        X := CaretPos.X;
        Y := CaretPos.Y;

        // Find a parent window to attach our overlay to
        ParentWindow := GetParent(FocusedWindow);
        while (ParentWindow <> 0) and (GetParent(ParentWindow) <> 0) do
          ParentWindow := GetParent(ParentWindow);

        if ParentWindow = 0 then
          ParentWindow := FocusedWindow;

        // Get the parent window rect to convert back to relative coordinates
        if GetWindowRect(ParentWindow, WindowRect) then
        begin
          X := X - WindowRect.Left;
          Y := Y - WindowRect.Top;
        end;

        // Find the Delphi control for this window handle
        var ParentControl := FindControl(ParentWindow);
        if not Assigned(ParentControl) then
          ParentControl := Application.MainForm;

        // Add random offset if enabled
        if FConfig.RandomOffset then
        begin
          X := X + Random(20) - 10;
          Y := Y + Random(15) - 7;
        end;

        // Create new overlay
        Overlay := TTransparentAnimationOverlay.Create(ParentControl);
        Overlay.Parent := ParentControl as TWinControl;

        // Start animation at the REAL caret position
        Overlay.StartAnimation(
          AnimType,
          X,
          Y,
          FConfig.AnimationSpeed,
          FConfig.Duration,
          FConfig.Intensity
        );

        // Add to our list for cleanup
        FAnimationOverlays.Add(Overlay);

        // Clean up old overlays
        CleanupOverlays;

        Exit; // Success!
      end;
    end;

    // If caret method failed, fallback to simple positioning
    Exit;

  except
    // Handle any positioning errors silently
  end;
end;

procedure TTypeFXWizard.CleanupOverlays;
var
  i: Integer;
begin
  // Remove invisible/completed overlays
  for i := FAnimationOverlays.Count - 1 downto 0 do
  begin
    if not FAnimationOverlays[i].Visible or
       (FAnimationOverlays[i].AnimationType = atNone) then
    begin
      FAnimationOverlays.Delete(i);
    end;
  end;

  // Limit total overlays to prevent memory issues
  while FAnimationOverlays.Count > 15 do
    FAnimationOverlays.Delete(0);
end;

procedure TTypeFXWizard.ToggleEnabled;
begin
  FEnabled := not FEnabled;
  SaveSettings;

  if not FEnabled then
    CleanupOverlays;

  // Show status message
  if FEnabled then
    ShowMessage('TypeFX Studio Professional Effects Enabled!')
  else
    ShowMessage('TypeFX Studio Effects Disabled.');
end;

procedure TTypeFXWizard.ShowConfigDialog;
begin
  if TfrmTypeFXConfig.ShowConfigDialog(FConfig) then
  begin
    SaveSettings;
    ShowMessage('TypeFX Studio Professional Settings Saved!');
  end;
end;

procedure TTypeFXWizard.LoadSettings;
var
  Reg: TRegistry;
begin
  Reg := TRegistry.Create(KEY_READ);
  try
    Reg.RootKey := HKEY_CURRENT_USER;
    if Reg.OpenKey('Software\TypeFXStudio', False) then
    begin
      try
        if Reg.ValueExists('Enabled') then
          FEnabled := Reg.ReadBool('Enabled');
        if Reg.ValueExists('EffectStyle') then
          FConfig.EffectStyle := TEffectStyle(Reg.ReadInteger('EffectStyle'));
        if Reg.ValueExists('TriggerFrequency') then
          FConfig.TriggerFrequency := TTriggerFrequency(Reg.ReadInteger('TriggerFrequency'));
        if Reg.ValueExists('AnimationSpeed') then
          FConfig.AnimationSpeed := Reg.ReadInteger('AnimationSpeed');
        if Reg.ValueExists('Duration') then
          FConfig.Duration := Reg.ReadInteger('Duration');
        if Reg.ValueExists('ShowOnDelete') then
          FConfig.ShowOnDelete := Reg.ReadBool('ShowOnDelete');
        if Reg.ValueExists('Intensity') then
          FConfig.Intensity := Reg.ReadInteger('Intensity');
        if Reg.ValueExists('RandomOffset') then
          FConfig.RandomOffset := Reg.ReadBool('RandomOffset');

        // NEW: Load sound settings
        if Reg.ValueExists('EnableSounds') then
          FConfig.SoundSettings.EnableSounds := Reg.ReadBool('EnableSounds');
        if Reg.ValueExists('SoundVolume') then
          FConfig.SoundSettings.SoundVolume := Reg.ReadInteger('SoundVolume');
        if Reg.ValueExists('BasicKeySound') then
          FConfig.SoundSettings.BasicKeySound := Reg.ReadString('BasicKeySound');
        if Reg.ValueExists('EnterKeySound') then
          FConfig.SoundSettings.EnterKeySound := Reg.ReadString('EnterKeySound');
        if Reg.ValueExists('BackspaceSound') then
          FConfig.SoundSettings.BackspaceSound := Reg.ReadString('BackspaceSound');
      except
        // Use defaults on read errors
      end;
    end;
  finally
    Reg.Free;
  end;
end;

procedure TTypeFXWizard.SaveSettings;
var
  Reg: TRegistry;
begin
  Reg := TRegistry.Create(KEY_WRITE);
  try
    Reg.RootKey := HKEY_CURRENT_USER;
    if Reg.OpenKey('Software\TypeFXStudio', True) then
    begin
      try
        Reg.WriteBool('Enabled', FEnabled);
        Reg.WriteInteger('EffectStyle', Ord(FConfig.EffectStyle));
        Reg.WriteInteger('TriggerFrequency', Ord(FConfig.TriggerFrequency));
        Reg.WriteInteger('AnimationSpeed', FConfig.AnimationSpeed);
        Reg.WriteInteger('Duration', FConfig.Duration);
        Reg.WriteBool('ShowOnDelete', FConfig.ShowOnDelete);
        Reg.WriteInteger('Intensity', FConfig.Intensity);
        Reg.WriteBool('RandomOffset', FConfig.RandomOffset);

        // NEW: Save sound settings
        Reg.WriteBool('EnableSounds', FConfig.SoundSettings.EnableSounds);
        Reg.WriteInteger('SoundVolume', FConfig.SoundSettings.SoundVolume);
        Reg.WriteString('BasicKeySound', FConfig.SoundSettings.BasicKeySound);
        Reg.WriteString('EnterKeySound', FConfig.SoundSettings.EnterKeySound);
        Reg.WriteString('BackspaceSound', FConfig.SoundSettings.BackspaceSound);
      except
        // Ignore write errors
      end;
    end;
  finally
    Reg.Free;
  end;
end;

initialization

finalization
  if (TypeFXWizardIndex >= 0) and Assigned(BorlandIDEServices) then
  begin
    try
      (BorlandIDEServices as IOTAWizardServices).RemoveWizard(TypeFXWizardIndex);
    except
      // Ignore errors during IDE shutdown
    end;
    TypeFXWizardIndex := -1;
  end;

  if Assigned(TypeFXWizard) then
  begin
    try
      TypeFXWizard.Free;
    except
      // Ignore errors during shutdown
    end;
    TypeFXWizard := nil;
  end;

end.
