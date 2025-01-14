VERSION 5.00
Begin VB.Form frmCommet 
   BorderStyle     =   0  'None
   Caption         =   "Oferta de paz o alianza"
   ClientHeight    =   3270
   ClientLeft      =   0
   ClientTop       =   -105
   ClientWidth     =   5055
   ClipControls    =   0   'False
   ControlBox      =   0   'False
   BeginProperty Font 
      Name            =   "Tahoma"
      Size            =   8.25
      Charset         =   0
      Weight          =   400
      Underline       =   0   'False
      Italic          =   0   'False
      Strikethrough   =   0   'False
   EndProperty
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   218
   ScaleMode       =   3  'Pixel
   ScaleWidth      =   337
   ShowInTaskbar   =   0   'False
   StartUpPosition =   1  'CenterOwner
   Begin VB.TextBox Text1 
      BackColor       =   &H00000000&
      BorderStyle     =   0  'None
      BeginProperty Font 
         Name            =   "Tahoma"
         Size            =   8.25
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H00FFFFFF&
      Height          =   1935
      Left            =   240
      MultiLine       =   -1  'True
      TabIndex        =   0
      Top             =   480
      Width           =   4575
   End
   Begin AOProjectClient.uAOButton imgEnviar 
      Height          =   495
      Left            =   1080
      TabIndex        =   1
      Top             =   2520
      Width           =   975
      _ExtentX        =   1720
      _ExtentY        =   873
      TX              =   "Enviar"
      ENAB            =   -1  'True
      FCOL            =   7314354
      OCOL            =   16777215
      PICE            =   "frmCommet.frx":0000
      PICF            =   "frmCommet.frx":001C
      PICH            =   "frmCommet.frx":0038
      PICV            =   "frmCommet.frx":0054
      BeginProperty FONT {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
         Name            =   "Calibri"
         Size            =   8.25
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
   End
   Begin AOProjectClient.uAOButton imgCerrar 
      Height          =   495
      Left            =   2880
      TabIndex        =   2
      Top             =   2520
      Width           =   975
      _ExtentX        =   1720
      _ExtentY        =   873
      TX              =   "Cerrar"
      ENAB            =   -1  'True
      FCOL            =   7314354
      OCOL            =   16777215
      PICE            =   "frmCommet.frx":0070
      PICF            =   "frmCommet.frx":008C
      PICH            =   "frmCommet.frx":00A8
      PICV            =   "frmCommet.frx":00C4
      BeginProperty FONT {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
         Name            =   "Calibri"
         Size            =   8.25
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
   End
   Begin VB.Label lblTitle 
      BackStyle       =   0  'Transparent
      Caption         =   "Titulo del form ..."
      BeginProperty Font 
         Name            =   "Tahoma"
         Size            =   12
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H8000000B&
      Height          =   375
      Left            =   360
      TabIndex        =   3
      Top             =   120
      Width           =   3855
   End
End
Attribute VB_Name = "frmCommet"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Private clsFormulario As clsFormMovementManager
Private Const MAX_PROPOSAL_LENGTH As Integer = 520
Public Nombre As String
Public t As TIPO

Public Enum TIPO
    ALIANZA = 1
    PAZ = 2
    RECHAZOPJ = 3
End Enum

Private Sub Form_Load()
    Set clsFormulario = New clsFormMovementManager
    clsFormulario.Initialize Me
    Me.Picture = LoadPicture(Game.path(Interfaces) & "VentanaCommet.jpg")
    Call LoadTextsForm
    Call LoadAOCustomControlsPictures(Me)
End Sub

Private Sub LoadTextsForm()
    imgEnviar.Caption = JsonLanguage.item("FRM_COMMET_ENVIAR").item("TEXTO")
    imgCerrar.Caption = JsonLanguage.item("FRM_COMMET_CERRAR").item("TEXTO")
    Select Case t
        Case TIPO.ALIANZA
            lblTitle.Caption = JsonLanguage.item("FRM_COMMET_ALIANZA").item("TEXTO")
            
        Case TIPO.PAZ
            lblTitle.Caption = JsonLanguage.item("FRM_COMMET_PAZ").item("TEXTO")
            
        Case TIPO.RECHAZOPJ
            lblTitle.Caption = JsonLanguage.item("FRM_COMMET_RECHAZOPJ").item("TEXTO")
    End Select
End Sub

Private Sub imgCerrar_Click()
    Unload Me
End Sub

Private Sub imgEnviar_Click()
    If LenB(Text1) = 0 Then
        If t = PAZ Or t = ALIANZA Then
            MsgBox "Debes redactar un mensaje solicitando la paz o alianza al lider de " & Nombre
        Else
            MsgBox "Debes indicar el motivo por el cual rechazas la membresia de " & Nombre
        End If
        
        Exit Sub
    End If
    If t = PAZ Then
        Call WriteGuildOfferPeace(Nombre, Replace(Text1, vbNewLine, "º"))
    ElseIf t = ALIANZA Then
        Call WriteGuildOfferAlliance(Nombre, Replace(Text1, vbNewLine, "º"))
    ElseIf t = RECHAZOPJ Then
        Call WriteGuildRejectNewMember(Nombre, Replace(Replace(Text1.Text, ",", " "), vbNewLine, " "))
        Dim i As Long
        Dim Count_listCount As Long
        Count_listCount = frmGuildLeader.solicitudes.ListCount - 1
        For i = 0 To Count_listCount
            If frmGuildLeader.solicitudes.List(i) = Nombre Then
                frmGuildLeader.solicitudes.RemoveItem i
                Exit For
            End If
        Next i
        Me.Hide
        Unload frmCharInfo
    End If
    Unload Me
End Sub

Private Sub Text1_Change()
    If Len(Text1.Text) > MAX_PROPOSAL_LENGTH Then
        Text1.Text = Left$(Text1.Text, MAX_PROPOSAL_LENGTH)
    End If
End Sub
