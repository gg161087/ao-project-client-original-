VERSION 5.00
Begin VB.Form frmForo 
   BackColor       =   &H00E0E0E0&
   BorderStyle     =   0  'None
   ClientHeight    =   6855
   ClientLeft      =   0
   ClientTop       =   0
   ClientWidth     =   6210
   ClipControls    =   0   'False
   ControlBox      =   0   'False
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   457
   ScaleMode       =   3  'Pixel
   ScaleWidth      =   414
   ShowInTaskbar   =   0   'False
   StartUpPosition =   1  'CenterOwner
   Begin VB.TextBox txtTitulo 
      Appearance      =   0  'Flat
      BackColor       =   &H00000000&
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   8.25
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H00FFFFFF&
      Height          =   315
      Left            =   1140
      MaxLength       =   35
      TabIndex        =   2
      Top             =   900
      Visible         =   0   'False
      Width           =   4620
   End
   Begin VB.TextBox txtPost 
      Appearance      =   0  'Flat
      BackColor       =   &H00000000&
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   8.25
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H00FFFFFF&
      Height          =   3960
      Left            =   780
      MultiLine       =   -1  'True
      TabIndex        =   1
      Text            =   "frmForo.frx":0000
      Top             =   1935
      Visible         =   0   'False
      Width           =   4770
   End
   Begin VB.ListBox lstTitulos 
      Appearance      =   0  'Flat
      BackColor       =   &H00000000&
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   8.25
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H00FFFFFF&
      Height          =   5100
      Left            =   765
      TabIndex        =   0
      Top             =   825
      Width           =   4785
   End
   Begin VB.Label lblTitulo 
      Appearance      =   0  'Flat
      BackColor       =   &H80000005&
      BackStyle       =   0  'Transparent
      Caption         =   "Label1"
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   8.25
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H00FFFFFF&
      Height          =   255
      Left            =   1125
      TabIndex        =   4
      Top             =   960
      Width           =   4695
   End
   Begin VB.Image imgMarcoTexto 
      Height          =   465
      Left            =   1095
      Top             =   840
      Width           =   4725
   End
   Begin VB.Image imgCerrar 
      Height          =   255
      Left            =   4080
      Top             =   6060
      Width           =   1455
   End
   Begin VB.Image imgListaMsg 
      Height          =   255
      Left            =   2400
      Top             =   6060
      Width           =   1455
   End
   Begin VB.Image imgDejarMsg 
      Height          =   255
      Left            =   720
      Top             =   6060
      Width           =   1455
   End
   Begin VB.Label lblAutor 
      Appearance      =   0  'Flat
      BackColor       =   &H80000005&
      BackStyle       =   0  'Transparent
      Caption         =   "Nombre"
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   8.25
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H00FFFFFF&
      Height          =   255
      Left            =   1125
      TabIndex        =   3
      Top             =   1455
      Width           =   4650
   End
   Begin VB.Image imgTab 
      Height          =   255
      Index           =   2
      Left            =   4320
      Top             =   360
      Width           =   1575
   End
   Begin VB.Image imgTab 
      Height          =   255
      Index           =   1
      Left            =   2520
      Top             =   360
      Width           =   1575
   End
   Begin VB.Image imgTab 
      Height          =   255
      Index           =   0
      Left            =   960
      Top             =   360
      Width           =   1575
   End
   Begin VB.Image imgDejarAnuncio 
      Height          =   255
      Left            =   2400
      Top             =   6060
      Width           =   1455
   End
End
Attribute VB_Name = "frmForo"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Private clsFormulario As clsFormMovementManager
Private cBotonDejarAnuncio As clsGraphicalButton
Private cBotonDejarMsg As clsGraphicalButton
Private cBotonCerrar As clsGraphicalButton
Private cBotonListaMsg As clsGraphicalButton
Public LastButtonPressed As clsGraphicalButton
Private ForoActual As eForumType
Private VerListaMsg As Boolean
Private Lectura As Boolean
Public ForoLimpio As Boolean
Private Sticky As Boolean
Public Privilegios As Byte
Public CanPostSticky As Byte
Private FondosDejarMsg(0 To 2) As Picture
Private FondosListaMsg(0 To 2) As Picture

Private Sub Form_Unload(Cancel As Integer)
    MirandoForo = False
    Privilegios = 0
End Sub

Private Sub imgDejarAnuncio_Click()
    Lectura = False
    VerListaMsg = False
    Sticky = True
    ToogleScreen
End Sub

