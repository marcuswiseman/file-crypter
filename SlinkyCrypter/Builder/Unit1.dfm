object Form1: TForm1
  Left = 192
  Top = 124
  BorderStyle = bsToolWindow
  Caption = 'Slinky Crypter'
  ClientHeight = 149
  ClientWidth = 390
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 8
    Top = 16
    Width = 26
    Height = 13
    Caption = 'Input'
  end
  object Label2: TLabel
    Left = 11
    Top = 43
    Width = 22
    Height = 13
    Caption = 'Stub'
  end
  object Label4: TLabel
    Left = 5
    Top = 71
    Width = 30
    Height = 13
    Caption = 'Mutex'
  end
  object Label9: TLabel
    Left = 152
    Top = 128
    Width = 207
    Height = 13
    Caption = 'Thank you for purchasing Slinky Crypter! ;]'
  end
  object Edit1: TEdit
    Left = 38
    Top = 13
    Width = 94
    Height = 21
    TabOrder = 0
  end
  object Button1: TButton
    Left = 136
    Top = 11
    Width = 27
    Height = 25
    Caption = '...'
    TabOrder = 1
    OnClick = Button1Click
  end
  object Edit2: TEdit
    Left = 37
    Top = 40
    Width = 94
    Height = 21
    TabOrder = 2
  end
  object Button2: TButton
    Left = 136
    Top = 38
    Width = 27
    Height = 25
    Caption = '...'
    TabOrder = 3
    OnClick = Button2Click
  end
  object Edit4: TEdit
    Left = 37
    Top = 68
    Width = 94
    Height = 21
    TabOrder = 4
  end
  object Button5: TButton
    Left = 136
    Top = 66
    Width = 27
    Height = 25
    Caption = 'Gen'
    TabOrder = 5
    OnClick = Button5Click
  end
  object GroupBox2: TGroupBox
    Left = 320
    Top = 1
    Width = 65
    Height = 97
    Caption = 'Icon'
    TabOrder = 6
    object Image1: TImage
      Left = 8
      Top = 16
      Width = 48
      Height = 48
      Center = True
      Stretch = True
    end
    object Button6: TButton
      Left = 13
      Top = 68
      Width = 35
      Height = 25
      Caption = 'Load'
      TabOrder = 0
      OnClick = Button6Click
    end
  end
  object GroupBox1: TGroupBox
    Left = 168
    Top = 1
    Width = 145
    Height = 97
    Caption = 'Output Information'
    TabOrder = 7
    object Label3: TLabel
      Left = 41
      Top = 15
      Width = 47
      Height = 13
      Caption = 'Size : N/A'
      Color = clBtnFace
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clRed
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentColor = False
      ParentFont = False
    end
    object Label5: TLabel
      Left = 39
      Top = 31
      Width = 44
      Height = 13
      Caption = 'Icon : No'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clRed
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
    object Label6: TLabel
      Left = 8
      Top = 47
      Width = 81
      Height = 13
      Caption = 'Encryption : RC4'
    end
    object Button3: TButton
      Left = 31
      Top = 66
      Width = 81
      Height = 25
      Caption = 'Crypt'
      TabOrder = 0
      OnClick = Button3Click
    end
  end
  object GroupBox3: TGroupBox
    Left = 8
    Top = 98
    Width = 121
    Height = 47
    Caption = 'Pump'
    TabOrder = 8
    object Label7: TLabel
      Left = 8
      Top = 18
      Width = 19
      Height = 13
      Caption = 'Size'
    end
    object Label8: TLabel
      Left = 99
      Top = 19
      Width = 14
      Height = 13
      Caption = 'MB'
    end
    object Edit3: TEdit
      Left = 32
      Top = 16
      Width = 48
      Height = 21
      TabOrder = 0
      Text = '0'
    end
    object UpDown1: TUpDown
      Left = 80
      Top = 16
      Width = 16
      Height = 21
      Associate = Edit3
      Max = 1000
      TabOrder = 1
    end
  end
  object ProgressBar1: TProgressBar
    Left = 136
    Top = 104
    Width = 249
    Height = 17
    Smooth = True
    TabOrder = 9
  end
  object Memo1: TMemo
    Left = 40
    Top = 32
    Width = 185
    Height = 89
    Lines.Strings = (
      '0000000000000000000000000000'
      '0000000000000000000000000000'
      '0000000000000000000000000000'
      '0000000000000000000000000000'
      '0000000000000000000000000000'
      '0000000000000000000000000000'
      '0000000000000000000000000000'
      '0000000000000000000000000000'
      '0000000000000000000000000000'
      '0000000000000000000000000000'
      '0000000000000000000000000000'
      '0000000000000000000000000000'
      '0000000000000000000000000000'
      '0000000000000000000000000000'
      '0000000000000000000000000000'
      '0000000000000000000000000000'
      '0000000000000000000000000000'
      '0000000000000000000000000000'
      '0000000000000000000000000000'
      '0000000000000000000000000000'
      '0000000000000000000000000000'
      '0000000000000000000000000000'
      '0000000000000000000000000000'
      '0000000000000000000000000000'
      '0000000000000000000000000000'
      '0000000000000000000000000000'
      '0000000000000000000000000000'
      '0000000000000000000000000000'
      '0000000000000000000000000000'
      '0000000000000000000000000000'
      '0000000000000000000000000000'
      '0000000000000000000000000000'
      '0000000000000000000000000000'
      '0000000000000000000000000000'
      '0000000000000000000000000000'
      '0000000000000000000000000000'
      '0000000000000000')
    ReadOnly = True
    TabOrder = 10
    Visible = False
  end
  object OpenDialog1: TOpenDialog
    Filter = 'Exe|*.exe'
    Left = 96
    Top = 24
  end
  object SaveDialog1: TSaveDialog
    Left = 64
    Top = 24
  end
  object OpenDialog2: TOpenDialog
    Filter = 'Icon|*.ico'
    Left = 32
    Top = 24
  end
  object XPManifest1: TXPManifest
    Left = 128
    Top = 24
  end
  object Timer1: TTimer
    Interval = 100
    OnTimer = Timer1Timer
    Left = 280
    Top = 16
  end
end
