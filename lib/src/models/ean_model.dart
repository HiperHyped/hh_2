class EanModel{
  String ean;
  String marca;
  String link;
  String imagem;
  String nome;
  String sigla;
  String sig0;
  String sig1;
  String sig2;
  String sig3;
  String w1;
  String w2;
  String w3;
  String w4;
  String volume;
  String unidade;
  String preco;
  int hintStatus;


  EanModel(
    {
      this.ean = "",
      this.marca = "",
      this.link = "",
      this.imagem = "",
      this.nome = "",
      this.sigla = "",
      this.sig0 = "",
      this.sig1 = "",
      this.sig2 = "",
      this.sig3 = "",
      this.w1 = "",
      this.w2 = "",
      this.w3 = "",
      this.w4 = "",
      this.volume = "",
      this.unidade = "",
      this.preco = "",
      this.hintStatus = 0,
    }
  );

   @override
  String toString() {
        return "EanModel(ean: $ean, nome: $nome, preço: $preco, : $marca, sigla: $sigla, sig3: $sig3, w1: $w1, hint: $hintStatus)";
  }
}

