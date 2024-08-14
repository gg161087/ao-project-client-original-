VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "clsBatch"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Option Explicit
 
Private m_VBuffer As Direct3DVertexBuffer8
Private m_IBuffer As Direct3DIndexBuffer8
Private m_Texture As Direct3DTexture8
Private m_Alpha   As Boolean
Private m_Data()   As TYPE_VERTEX
Private m_Position As Long

Private Type TYPE_VERTEX
    X       As Single
    Y       As Single
    Z       As Single
    Color  As Long
    TX      As Single
    TY      As Single
End Type
 
Public Sub Begin()
    Call DirectDevice.SetTexture(0, m_Texture)
    Call DirectDevice.SetStreamSource(0, m_VBuffer, 24)
    Call DirectDevice.SetIndices(m_IBuffer, 0)
    Call SetAlpha(False)
    Call SetTexture(Nothing)
End Sub
 
Public Sub SetAlpha(ByVal IsAlpha As Boolean)
    If IsAlpha <> m_Alpha Then
        Call Flush
        m_Alpha = IsAlpha
        If IsAlpha Then
            Call DirectDevice.SetRenderState(D3DRS_SRCBLEND, D3DBLEND_SRCALPHA)
            Call DirectDevice.SetRenderState(D3DRS_DESTBLEND, D3DBLEND_ONE)
        Else
            Call DirectDevice.SetRenderState(D3DRS_SRCBLEND, D3DBLEND_SRCALPHA)
            Call DirectDevice.SetRenderState(D3DRS_DESTBLEND, D3DBLEND_INVSRCALPHA)
        End If
    End If
End Sub
 
Public Sub SetTexture(ByRef Texture As Direct3DTexture8)
    If ObjPtr(m_Texture) <> ObjPtr(Texture) Then
        Call Flush
        Set m_Texture = Texture
        Call DirectDevice.SetTexture(0, Texture)
    End If
End Sub
 
Public Sub Draw(ByVal X As Long, ByVal Y As Long, ByVal Width As Long, ByVal Height As Long, ByRef Color() As Long, Optional ByVal Tx1 As Single = 0, _
                Optional ByVal Ty1 As Single = 0, Optional ByVal Tx2 As Single = 1, Optional ByVal Ty2 As Single = 1, Optional ByVal angle As Single = 0)
    If angle > 0 And angle <= 360 Then
        Dim NewX     As Single
        Dim NewY     As Single
        Dim SinRad   As Single
        Dim CosRad   As Single
        Dim RadAngle As Single
        Dim CenterX  As Single
        Dim CenterY  As Single
        RadAngle = angle * 0.017453292519
        CenterX = X + (Width * 0.5)
        CenterY = Y + (Height * 0.5)
        SinRad = Sin(RadAngle)
        CosRad = Cos(RadAngle)
    End If
    m_Data(m_Position).X = X
    m_Data(m_Position).Y = Y + Height
    m_Data(m_Position).Z = 0
    m_Data(m_Position).Color = Color(0)
    m_Data(m_Position).TX = Tx1
    m_Data(m_Position).TY = Ty2
    If angle > 0 And angle <= 360 Then
        NewX = CenterX + (m_Data(m_Position).X - CenterX) * -CosRad - (m_Data(m_Position).Y - CenterY) * -SinRad
        NewY = CenterY + (m_Data(m_Position).Y - CenterY) * -CosRad + (m_Data(m_Position).X - CenterX) * -SinRad
        m_Data(m_Position).X = NewX
        m_Data(m_Position).Y = NewY
    End If
    m_Position = m_Position + 1
    m_Data(m_Position).X = X
    m_Data(m_Position).Y = Y
    m_Data(m_Position).Z = 0
    m_Data(m_Position).Color = Color(1)
    m_Data(m_Position).TX = Tx1
    m_Data(m_Position).TY = Ty1
    If angle > 0 And angle <= 360 Then
        NewX = CenterX + (m_Data(m_Position).X - CenterX) * -CosRad - (m_Data(m_Position).Y - CenterY) * -SinRad
        NewY = CenterY + (m_Data(m_Position).Y - CenterY) * -CosRad + (m_Data(m_Position).X - CenterX) * -SinRad
        m_Data(m_Position).X = NewX
        m_Data(m_Position).Y = NewY
    End If
    m_Position = m_Position + 1
    m_Data(m_Position).X = X + Width
    m_Data(m_Position).Y = Y + Height
    m_Data(m_Position).Z = 0
    m_Data(m_Position).Color = Color(2)
    m_Data(m_Position).TX = Tx2
    m_Data(m_Position).TY = Ty2
    If angle > 0 And angle <= 360 Then
        NewX = CenterX + (m_Data(m_Position).X - CenterX) * -CosRad - (m_Data(m_Position).Y - CenterY) * -SinRad
        NewY = CenterY + (m_Data(m_Position).Y - CenterY) * -CosRad + (m_Data(m_Position).X - CenterX) * -SinRad
        m_Data(m_Position).X = NewX
        m_Data(m_Position).Y = NewY
    End If
    m_Position = m_Position + 1
    m_Data(m_Position).X = X + Width
    m_Data(m_Position).Y = Y
    m_Data(m_Position).Z = 0
    m_Data(m_Position).Color = Color(3)
    m_Data(m_Position).TX = Tx2
    m_Data(m_Position).TY = Ty1
    If angle > 0 And angle <= 360 Then
        NewX = CenterX + (m_Data(m_Position).X - CenterX) * -CosRad - (m_Data(m_Position).Y - CenterY) * -SinRad
        NewY = CenterY + (m_Data(m_Position).Y - CenterY) * -CosRad + (m_Data(m_Position).X - CenterX) * -SinRad
        m_Data(m_Position).X = NewX
        m_Data(m_Position).Y = NewY
    End If
    m_Position = m_Position + 1
    If m_Position >= UBound(m_Data) Then
        Call Flush
    End If
End Sub
 
Public Sub Finish()
    Call Flush
End Sub
 
Public Sub Flush()
    If m_Position > 0 Then
        Call D3DVertexBuffer8SetData(m_VBuffer, 0, m_Position * LenB(m_Data(0)), D3DLOCK_DISCARD, m_Data(0))
        Call DirectDevice.DrawIndexedPrimitive(D3DPT_TRIANGLELIST, 0, (m_Position / 2) * 3, 0, m_Position / 2)
        m_Position = 0
    End If
End Sub
 
Public Sub Initialise(ByVal Quads As Long)
    ReDim m_Data(Quads - 1) As TYPE_VERTEX
    Set m_VBuffer = DirectDevice.CreateVertexBuffer(24 * Quads, D3DUSAGE_DYNAMIC, D3DFVF_XYZ Or D3DFVF_DIFFUSE Or D3DFVF_TEX1, D3DPOOL_DEFAULT)
    Set m_IBuffer = DirectDevice.CreateIndexBuffer(3 * Quads, D3DUSAGE_WRITEONLY, D3DFMT_INDEX16, D3DPOOL_DEFAULT)
    Dim lpIndices() As Integer
    ReDim lpIndices(Quads * 3 / 2 - 1) As Integer
    Dim i As Long, J As Integer
    For i = 0 To UBound(lpIndices) Step 6
        lpIndices(i) = J
        lpIndices(i + 1) = J + 1
        lpIndices(i + 2) = J + 2
        lpIndices(i + 3) = J + 2
        lpIndices(i + 4) = J + 3
        lpIndices(i + 5) = J + 1
        J = J + 4
    Next
    Call D3DIndexBuffer8SetData(m_IBuffer, 0, 3 * Quads, 0, lpIndices(0))
End Sub