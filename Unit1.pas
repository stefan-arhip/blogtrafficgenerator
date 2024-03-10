unit Unit1;

{$MODE Delphi}

interface

uses
  LCLIntf, LCLType, LMessages, Messages, SysUtils, Classes, Graphics,
  Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, Spin;

type

  { TForm1 }

  TForm1 = class(TForm)
    Panel1: TPanel;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Button1: TButton;
    Edit1: TEdit;
    SpinEdit1: TSpinEdit;
    Timer1: TTimer;
    ListBox1: TListBox;
    procedure Button1Click(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure SpinEdit1Change(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.lfm}

var
  pas, Counter: integer;

procedure TForm1.Button1Click(Sender: TObject);
//Var i:Integer;
begin
  //  For i:=0 To ListBox1.Items.Capacity-1 Do
  //    Begin
  //      ShellExecute(Form1.Handle, Nil, PChar(ListBox1.Items[i]),Nil, Nil, SW_Maximize);

  //    End;
  Timer1.Enabled := not Timer1.Enabled;
  if Timer1.Enabled then
    Button1.Caption := 'Pause'
  else
    Button1.Caption := 'Run';
end;

function CustomDecodeDate(s: string): string;
var
  s1, s2, s3, R1, R2, R3: string;
begin
  s1 := s;
  Delete(s1, 1, Length(s) - 2);
  s2 := s;
  Delete(s2, 1, Length(s) - 5);// = 12/31
  Delete(s2, 3, 3);
  s3 := s;
  Delete(s3, 1, Length(s) - 10);// = 2010/12/31
  Delete(s3, 5, 6);
  DateTimeToString(R1, 'yyyy', EncodeDate(StrToInt(s3), StrToInt(s2), StrToInt(s1)));
  DateTimeToString(R2, 'mmmm', EncodeDate(StrToInt(s3), StrToInt(s2), StrToInt(s1)));
  DateTimeToString(R3, 'dd', EncodeDate(StrToInt(s3), StrToInt(s2), StrToInt(s1)));
  Result := R1 + ' ' + R2 + ' ' + R3 + ' ' + Chr(171) + ' Stefan Arhip - Google Chrome';
end;

//function GetActiveCaption: string;
//var
//  Handle: THandle;
//  Len: longint;
//  Title: string;
//begin
//  Result := '';
//  Handle := GetForegroundWindow;
//  if Handle <> 0 then
//  begin
//    Len := GetWindowTextLength(Handle) + 1;
//    SetLength(Title, Len);
//    GetWindowText(Handle, PChar(Title), Len);
//    GetActiveCaption := TrimRight(Title);
//  end;
//end;

procedure TForm1.Timer1Timer(Sender: TObject);
var
  MyHandle: THandle;
  Line: integer;
begin
  case pas of
    0: begin
      if ListBox1.ItemIndex < ListBox1.Items.Capacity - 1 then
        ListBox1.ItemIndex := ListBox1.ItemIndex + 1
      else
        ListBox1.ItemIndex := 0;
      OpenDocument(PChar(ListBox1.Items[ListBox1.ItemIndex]));
      { *Converted from ShellExecute* }
      Pas := 1;
      Inc(Counter);
      Label3.Caption := 'Counting hits: ' + IntToStr(Counter);
    end;
    1:
    begin
      Edit1.Text := CustomDecodeDate(ListBox1.Items[ListBox1.ItemIndex]);
      MyHandle := FindWindow(nil, PChar(Edit1.Text));
      SendMessage(MyHandle, WM_CLOSE, 0, 0);
      Pas := 0;
    end;
  end;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  Pas := 0;
  ListBox1.ItemIndex := 0;
  Counter := 0;
end;

procedure TForm1.SpinEdit1Change(Sender: TObject);
begin
  Timer1.Interval := SpinEdit1.Value * 1000;
end;

end.