Private Sub imgDejarMsg_Click()
    If Not cBotonDejarMsg.IsEnabled Then Exit Sub
    Dim PostStyle As Byte
    If Not VerListaMsg Then
        If Not Lectura Then
            If Sticky Then
                PostStyle = GetStickyPost
            Else
                PostStyle = GetNormalPost
            End If
            Call WriteForumPost(txtTitulo.Text, txtPost.Text, PostStyle)
            Call clsForos.AddPost(ForoActual, txtTitulo.Text, UserName, txtPost.Text, Sticky)
            Call UpdateList
            VerListaMsg = True
        End If
    Else
        VerListaMsg = False
        Sticky = False
    End If
    Lectura = False
    ToogleScreen
End Sub

Private Sub imgCerrar_Click()
    Unload Me
End Sub

Private Sub imgListaMsg_Click()
    VerListaMsg = True
    ToogleScreen
End Sub

Private Sub Form_Load()
    Set clsFormulario = New clsFormMovementManager
    clsFormulario.Initialize Me
    Call LoadButtons
    ForoActual = eForumType.ieGeneral
    VerListaMsg = True
    UpdateList
    ToogleScreen
    ForoLimpio = False
    MirandoForo = True
    If (Privilegios And eForumVisibility.ieCAOS_MEMBER) = 0 Then imgTab(2).Visible = False
    If (Privilegios And eForumVisibility.ieREAL_MEMBER) = 0 Then imgTab(1).Visible = False
End Sub

Private Sub LoadButtons()
    Dim GrhPath As String
    GrhPath = Game.path(Interfaces)
    Set FondosListaMsg(eForumType.ieGeneral) = LoadPicture(GrhPath & "ForoGeneral.jpg")
    Set FondosListaMsg(eForumType.ieREAL) = LoadPicture(GrhPath & "ForoReal.jpg")
    Set FondosListaMsg(eForumType.ieCAOS) = LoadPicture(GrhPath & "ForoCaos.jpg")
    Set FondosDejarMsg(eForumType.ieGeneral) = LoadPicture(GrhPath & "ForoMsgGeneral.jpg")
    Set FondosDejarMsg(eForumType.ieREAL) = LoadPicture(GrhPath & "ForoMsgReal.jpg")
    Set FondosDejarMsg(eForumType.ieCAOS) = LoadPicture(GrhPath & "ForoMsgCaos.jpg")
    imgMarcoTexto.Picture = LoadPicture(GrhPath & "MarcoTextBox.jpg")
    Set cBotonDejarAnuncio = New clsGraphicalButton
    Set cBotonDejarMsg = New clsGraphicalButton
    Set cBotonCerrar = New clsGraphicalButton
    Set cBotonListaMsg = New clsGraphicalButton
    Set LastButtonPressed = New clsGraphicalButton

    Call cBotonDejarAnuncio.Initialize(imgDejarAnuncio, GrhPath & "BotonDejarAnuncioForo.jpg", _
                                            GrhPath & "BotonDejarAnuncioRolloverForo.jpg", _
                                            GrhPath & "BotonDejarAnuncioClickForo.jpg", Me)
                                            
    Call cBotonDejarMsg.Initialize(imgDejarMsg, GrhPath & "BotonDejarMsgForo.jpg", _
                                            GrhPath & "BotonDejarMsgRolloverForo.jpg", _
                                            GrhPath & "BotonDejarMsgClickForo.jpg", Me, _
                                            GrhPath & "BotonDejarMsgDisabledForo.jpg")
                                            
    Call cBotonCerrar.Initialize(imgCerrar, GrhPath & "BotonCerrarForo.jpg", _
                                            GrhPath & "BotonCerrarRolloverForo.jpg", _
                                            GrhPath & "BotonCerrarClickForo.jpg", Me)
                                            
    Call cBotonListaMsg.Initialize(imgListaMsg, GrhPath & "BotonListaMsgForo.jpg", _
                                            GrhPath & "BotonListaMsgRolloverForo.jpg", _
                                            GrhPath & "BotonListaMsgClickForo.jpg", Me)
End Sub

Private Sub Form_MouseMove(Button As Integer, Shift As Integer, X As Single, Y As Single)
    LastButtonPressed.ToggleToNormal
End Sub

Private Sub imgTab_Click(Index As Integer)
    Call Audio.PlayWave(SND_CLICK)
    If Index <> ForoActual Then
        ForoActual = Index
        VerListaMsg = True
        Lectura = False
        UpdateList
        ToogleScreen
    Else
        If Not VerListaMsg Then
            VerListaMsg = True
            Lectura = False
            ToogleScreen
        End If
    End If
End Sub

