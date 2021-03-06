unit PdvNFCe;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, PdvClass, PdvBD;

type

  { TPDVNfce }

  TPDVNfce = class( TPDVClass )
    private
    public
      Constructor create( AOwner : TComponent  )  ;
      Destructor Destroy  ; override ;

      procedure Ativar ; override ;
      procedure Desativar ; override ;

      procedure AbreVenda; override;
      procedure VendeItem(PProduto: TProduto); override;
      procedure FechaVenda; override;
      procedure MenuOpcoes; override;
  end;

implementation

uses MnOpcNfce, CadCliNfce;

{ TPDVNfce }

constructor TPDVNfce.create(AOwner: TComponent);
begin
  inherited create( AOwner ) ;
end;

destructor TPDVNfce.Destroy;
begin
  inherited Destroy;
end;

procedure TPDVNfce.Ativar;
begin
  inherited Ativar;
end;

procedure TPDVNfce.Desativar;
begin
  inherited Desativar;
end;

procedure TPDVNfce.AbreVenda;
begin

  try
    FrmCadCliNfce := TFrmCadCliNfce.Create(nil);
    FrmCadCliNfce.PTipPessoa := fpCliente.TipoPessoa;
    FrmCadCliNfce.ShowModal;
    fpCliente.Nome_RzSocial := FrmCadCliNfce.EdtNmRz.Text;
    fpCliente.Cpf_Cnpj      := FrmCadCliNfce.EdtCpfCnpj.Text;
    fpCliente.IE            := FrmCadCliNfce.EdtIE.Text;
    fpCliente.CEP           := FrmCadCliNfce.EdtCEP.Text;
    fpCliente.Endereco      := FrmCadCliNfce.EdtEndereco.Text;
    fpCliente.Numero        := FrmCadCliNfce.EdtNumero.Text;
    fpCliente.Bairro        := FrmCadCliNfce.EdtBairro.Text;
    fpCliente.UF            := FrmCadCliNfce.CBoxUF.Text;
    fpCliente.Municipio     := FrmCadCliNfce.EdtMunicipio.Text;
    fpCliente.Telefone1     := FrmCadCliNfce.EdtFone.Text;
    fpCliente.Celular       := FrmCadCliNfce.EdtCelular.Text;
    fpCliente.Email         := FrmCadCliNfce.EdtEmail.Text;
    fpVendaAberta := True;
  finally
    FrmCadCliNfce.Free;
  end;

end;

procedure TPDVNfce.VendeItem(PProduto: TProduto);
begin

end;

procedure TPDVNfce.FechaVenda;
begin

end;

procedure TPDVNfce.MenuOpcoes;
begin
  FrmMnOpcNfce.ShowModal;
end;

end.

