class HHSummary {
  static String userLogin = '';
  static int numeroCompras = 0;
  static double valorTotalCompras = 0.0;
  static double ticketMedio = 0.0;
  static double qtdeMediaProdutosCompra = 0.0;
  static double valorMaximoProduto = 0.0;
  static String dataPrimeiraCompra = ''; 
  static String dataUltimaCompra = ''; 
  static String diaSemanaMaisComum = '';
  static String horarioMaisComum = '';
  static double frequenciaMediaComprasDias = 0.0;
  static String categoriaPrincipal = '';
  static String marcaPrincipal = '';
  static String produtoMaisComprado = '';
  static double G = 0.0;
  static double pG = 0.0;
  static double H = 0.0;
  static double pH = 0.0;
  static double R = 0.0;
  static double pR = 0.0;
  static double B = 0.0;
  static double pB = 0.0;
  static double E = 0.0; // Total de vendas extras
  static double pE = 0.0; // % de vendas extras

  static String toStaticString() {
    return '''
      HHSummary {
        userLogin: $userLogin,
        numeroCompras: $numeroCompras,
        valorTotalCompras: $valorTotalCompras,
        ticketMedio: $ticketMedio,
        qtdeMediaProdutosCompra: $qtdeMediaProdutosCompra,
        valorMaximoProduto: $valorMaximoProduto,
        dataPrimeiraCompra: $dataPrimeiraCompra,
        dataUltimaCompra: $dataUltimaCompra,
        diaSemanaMaisComum: $diaSemanaMaisComum,
        horarioMaisComum: $horarioMaisComum,
        frequenciaMediaComprasDias: $frequenciaMediaComprasDias,
        categoriaPrincipal: $categoriaPrincipal,
        marcaPrincipal: $marcaPrincipal,
        produtoMaisComprado: $produtoMaisComprado,
        G: $G,
        pG: $pG,
        H: $H,
        pH: $pH,
        R: $R,
        pR: $pR,
        B: $B,
        pB: $pB,
        E: $E,
        pE: $pE
      }
    ''';
  }
}