Private Sub ToogleScreen()
    Dim PostOffset As Integer
    imgMarcoTexto.Visible = Not VerListaMsg And Not Lectura
    txtTitulo.Visible = Not VerListaMsg And Not Lectura
    lblTitulo.Visible = Not VerListaMsg And Lectura
    Call cBotonDejarMsg.EnableButton(VerListaMsg Or Lectura)
    txtPost.Visible = Not VerListaMsg
    imgDejarAnuncio.Visible = VerListaMsg And PuedeDejarAnuncios
    imgListaMsg.Visible = Not VerListaMsg
    lstTitulos.Visible = VerListaMsg
    If VerListaMsg Then
        Me.Picture = FondosListaMsg(ForoActual)
    Else
        If Lectura Then
            With lstTitulos
                PostOffset = .ItemData(.ListIndex)
                If PostOffset < STICKY_FORUM_OFFSET Then
                    lblTitulo.Caption = Foros(ForoActual).GeneralTitle(PostOffset)
                    txtPost.Text = Foros(ForoActual).GeneralPost(PostOffset)
                    lblAutor.Caption = Foros(ForoActual).GeneralAuthor(PostOffset)
                Else
                    PostOffset = PostOffset - STICKY_FORUM_OFFSET
                    lblTitulo.Caption = Foros(ForoActual).StickyTitle(PostOffset)
                    txtPost.Text = Foros(ForoActual).StickyPost(PostOffset)
                    lblAutor.Caption = Foros(ForoActual).StickyAuthor(PostOffset)
                End If
            End With
        Else
            lblAutor.Caption = UserName
            txtTitulo.Text = vbNullString
            txtPost.Text = vbNullString
            txtTitulo.SetFocus
        End If
        txtPost.Locked = Lectura
        Me.Picture = FondosDejarMsg(ForoActual)
    End If
End Sub

Private Function PuedeDejarAnuncios() As Boolean
    If CanPostSticky = 0 Then Exit Function
    If ForoActual = eForumType.ieGeneral Then
        If CanPostSticky <> 2 Then Exit Function
    End If
    PuedeDejarAnuncios = True
End Function

Private Sub lstTitulos_Click()
    VerListaMsg = False
    Lectura = True
    ToogleScreen
End Sub

Private Sub lstTitulos_MouseMove(Button As Integer, Shift As Integer, X As Single, Y As Single)
    LastButtonPressed.ToggleToNormal
End Sub

Private Sub txtPost_Change()
    If Lectura Then Exit Sub
    Call cBotonDejarMsg.EnableButton(Len(txtTitulo.Text) <> 0 And Len(txtPost.Text) <> 0)
End Sub

Private Sub txtPost_MouseMove(Button As Integer, Shift As Integer, X As Single, Y As Single)
    LastButtonPressed.ToggleToNormal
End Sub

Private Sub txtTitulo_Change()
    If Lectura Then Exit Sub
    Call cBotonDejarMsg.EnableButton(Len(txtTitulo.Text) <> 0 And Len(txtPost.Text) <> 0)
End Sub

Private Sub UpdateList()
    Dim PostIndex As Long
    lstTitulos.Clear
    With lstTitulos
        For PostIndex = 1 To clsForos.GetNroSticky(ForoActual)
            .AddItem "[" & UCase$(JsonLanguage.item("ANUNCIO").item("TEXTO")) & "] " & Foros(ForoActual).StickyTitle(PostIndex) & " (" & Foros(ForoActual).StickyAuthor(PostIndex) & ")"
            .ItemData(.NewIndex) = STICKY_FORUM_OFFSET + PostIndex
        Next PostIndex
        For PostIndex = 1 To clsForos.GetNroPost(ForoActual)
            .AddItem Foros(ForoActual).GeneralTitle(PostIndex) & " (" & Foros(ForoActual).GeneralAuthor(PostIndex) & ")"
            .ItemData(.NewIndex) = PostIndex
        Next PostIndex
    End With
End Sub

Private Function GetStickyPost() As Byte
    Select Case ForoActual
        Case 0
            GetStickyPost = eForumMsgType.ieGENERAL_STICKY
            
        Case 1
            GetStickyPost = eForumMsgType.ieREAL_STICKY
            
        Case 2
            GetStickyPost = eForumMsgType.ieCAOS_STICKY
    End Select
End Function

Private Function GetNormalPost() As Byte
    Select Case ForoActual
        Case 0
            GetNormalPost = eForumMsgType.ieGeneral
            
        Case 1
            GetNormalPost = eForumMsgType.ieREAL
            
        Case 2
            GetNormalPost = eForumMsgType.ieCAOS
    End Select
End Function
