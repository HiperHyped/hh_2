class DimensionModel {
  final String code;
  final double value;
  final String name;
  final String type;
  final String type_pt;
  final String definition;

  const DimensionModel({
    required this.code,
    required this.value,
    required this.name,
    required this.type,
    required this.type_pt,
    required this.definition,
  });

  @override
  String toString() {
    return 'Code: $code, Value: $value, Name: $name, Type: $type, Type_PT: $type_pt, Definition: $definition';
  }
}

const List<DimensionModel> HHDList = [
  DimensionModel(
    code: 'D1',
    value: 0.0,
    name: 'ProdCountBrand',
    type: 'Marca',
    type_pt: 'Contagem de Produtos por Marca',
    definition: 'Mede a quantidade de produtos de uma marca específica com os quais o usuário interagiu.',
  ),
  DimensionModel(
    code: 'D2',
    value: 0.0,
    name: 'ProdCountCat',
    type: 'Categoria',
    type_pt: 'Contagem de Produtos por Categoria',
    definition: 'Quantifica a quantidade de produtos distintos que o usuário interage dentro de uma categoria específica.',
  ),
  DimensionModel(
    code: 'D3',
    value: 0.0,
    name: 'ProdCountCatW1',
    type: 'Categoria',
    type_pt: 'Contagem de Produtos Normalizada por Palavra-Chave',
    definition: 'Avalia a proporção de produtos por categoria em relação ao total de produtos, oferecendo uma visão normalizada da distribuição de produtos por categoria.',
  ),
  DimensionModel(
    code: 'D4',
    value: 0.0,
    name: 'PriceCountProdUF',
    type: 'Marca',
    type_pt: 'Contagem de Preços por Produto',
    definition: 'Indica a quantidade de preços que o usuário experimenta para um produto específico em diferentes estados (UFs).',
  ),
  DimensionModel(
    code: 'D5',
    value: 0.0,
    name: 'PriceCountBrandUF',
    type: 'Marca',
    type_pt: 'Contagem de Preços por Marca e Estado',
    definition: 'Reflete a frequência com que o usuário se depara com diferentes preços para marcas em diferentes estados (UFs).',
  ),
  DimensionModel(
    code: 'D6',
    value: 0.0,
    name: 'PriceAvgProd',
    type: 'Preço',
    type_pt: 'Preço Médio por Produto',
    definition: 'Representa o preço médio que o usuário paga por um produto específico.',
  ),
  DimensionModel(
    code: 'D7',
    value: 0.0,
    name: 'PriceRangeProd',
    type: 'Preço',
    type_pt: 'Variação de Preço por Produto',
    definition: 'Mede a variação de preço para um produto específico, indicando a faixa de preço que o usuário encontra no mercado.',
  ),
  DimensionModel(
    code: 'D8',
    value: 0.0,
    name: 'PricePosProd',
    type: 'Preço',
    type_pt: 'Posicionamento de Preço do Produto',
    definition: 'Representa o posicionamento do preço de um produto em relação aos seus pares em uma mesma palavra-chave.',
  ),
  DimensionModel(
    code: 'D9',
    value: 0.0,
    name: 'PriceAvgCatW1',
    type: 'Categoria',
    type_pt: 'Preço Médio Ponderado por Palavra-Chave',
    definition: 'Calcula o preço médio ponderado dos produtos dentro de uma categoria, refletindo o nível de preço que o usuário está disposto a pagar por categoria.',
  ),
];
