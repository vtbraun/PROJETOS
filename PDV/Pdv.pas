unit Pdv;

{$MODE Delphi}

interface

uses
  Classes, SysUtils, PdvClass, PdvBD;

type

  TPDVTipoVenda = (tpvNenhum, tpvManual, tpvPafECF, tpvNFCe, tpvNFe);

  { TPDV }

  TPDV = class(TComponent)
    private
      { Propriedades do Componente PDV }
      fsAtivo: Boolean;
      fsVendaAberta: Boolean;
      fsTipoVenda: TPDVTipoVenda;
      fsPDV: TPDVClass;  { Classe com instancia do PDV de fsTipoVenda }
      fsCliente : TClienteVenda ;   { SubComponente TClienteVenda }


      procedure SetAtivo(const AValue: boolean);
      procedure SetTipoVenda(AValue: TPDVTipoVenda);
    public
      constructor Create(AOwner: TComponent); override;
      destructor Destroy; override;

      procedure Ativar;
      procedure Desativar;
      property Ativo: boolean read fsAtivo write SetAtivo;

      procedure AbreVenda;
      procedure VendeItem(PProduto: TProduto);
      procedure FechaVenda;
      procedure MenuOpcoes;
      procedure MenuFiscal;
    published
      property TipoVenda : TPDVTipoVenda read fsTipoVenda write SetTipoVenda
                 default tpvNenhum ;
      { Instancia do Componente TClienteVenda, será passada para fsPDV.create }
     property Cliente     : TClienteVenda     read fsCliente ;
     property VendaAberta : Boolean  read fsVendaAberta write fsVendaAberta;
  end;


implementation
uses PdvManual, PdvPafEcf, PdvNFCe, CadTipPes;

{ TPDV }

procedure TPDV.SetAtivo(const AValue: boolean);
begin
  if AValue then
    Ativar
  else
    Desativar ;
end;

procedure TPDV.SetTipoVenda(AValue: TPDVTipoVenda);
begin
  if fsTipoVenda = AValue then exit ;

  { TODO : Verificar EACBrECFErro }
  //if fsAtivo then
  //   raise EACBrECFErro.Create( ACBrStr(cACBrECFSetModeloException));

  FreeAndNil( fsPDV ) ;

  { Instanciando uma nova classe de acordo com fsModelo }
  case AValue of
    tpvManual    : fsPDV := TPDVManual.create( Self );
    tpvPafECF    : fsPDV := TPDVPafEcf.create( Self );
    tpvNFCe      : fsPDV := TPDVNfce.create( Self );
   // tpvNFe       : fsPDV :=

    //ecfECFVirtual: fsECF := fsECFVirtual.ECFClass;
  else
    fsPDV := TPDVClass.create( Self ) ;
  end;

  fsTipoVenda := AValue;
end;

constructor TPDV.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

  fsAtivo       := False;
  fsVendaAberta := False;

  { Instanciando SubComponente TClienteVenda }
  fsCliente := TClienteVenda.Create ;  { O dono é o proprio componente }

  { Instanciando fsPDV com modelo Generico (PDVClass) }
  fsPDV := TPDVClass.Create(self);
end;

destructor TPDV.Destroy;
begin
  Ativo := false ;

  if Assigned(fsPDV) then
    FreeAndNil(fsPDV);

  FreeAndNil( fsCliente ) ;

  inherited Destroy;

end;

procedure TPDV.Ativar;
begin
  if fsAtivo then exit ;

  { TODO : Verificar EACBRECFERRO }
  //if fsTipoVenda = tpvNenhum then
  //   raise EACBrECFErro.Create( ACBrStr('Modelo não definido'));     }

  fsPDV.Ativar ;
  fsAtivo := true ;

end;

procedure TPDV.Desativar;
begin
  if not fsAtivo then exit ;

  fsPDV.Desativar ;
  fsAtivo := false;

end;

procedure TPDV.AbreVenda;
begin

  try

    if not fsVendaAberta then
    begin
      FrmCadTipPes := TFrmCadTipPes.Create(nil);
      if (FrmCadTipPes.ShowModal = 1) then
      begin
        case FrmCadTipPes.ComboBox1.ItemIndex of
          0: fsCliente.TipoPessoa := 'F';
          1: fsCliente.TipoPessoa := 'J';
        end;
        fsPDV.AbreVenda;
      end;
    end;

  finally
    FrmCadTipPes.Free;
  end;

end;

procedure TPDV.VendeItem(PProduto: TProduto);
begin
  if fsVendaAberta then
    fsPDV.VendeItem(PProduto);
end;

procedure TPDV.FechaVenda;
begin

  if fsVendaAberta then
  begin
    fsPDV.FechaVenda;
    fsVendaAberta := False;
  end;

end;

procedure TPDV.MenuOpcoes;
begin
  fsPDV.MenuOpcoes;
end;

procedure TPDV.MenuFiscal;
begin
  fsPDV.MenuFiscal;
end;

end.

