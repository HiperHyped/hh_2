
// ignore_for_file: avoid_print

import 'package:dart_openai/openai.dart';
import 'package:hh_2/src/config/ai/ai_service.dart';
import 'package:hh_2/src/config/common/var/hh_globals.dart';
import 'package:hh_2/src/config/log/log_service.dart';
import 'package:hh_2/src/models/basket_model.dart';
import 'package:hh_2/src/models/ean_model.dart';
import 'package:hh_2/src/models/recipe_model.dart';
import 'package:hh_2/src/models/search_model.dart';
import 'package:hh_2/src/models/suggestion_model.dart';




class Xerxes {
  
  late final AIService _aiService;
  String model =  "gpt-3.5-turbo"; //"gpt-4"; //"gpt-3.5-turbo"; //gpt-3.5-turbo-16k-0613 //gpt-3.5-turbo //"gpt-4" //"gpt-4o"; //;


  Xerxes() {
    LogService.init(); //LOG
    
    _aiService = AIService();  // Inicializando _aiService no construtor
  }

  /////////////
  /// aX1   ///
  /////////////
  
  Future<String> ax1(String product_name) async {
    // Prompt de sistema
    var systemMessage = 
    """
    Você vai atuar como um classificador de produtos alimentícios. Sua tarefa é determinar se o produto fornecido pode ser um ingrediente em uma receita tradicional ou não.
    Por exemplo, 'arroz' pode ser um ingrediente em várias receitas, enquanto 'cerveja' geralmente não é considerada um ingrediente principal em receitas tradicionais. 
    Exemplos: Biscoitos, doces, pães não são ingredientes (N).
    Responda com 'I' para Ingrediente e 'N' para Não-ingrediente.
    """;

    // Mensagem do usuário
    var userMessage = product_name;

    // Criando as mensagens para a API da OpenAI
    var messages = [
      OpenAIChatCompletionChoiceMessageModel(
        content: systemMessage,
        role: OpenAIChatMessageRole.system,
      ),
      OpenAIChatCompletionChoiceMessageModel(
        content: userMessage,
        role: OpenAIChatMessageRole.user,
      ),
    ];

    // Chamando a API da OpenAI
    var chatCompletion = await _aiService.createChat(
      model: model,
      messages: messages,
    );

    // Extraindo a resposta
    String response = chatCompletion.choices[0].message.content.trim();
    LogService.logInfo("AX1: $response", 'AI');

    return response;
  }


  /////////////
  ///  X1  ////
  /////////////

  //Future<SuggestionModel> x1(BasketModel basketModel, {void Function()? onCompleted}) async {
  Future<String> x1() async {
  
    // Use a lista de produtos diretamente de BasketModel
    List<EanModel> products = HHGlobals.HHBasket.value.products;
  
    // Filtrar produtos que podem ser ingredientes em uma receita (usando informações em BasketModel)
    List<EanModel> filteredProducts = products.where((product) {
      EanInfo? info = HHGlobals.HHBasket.value.productInfo[product];
      product.toString();
      return info?.hintStatus == HintStatus.I;
    }).toList();

    var productsStr = filteredProducts.map((product) => product.nome).join(', ');
    //print("PRODUCTLIST: $productsStr");
    //print(HHGlobals.HHBasket.value.toString());



    // Resto é identico
    if (productsStr.isNotEmpty) {
      var systemMessage = 
        """
        Em uma lista inicial, vou te fornecer um ou mais ingredientes. Sua tarefa será sugerir o nome de uma receita conhecida com esse ingrediente e completar a lista de ingredientes.
        Ingredientes devem ter nome de produtos encontrados em supermercado. Não diga "clara de ovo", diga "ovo". Não diga "bife de patinho", diga "patinho". 
        Coloque tudo em uma única linha e siga a formatação dos exemplos abaixo:
        Exemplo 1: "Lista: Feijão Preto, Linguiça, Cerveja". Resposta: '{Sugestão: {Feijoada}, Lista: {Arroz, Bacon, Couve manteiga, Laranja, Pimenta}}'
        Exemplo 2: "Lista: Leite, Farinha, Chocolate, Peixe". Resposta: '{Sugestão: {Bolo de Chocolate}, Lista: {Fermento, Ovo, Açúcar}}' 
        Exemplo 3: "Lista: Arroz". Resposta: '{Sugestão: {Arroz}, Lista: {Arroz, Óleo, Cebola, Alho, Salsinha}}
        Nunca deixe de responder com alguma receita e sempre responda no formato dos exemplos acima.
        """;

        /*"""
        Em uma lista inicial, vou te fornecer um ou mais ingredientes. Sua tarefa será sugerir o nome de uma receita consagrada e conhecida com esse ingrediente e completar a lista de ingredientes.
        Ingredientes devem ter nome de produtos encontrados em supermercado. Não diga "clara de ovo", diga "ovo". Não diga "bife de patinho", diga "patinho". 
        Produtos da lista inicial que não forem utilizados devem entrar na lista "Inutilizado". Coloque tudo em uma única linha e siga a formatação dos exemplos abaixo:
        Exemplo 1: "Lista: Feijão Preto, Linguiça, Cerveja". Resposta: '{Sugestão: {Feijoada}, Lista: {Arroz, Bacon, Couve manteiga, Laranja, Pimenta}, Inutilizado: {Cerveja}}'
        Exemplo 2: "Lista: Leite, Farinha, Chocolate, Peixe". Resposta: '{Sugestão: {Bolo de Chocolate}, Lista: {Fermento, Ovo, Açúcar}, Inutilizado: {Peixe}}' 
        """;*/
      //Vou lhe fornecer alugns ingredientes. Sua tarefa será escolher desta lista alguns produtos para sugerir o nome de uma receita consagrada e conhecida e os ingredientes adicionais necessários.

      var userMessage = productsStr;
      var messages = [
        OpenAIChatCompletionChoiceMessageModel(
          content: systemMessage,
          role: OpenAIChatMessageRole.system,
        ),
        OpenAIChatCompletionChoiceMessageModel(
          content: userMessage,
          role: OpenAIChatMessageRole.user,
        ),
      ];

      var chatCompletion = await _aiService.createChat(
        //model: "ft:gpt-3.5-turbo-0613:hh:recipe-products:7vWLocC8",  //FT2
        model: model,
        messages: messages,
      );

      LogService.logInfo("X1: ${chatCompletion.choices[0].message.content}", 'AI');

      //print("X1 Tokens: ${chatCompletion.usage.totalTokens.toString()}");
      return chatCompletion.choices[0].message.content;
      } else {return '';}
  }



  /////////////
  ///  hx1 ////
  /////////////
  // Método para lidar com a resposta do X1 (HANDLE X1) e transformá-la em uma instância de SuggestionModel
  SuggestionModel hx1(String response) {

    //print("hX1 INSIDE FIRST: ${response}");

    // Inicializar o modelo de sugestão e copiar a lista de produtos do BasketModel
    SuggestionModel suggestion = SuggestionModel();
    //suggestion.initialProductList = List.from(HHGlobals.HHBasket.value.products);
    
    for (EanModel product in HHGlobals.HHBasket.value.products) {
      //print("EANINFO: ${product.nome} :: ${HHGlobals.HHBasket.value.productInfo[product]!.hintStatus}");
    }
    
    // Filtrar a lista de produtos iniciais (initialProductList) com HintStatus "I"
    suggestion.initialProductList = HHGlobals.HHBasket.value.products.where((product) {
      EanInfo? info = HHGlobals.HHBasket.value.productInfo[product];
      return info?.hintStatus == HintStatus.I;
    }).toList();

    /*for (var product in HHGlobals.HHBasket.value.products) {
      EanInfo? info = HHGlobals.HHBasket.value.productInfo[product];
      if (info?.hintStatus == HintStatus.I) {
        suggestion.initialProductList.add(product);
      }
    }*/

    //print("PX1 PRINT INITIAL: ${suggestion.initialProductList}" );

    // Regex para extrair a sugestão e a lista da resposta
    final suggestionPattern = RegExp(r'Sugestão: {(.*?)}');
    final listPattern = RegExp(r'Lista: {(.*?)}');
    final unusedPattern = RegExp(r'Inutilizado: {(.*?)}');
    
    //print("SUGPAT: $suggestionPattern, LISTPAT: $listPattern");

    // Encontrar e capturar os grupos de sugestão e lista
    final suggestionMatch = suggestionPattern.firstMatch(response);
    final listMatch = listPattern.firstMatch(response);
    final unusedMatch = unusedPattern.firstMatch(response);

    //print("SUG: $suggestionMatch, LIST: $listMatch");

    // Verificar se os padrões foram encontrados na resposta
    if (suggestionMatch != null && listMatch != null) {
      // Extrair e ajustar a sugestão e a lista
      suggestion.recipe = suggestionMatch.group(1)!.trim();
      suggestion.suggestProductList = listMatch.group(1)!
        .split(',')
        .map((ingredient) => ingredient.trim())
        .toList();

      //print("PX1 INSIDE: ${suggestion.toString()}");
    } 
    //else { }
    LogService.logInfo("HX1 INSIDE: ${suggestion.toString()}", 'AI');
    
    return suggestion;
  }

  /////////////
  ///  px1 ////
  /////////////
  /// Metodo pós X1
  Future<SuggestionModel> px1(SuggestionModel suggestion) async {
    // Gere a lista total de produtos
    suggestion.createTotalProductList();
    //print("x2 TOTAL: ${suggestion.toString()}");

    // Converte a suggestProductList em uma lista de SearchModel
    await suggestion.toSearchModelList();
    //print(" x2 - SUGGESTIONLIST: ${suggestion.suggestProductList}");

    // Gera os resultados da pesquisa do DB para cada item em searchProductList
    suggestion.generateDBSearchResults();
    //print("x2 DB: ${suggestion.dbSearchResultList}");

    // Transforme o hintStatus dos produtos de I para U no objeto BasketModel
    for (var product in HHGlobals.HHBasket.value.products) {
      EanInfo? info = HHGlobals.HHBasket.value.productInfo[product];
      if (info?.hintStatus == HintStatus.I) {
        info!.hintStatus = HintStatus.U;
      }
    }
    LogService.logInfo("PX1 INSIDE: ${suggestion.toString()}", 'AI');
    return suggestion; 
  }


  /////////////
  ///  X2  //// FT3
  /////////////
  //Future<RecipeModel> x2(SuggestionModel suggestion) async {
  Future<RecipeModel> x2(SuggestionModel suggestion, {void Function()? onCompleted}) async {

      
    var systemMessage = 
      """
      Com base no nome da receita e na lista de ingredientes, 
      você deverá fornecer um passo-a-passo em tópicos para preparar uma receita conhecida e consagrada.
      IMPORTANTE 1: Ignore produtos da lista de ingredientes que não tenham a ver com uma receita sugerida.
      IMPORTANTE 2: Forneça SEMPRE a receita em tópicos de números, no seguinte formato: "1: blablabla. 2: blablabla. 3: ..."
      IMPORTANTE 3: Só utilize os nomes genéricos dos ingredientes.
      """;

    //IMPORTANTE 2: Nem sempre uma lista de produtos formará uma boa receita ou uma receita válida. Não responda com uma receita se não tiver certeza de seu interesse e verossimilhança.
    //IMPORTANTE 1: Ignore produtos que não tenham a ver com a receita sugerida.

    /*for(var prod in suggestion.totalProductList){
      print("NOME PROD: ${prod}");
    }*/
    
    var userMessage = "RECEITA: ${suggestion.recipe}, INGREDIENTES: ${suggestion.totalProductList.map((e) => e).join(', ')}";
    //print("X2 - UserMessage: $userMessage");
    var messages = [
      OpenAIChatCompletionChoiceMessageModel(
        content: systemMessage,
        role: OpenAIChatMessageRole.system,
      ),
      OpenAIChatCompletionChoiceMessageModel(
        content: userMessage,
        role: OpenAIChatMessageRole.user,
      ),
    ];

    var chatCompletion = await _aiService.createChat(
      //model: "ft:gpt-3.5-turbo-0613:hh:recipe-steps:7vYfv166",
      model: model,
      messages: messages,
    );

    //print(" FT3!!!! X2_2 RESPOSTA: ${chatCompletion.choices[0].message.content}");
    //print("FT3!!!! X2_2 Tokens: ${chatCompletion.usage.totalTokens.toString()}");

    // Atribui a descrição à RecipeModel
    RecipeModel recipeModel = RecipeModel();
    recipeModel.recipeName = suggestion.recipe;
    recipeModel.ingredients = suggestion.dbSearchResultList;
    recipeModel = await ax4(recipeModel);
    recipeModel.description = px2(chatCompletion.choices[0].message.content);
    
    LogService.logInfo('X2 ---> RECEITA: ${recipeModel.recipeName}', 'AI');
    
    //  for (var passo in recipeModel.description) {
    //      print("PASSO: $passo");
    //  }
    //print("FT3!!!! X2_2 TERMINADO");

    if (onCompleted != null) onCompleted();
    return recipeModel;
  } 

  //////////////////////
  /// HANDLE X2 (PÓS X2)
  //////////////////////
  ///  Quebra os passos da receita
  List<String> px2(String response) {
    final descriptionPattern = RegExp(r'(\d+:.*?)(?=\d+:|$)', dotAll: true);
    var matches = descriptionPattern.allMatches(response);

    // Processa cada passo para remover a vírgula final, se houver
    List<String> steps = matches.map((match) {
      String step = match.group(1)!;
      if (step.endsWith(',')) {
        step = step.substring(0, step.length - 1);
      }
      return step.trim();
    }).toList();

    return steps;
  }


  /////////////
  /// ax2_1 ///
  /////////////
  Future<bool> ax2_1(String receita, List<String> listaReceitas) async {
    
    LogService.logInfo("AX2_1! ==> ENTREI", 'AI');
    // Se a lista de receitas estiver vazia, retorne false imediatamente
    if (listaReceitas.isEmpty) {
      return false;
    }

    String receitas = listaReceitas.join(', ');



    var systemMessage = 
      """

      Vou lhe dar uma receita. Quero que você me diga, com '1' ou '0', se existe alguma receita muito parecida ou semanticamente igual em uma lista de receitas que vou fornecer. 
      Use '1' para sim e '0' para não, mesmo em línguas diferentes.
      Exemplo 1: RECEITA: Risoto de Camarão, LISTA RECEITAS: [Risoto Camarão] ==> Resposta: 1
      Exemplo 2: RECEITA: Bolo de Cenoura, LISTA RECEITAS: [Bolo de Chocolate, Bolo de Laranja] ==> Resposta: 0
      Exemplo 3: RECEITA: Hot Dog, LISTA RECEITAS: [Hambúrguer, Cachorro Quente] ==> Resposta: 1
      Exemplo 4: RECEITA: Lasanha à Bolonhesa, LISTA RECEITAS:[Espaguete à Bolonhesa, Lasanha ao Molho Branco] ==> Resposta: 0
      Exemplo 4: RECEITA: Macarrão à Bolonhesa, LISTA RECEITAS:[Espaguete à Bolonhesa] ==> Resposta: 1
      """;

    var userMessage = 
      """
      A Receita $receita é igual ou muito parecida a qualquer uma das Receitas a seguir? $receitas. 1 é Sim e 0 é não
      Responda EXCLUSIVAMENTE E TÃO SOMENTE: 1 ou 0
      """;

    var messages = [
      OpenAIChatCompletionChoiceMessageModel(
        content: systemMessage,
        role: OpenAIChatMessageRole.system,
      ),
      OpenAIChatCompletionChoiceMessageModel(
        content: userMessage,
        role: OpenAIChatMessageRole.user,
      ),
    ];

    var chatCompletion = await _aiService.createChat(
      model:  "ft:gpt-3.5-turbo-0613:hh:recipe-class:7vB97XDH", //model,
      messages: messages,
    );

    //("AX2_1 Tokens: ${chatCompletion.usage.totalTokens}");
    // Assume-se que a resposta será '1' para verdadeiro e '0' para falso.
    LogService.logInfo("AX2_1 => ${chatCompletion.choices[0].message.content.trim()}", 'AI');
    return chatCompletion.choices[0].message.content.trim() == '1';
  }


  /////////////
  /// ax3   ///  ----- Classificador de Produtos
  /////////////
  Future<String> ax3_1(String produto) async {
    var systemMessage = 
        """
        Classifique o produto usando as siglas.
        """ ;

      var userMessage = produto;

      var messages = [
        OpenAIChatCompletionChoiceMessageModel(
          content: systemMessage,
          role: OpenAIChatMessageRole.system,
        ),
        OpenAIChatCompletionChoiceMessageModel(
          content: userMessage,
          role: OpenAIChatMessageRole.user,
        ),
      ];

      var chatCompletion = await _aiService.createChat(
        model: "ft:gpt-3.5-turbo-0613:hh:product-class:7vxjWkX0",
        //model: model,
        messages: messages,
      );

      //print("Tokens:" + chatCompletion.usage.totalTokens.toString());
      String response = chatCompletion.choices[0].message.content.trim().replaceAll(" > ", "");
      LogService.logInfo("AX3 RESPONSE:: $response", 'AI');
      return response;
    }


  /////////////
  /// ax3_1 ///
  /////////////
  Future<String> ax3(String produto) async {
    var systemMessage = 
      """
      Esse é um API que categoriza produtos em categorias de Supermercado segundo a tabela abaixo: 
      sig0;cat0;sig1;cat1;cat2s
      B;Bebidas;BA;Adega;Cerveja Garrafa (BBACG) , Cerveja Lata (BBACL) , Destilados (BBADE) , Vinhos (BBAVI)
      B;Bebidas;BE;Bebidas;Água de Coco (BBEAC) , Água (BBEAG) , Energéticos (BBEEN) , Lácteos (BBELA) , Refrigerante (BBERE) , Sucos (BBESU)
      E;Estocáveis;BA;Básicos;Açúcares (EBAAC) , Matinais (EBACA) , Básicos (EBACE) , Massas (EBAMA) , Óleos (EBAOL)
      E;Estocáveis;DO;Doces;Biscoitos (EDOBI) , Bomboniere (EDOBO) , Mel e Geleias (EDOME) , Sobremesa (EDOSB)
      E;Estocáveis;ME;Mercearia;Conservas (EMECO) , Fórmulas (EMEFO) , Leite Condensado (EMELE) , Refresco Em Pó (EMERE) , Salgadinhos (EMESA) , Suplementos (EMESU)
      E;Estocáveis;PA;Padaria;Misturas (EPAMI) , Pães (EPAPA)
      E;Estocáveis;PR;Preparos;Molhos (EPRMO) , Sopas (EPRSO) , Temperos (EPRTE)
      H;Hortifruti;FL;In Natura;Frutas (HFLFR) , Legumes (HFLLE) , Verduras (HFLVE)
      H;Hortifruti;MI;Mix;Flores (HMIFL) , Mix (HMIMI) , Ovos (HMIOV)
      L;Limpeza;HI;Higiene;Absorventes (LHIAB) , Bucal (LHIBU) , Fraldas (LHIFR) , Papel Higiênico (LHIPA)
      L;Limpeza;LI;Limpeza;Limpeza de Cozinha (LLICO) , Lavanderia para Roupas (LLILA) , Limpeza Geral (LLILI)
      L;Limpeza;PE;Perfumaria;Barba (LPEBA) , Cabelo (LPECA) , Corpo (LPECO)
      L;Limpeza;SA;Saúde;Acessórios (LSAAC) , Remédios (LSARE) , Vitaminas (LSAVI)
      P;Perecíveis;AC;Acougue (Carnes Resfriadas);Aves (PACAV) , Carnes (PACCA)
      P;Perecíveis;CG;Congelados;Bovino (PCGBO) , Frango (PCGFR) , Petiscos (PCGPE) , Polpas (PCGPO) , Preparados (PCGPR) , Pescados (PCGPX) , Sorvetes (PCGSO) , Suino (PCGSU) , Vegetais (PCGVE)
      P;Perecíveis;FR;Frios;Linguiças e Presuntos (PFREM) , Iogurtes (PFRIO) , Manteigas (PFRMA) , Queijos (PFRQU)
      U;Utilitários;CA;Acessórios;Banheiro (UCABA) , Brinquedos (UCABR) , Decoracao (UCADE) , Papelaria (UCAPA) , Tecnologia (UCATE)
      U;Utilitários;CO;Cozinha;Copos (UCOCO) , Descartáveis (UCODE) , Eletroportáteis (UCOEL) , Louças (UCOLO) , Panelas (UCOPA) , Talheres (UCOTA) , Utensílios (UCOUT)
      U;Utilitários;MO;Moda;Calçados (UMOCA), Roupas (UMORO), Uniformes (UMOUN)
      U;Utilitários;PT;Pet Shop;Rações (UPTAL) , Brinquedos (UPTBR) , Higiene (UPTHI)
      U;Utilitários;VE;Veículos;Aditivos (UVEAD) , Limpeza (UVELI), Óleos (UVEOL)

      Vou lhe dar um produto e sua resposta deverá ser SOMENTE e EXCLUSIVAMENTE: A sigla de 5 letras entre parenteses correspondente na tabela.
      Exemplo: Arroz. Resposta: EBACE
      Exemplo: Alho. Resposta: HFLLE
      Exemplo: Sal. Resposta: EPRTE
      Exemplo: oleo de oliva. Resposta: EBAOL
      """;

      var userMessage = "ax3_1 Produto: $produto. Responda SOMENTE e EXCLUSIVAMENTE: A sigla de 5 letras entre parenteses correspondente na tabela.";

      var messages = [
        OpenAIChatCompletionChoiceMessageModel(
          content: systemMessage,
          role: OpenAIChatMessageRole.system,
        ),
        OpenAIChatCompletionChoiceMessageModel(
          content: userMessage,
          role: OpenAIChatMessageRole.user,
        ),
      ];

      var chatCompletion = await _aiService.createChat(
        model: model,
        messages: messages,
      );

      LogService.logInfo("AX3_1 RESPONSE:: ${chatCompletion.choices[0].message.content.trim()}", 'AI');
      return chatCompletion.choices[0].message.content.trim();
    }
  


  /////////////
  /// ax4   ///  ----- Classificador de Receitas
  /////////////
  Future<RecipeModel> ax4(RecipeModel recipe) async {
    // Mensagem do sistema
    var systemMessage = 
        "Você é um classificador útil de receitas. Sua tarefa é classificar as receitas com base em seus títulos nas categorias e subcategorias apropriadas.";

    var userMessage = "Receita: ${recipe.recipeName}";

    var messages = [
      OpenAIChatCompletionChoiceMessageModel(
        content: systemMessage,
        role: OpenAIChatMessageRole.system,
      ),
      OpenAIChatCompletionChoiceMessageModel(
        content: userMessage,
        role: OpenAIChatMessageRole.user,
      ),
    ];

    // Chamada ao ChatCompletion da OpenAI usando o modelo específico
    var chatCompletion = await _aiService.createChat(
      model: "ft:gpt-3.5-turbo-0613:hh:recipe-class:7vB97XDH",
      //model: model,
      messages: messages,
    );

    //print("Tokens: ${chatCompletion.usage.totalTokens.toString()}");

    // Extração da resposta e divisão nas categorias
    var responseContent = chatCompletion.choices[0].message.content.trim();
    var categories = responseContent.split(';');
    
    if (categories.length > 1) {
      recipe.catRecipe = categories[0];
      recipe.subCatRecipe = categories[1];
    } else if (categories.length == 1) {
      recipe.catRecipe = categories[0];
    }

    //print("AX4::::: ${recipe.catRecipe}  ; ${recipe.subCatRecipe}");
    LogService.logInfo("AX4::::: ${recipe.catRecipe}  ; ${recipe.subCatRecipe}", 'AI');

    return recipe;
  }  


  

}


      /*suggestion.suggestProductList.map((product) async {
        return SearchModel(
          searchType: "product", //"prod_cat",  
          nome: product,
          //sigla: await ax3(product),
        );
      }).toList();*/
  
 /*aX3
  /////////////
  /// ax3_1 ///
  /////////////
  Future<String> ax3_1(String produto) async {
    var systemMessage = 
      """
      Esse é um API que categoriza produtos em categorias de Supermercado segundo a tabela abaixo: 
      sig0;cat0;sig1;cat1;cat2s
      B;Bebidas;BA;Adega;Cerveja Garrafa (BBACG) , Cerveja Lata (BBACL) , Destilados (BBADE) , Vinhos (BBAVI)
      B;Bebidas;BE;Bebidas;Água de Coco (BBEAC) , Água (BBEAG) , Energéticos (BBEEN) , Lácteos (BBELA) , Refrigerante (BBERE) , Sucos (BBESU)
      E;Estocáveis;BA;Básicos;Açúcares (EBAAC) , Matinais (EBACA) , Básicos (EBACE) , Massas (EBAMA) , Óleos (EBAOL)
      E;Estocáveis;DO;Doces;Biscoitos (EDOBI) , Bomboniere (EDOBO) , Mel e Geleias (EDOME) , Sobremesa (EDOSB)
      E;Estocáveis;ME;Mercearia;Conservas (EMECO) , Fórmulas (EMEFO) , Leite Condensado (EMELE) , Refresco Em Pó (EMERE) , Salgadinhos (EMESA) , Suplementos (EMESU)
      E;Estocáveis;PA;Padaria;Misturas (EPAMI) , Pães (EPAPA)
      E;Estocáveis;PR;Preparos;Molhos (EPRMO) , Sopas (EPRSO) , Temperos (EPRTE)
      H;Hortifruti;FL;In Natura;Frutas (HFLFR) , Legumes (HFLLE) , Verduras (HFLVE)
      H;Hortifruti;MI;Mix;Flores (HMIFL) , Mix (HMIMI) , Ovos (HMIOV)
      L;Limpeza;HI;Higiene;Absorventes (LHIAB) , Bucal (LHIBU) , Fraldas (LHIFR) , Papel Higiênico (LHIPA)
      L;Limpeza;LI;Limpeza;Limpeza de Cozinha (LLICO) , Lavanderia para Roupas (LLILA) , Limpeza Geral (LLILI)
      L;Limpeza;PE;Perfumaria;Barba (LPEBA) , Cabelo (LPECA) , Corpo (LPECO)
      L;Limpeza;SA;Saúde;Acessórios (LSAAC) , Remédios (LSARE) , Vitaminas (LSAVI)
      P;Perecíveis;AC;Acougue (Carnes Resfriadas);Aves (PACAV) , Carnes (PACCA)
      P;Perecíveis;CG;Congelados;Bovino (PCGBO) , Frango (PCGFR) , Petiscos (PCGPE) , Polpas (PCGPO) , Preparados (PCGPR) , Pescados (PCGPX) , Sorvetes (PCGSO) , Suino (PCGSU) , Vegetais (PCGVE)
      P;Perecíveis;FR;Frios;Linguiças e Presuntos (PFREM) , Iogurtes (PFRIO) , Manteigas (PFRMA) , Queijos (PFRQU)
      U;Utilitários;CA;Acessórios;Banheiro (UCABA) , Brinquedos (UCABR) , Decoracao (UCADE) , Papelaria (UCAPA) , Tecnologia (UCATE)
      U;Utilitários;CO;Cozinha;Copos (UCOCO) , Descartáveis (UCODE) , Eletroportáteis (UCOEL) , Louças (UCOLO) , Panelas (UCOPA) , Talheres (UCOTA) , Utensílios (UCOUT)
      U;Utilitários;MO;Moda;Calçados (UMOCA), Roupas (UMORO), Uniformes (UMOUN)
      U;Utilitários;PT;Pet Shop;Rações (UPTAL) , Brinquedos (UPTBR) , Higiene (UPTHI)
      U;Utilitários;VE;Veículos;Aditivos (UVEAD) , Limpeza (UVELI), Óleos (UVEOL)

      Vou lhe dar um produto e sua resposta deverá ser SOMENTE e EXCLUSIVAMENTE: A sigla de 5 letras entre parenteses correspondente na tabela.
      Exemplo: Arroz. Resposta: EBACE
      Exemplo: Alho. Resposta: HFLLE
      Exemplo: Sal. Resposta: EPRTE
      Exemplo: oleo de oliva. Resposta: EBAOL
      """;

      var userMessage = "ax3_1 Produto: $produto. Responda SOMENTE e EXCLUSIVAMENTE: A sigla de 5 letras entre parenteses correspondente na tabela.";

      var messages = [
        OpenAIChatCompletionChoiceMessageModel(
          content: systemMessage,
          role: OpenAIChatMessageRole.system,
        ),
        OpenAIChatCompletionChoiceMessageModel(
          content: userMessage,
          role: OpenAIChatMessageRole.user,
        ),
      ];

      var chatCompletion = await _aiService.createChat(
        model: model,
        messages: messages,
      );

      print("Tokens:" + chatCompletion.usage.totalTokens.toString());
      return chatCompletion.choices[0].message.content.trim();
    }
  */
  /*AX3_2
  /////////////
  /// ax3_2 ///
  /////////////
  Future<String> ax3_2(String produto) async {
    var systemMessage = 
        """
        Esse é um API que categoriza produtos em 6 categorias de Supermercado: 
        H (Hortifruti), B (Bebidas), E (Estocáveis), P (Perecíveis),  L (Limpeza), U (Utensílios).
        Vou lhe dar um produto e sua resposta deverá ser SOMENTE e EXCLUSIVAMENTE uma dessas seis letras: B,E,P,H,L,U.
        Exemplos:
        B (Bebidas: líquidos como água, refrigerantes, bebidas alcoólicas, sucos),
        E (Estocáveis: pós, grãos como arroz, feijão, cereais, pães, conservas, biscoitos, chocolates, bombons, doces),
        P (Perecíveis: carnes, congelados, frios, embutidos, queijos, polpas),
        H (Hortifruti: ovos, frutas, verduras, legumes, raízes, tubérculos in natura ou minimamente processados),
        L (Limpeza: produtos de limpeza e higiene para casa, corpo, cabelo, roupas),
        U (Utensílios: bens duráveis vendidos em supermercado).
        Responda SOMENTE e EXCLUSIVAMENTE com uma única letra: B,E,P,H,L,U.
         """ ;

      var userMessage = "ax3_2 Produto: $produto. Responda SOMENTE e EXCLUSIVAMENTEcom uma única letra: B,E,P,H,L,U";

      var messages = [
        OpenAIChatCompletionChoiceMessageModel(
          content: systemMessage,
          role: OpenAIChatMessageRole.system,
        ),
        OpenAIChatCompletionChoiceMessageModel(
          content: userMessage,
          role: OpenAIChatMessageRole.user,
        ),
      ];

      var chatCompletion = await _aiService.createChat(
        model: model,
        messages: messages,
      );

      print("Tokens:" + chatCompletion.usage.totalTokens.toString());
      return chatCompletion.choices[0].message.content.trim();
    }
  */

 /* X2
  /////////////
  ///  X2  ////
  /////////////
  //Future<RecipeModel> x2(SuggestionModel suggestion) async {
  Future<RecipeModel> x2(SuggestionModel suggestion, {void Function()? onCompleted}) async {

    
    var systemMessage = 
      """
      Você funcionará como um API para supermercado chamado X2. 
      Com base no nome da receita e na lista de ingredientes, você deverá fornecer um passo-a-passo em tópicos para preparar uma receita conhecida e consagrada.
      O resultado será utilizado por um outro API. 
      Dessa forma, é EXTREMAMENTE importante que você responda EXATAMENTE no seguinte formato (Uma Lista de Strings): 
      ["Passo 1: descrição do passo 1", Passo 2: descrição do passo 2, ...]
      Exemplo: Para a receita 'Feijoada' e a lista de ingredientes "Feijão Preto, Linguiça, Arroz, Bacon, Paio, Couve mineira, Laranja, Pimenta", a resposta deve ser:
      ["Passo 1: Coloque o feijão preto de molho por 12 horas", "Passo 2: Frite a linguiça e o bacon", ...]
      Se não tiver sugestão, somente responda com valor vazio, dessa forma: []
      Forneça a receita mais relevante com a lista de produtos.
      """;

    //IMPORTANTE 2: Nem sempre uma lista de produtos formará uma boa receita ou uma receita válida. Não responda com uma receita se não tiver certeza de seu interesse e verossimilhança.
    //IMPORTANTE 1: Ignore produtos que não tenham a ver com a receita sugerida.

    /*for(var prod in suggestion.totalProductList){
      print("NOME PROD: ${prod}");
    }*/
    


    var userMessage = "RECEITA: ${suggestion.recipe}, INGREDIENTES: ${suggestion.totalProductList.map((e) => e).join(', ')}";
    print("X2 - UserMessage: $userMessage");
    var messages = [
      OpenAIChatCompletionChoiceMessageModel(
        content: systemMessage,
        role: OpenAIChatMessageRole.system,
      ),
      OpenAIChatCompletionChoiceMessageModel(
        content: userMessage,
        role: OpenAIChatMessageRole.user,
      ),
    ];

    var chatCompletion = await _aiService.createChat(
      model: model,
      messages: messages,
    );

    print("X2 RESPOSTA: ${chatCompletion.choices[0].message.content}");
    print("X2 Tokens: ${chatCompletion.usage.totalTokens.toString()}");

    // Atribui a descrição à RecipeModel
    RecipeModel recipeModel = RecipeModel();
    recipeModel.recipeName = suggestion.recipe;
    recipeModel.ingredients = suggestion.dbSearchResultList;
    recipeModel.description = handleX2Response(chatCompletion.choices[0].message.content);
    print('X2 ---> RECEITA: ${recipeModel.recipeName}');
      for (var passo in recipeModel.description) {
          print("PASSO: $passo");
      }
    print("X2 TERMINADO");

    if (onCompleted != null) onCompleted();
    return recipeModel;
  } 

    //////////////////////
  List<String> handleX2Response(String response) {
    final descriptionPattern = RegExp(r'"(Passo \d+:.*?)"', dotAll: true);
    //final descriptionPattern = RegExp(r'Passo (\d+:.*?)', dotAll: true);
    //final descriptionPattern = RegExp(r'Passo (\d+:.*?)(?= Passo|$)', dotAll: true);
    var matches = descriptionPattern.allMatches(response);
    //List<String> description = matches.map((match) => match.group(1)!).replaceFirst("Passo ", "")).toList(); 
    List<String> description = matches.map((match) => match.group(1)!.replaceFirst("Passo ", "")).toList(); 
    return description;
  }
  */

  /* hx2 v1
  List<String> handleX2Response(String response) {
    final descriptionPattern = RegExp(r'Passo \d+: .*?(?={|$)');
    var matches = descriptionPattern.allMatches(response);
    List<String> description = matches.map((match) => match.group(0)!.replaceFirst('{', '').replaceFirst('}', '').trim()).toList(); 
    return description;
  }*/

  /* hx2 v2
  List<String> handleX2Response(String response) {
    final descriptionPattern = RegExp(r'(Passo \d+: {.*?})');
    var matches = descriptionPattern.allMatches(response);
    print("MATCHES: $matches");
    List<String> description = matches.map((match) => match.group(0)!.trim()).toList(); 
    return description;
  }*/

    // Aqui você precisará de uma função para parsear a resposta do GPT-3.5-turbo e transformá-la em uma lista de strings
    //var descriptionPattern = RegExp(r'Passo \d+: {(.*?)}');
    /*
    var descriptionPattern = RegExp(r'(Passo \d+: {.*?})');
    print("DESCRIPTION PATTERN: $descriptionPattern");
    var matches = descriptionPattern.allMatches(chatCompletion.choices[0].message.content);
    print("MATCHES: $matches");
    List<String> description = matches.map((match) => match.group(1)!.trim()).toList();
    */  

    /*
    var systemMessage = 
      """
      Você funcionará com um API de recomendação de produtos. Esse API se chama Xerxes v.1, e seu apelido é X1.
      Vou listar alguns produtos e você deverá perguntar se quero fazer alguma receita.
      e logo em seguida entregar uma lista de produtos que se relacionam com eles.Siga exatamente os exemplos.
      Exemplo 1: X1 Limão, Cachaça. Resposta: Você quer fazer uma caipirinha ? Gelo, Açúcar Mascavo, Morango, Maracujá
      Exemplo 2: X1 Leite, Farinha, Chocolate. Resposta: Você quer fazer um bolo de chocolate ? Fermento, Ovos, Açúcar, Chocolate em barras.
      Exemplo 3: X1 Feijão preto, Linguiça. Resposta: Você quer fazer uma feijoada? Arroz, Bacon, Paio, Couve mineira, Laranja, Pimenta.
      """;

    var userMessage = "X1 $productsStr";
    */

  /* x1  
  Future<String> X1(List<String> products) async {
    var productsStr = products.join(', ');
    var systemMessage = 
      """
      Você funcionará com um API de recomendação de produtos. Esse API se chama Xerxes v.1, e seu apelido é X1.
      Vou listar alguns produtos e você deverá perguntar se quero fazer alguma receita.
      e logo em seguida entregar uma lista de produtos que se relacionam com eles.Siga exatamente os exemplos.
      Exemplo 1: X1 Limão, Cachaça. Resposta: Você quer fazer uma caipirinha ? Gelo, Açúcar Mascavo, Morango, Maracujá
      Exemplo 2: X1 Leite, Farinha, Chocolate. Resposta: Você quer fazer um bolo de chocolate ? Fermento, Ovos, Açúcar, Chocolate em barras.
      Exemplo 3: X1 Feijão preto, Linguiça. Resposta: Você quer fazer uma feijoada? Arroz, Bacon, Paio, Couve mineira, Laranja, Pimenta.
      """;

    var userMessage = "X1 $productsStr";

    var messages = [
      OpenAIChatCompletionChoiceMessageModel(
        content: systemMessage,
        role: OpenAIChatMessageRole.system,
      ),
      OpenAIChatCompletionChoiceMessageModel(
        content: userMessage,
        role: OpenAIChatMessageRole.user,
      ),
    ];

    var chatCompletion = await _aiService.createCompletion(
      model: "gpt-3.5-turbo",
      prompt: messages,
    );

    return chatCompletion.choices[0].messages.content;
  }*/

  // Continue with X1a, X2, X2a in the same manner

/*
class Xerxes {
  late AIService _aiService;


  // Função para criar a string de produtos
  String _createProductString(List<EanModel> produtos) {
    return produtos.map((produto) => produto.nome).join(", ");
  }

  Future<String> x1(List<EanModel> produtos) async {
    String produtosStr = _createProductString(produtos);
    String prompt = 
      """
      Você funcionará com um API de recomendação de produtos. Esse API se chama Xerxes v.1, e seu apelido é X1. 
      Vou listar alguns produtos e você deverá perguntar se quero fazer alguma receita.
      e logo em seguida entregar uma lista de produtos que se relacionam com eles.Siga exatamente os exemplos.
      Exemplo 1: X1 Limão, Cachaça. Resposta: Você quer fazer uma caipirinha ? Gelo, Açúcar Mascavo, Morango, Maracujá.
      Exemplo 2: X1 Leite, Farinha, Chocolate. Resposta: Você quer fazer um bolo de chocolate ? Fermento, Ovos, Açúcar, Chocolate em barras.
      Exemplo 3: X1 Feijão preto, Linguiça. Resposta: Você quer fazer uma feijoada? Arroz, Bacon, Paio, Couve mineira, Laranja, Pimenta.
      X1 $produtosStr.
      """;
    return await _aiService.generateText(prompt, 200);
  }

  // Funções X1a, X2, X2a seguem um padrão similar
}
*/

  //Future<SuggestionModel> x1(List<String> products) async {
  /*Future<SuggestionModel> x1(List<String> products, {void Function()? onCompleted}) async {
    var productsStr = products.join(', ');*/

  //Future<SuggestionModel> x1(List<EanModel> products, {void Function()? onCompleted}) async {

    //Anterior:
    //var productsStr = products.map((product) => product.nome).join(', ');

    // Filtrar produtos que podem ser ingredientes em uma receita
    /*List<EanModel> filteredProducts = [];


    for (var product in products) {
      String result = await ax1(product.nome);
      print("${product.nome} é $result");
      if (result == 'I') {
        filteredProducts.add(product);
      }
    }*/

/* x1

Future<SuggestionModel> x1(BasketModel basketModel, {void Function()? onCompleted}) async {
  
    // Use a lista de produtos diretamente de BasketModel
    List<EanModel> products = basketModel.products;
  
    // Filtrar produtos que podem ser ingredientes em uma receita (usando informações em BasketModel)
    List<EanModel> filteredProducts = products.where((product) {
      EanInfo? info = basketModel.productInfo[product];
      return info?.hintStatus == HintStatus.I;
    }).toList();


    var productsStr = filteredProducts.map((product) => product.nome).join(', ');

    // Resto é identico
    var systemMessage = 
      """
      Você funcionará como um API para supermercado chamado X1. 
      Você receberá uma lista de produtos. Você deverá escolher desta lista alguns produtos para sugerir o nome de uma receita o os ingredientes adicionais necessários. 
      Não considere produtos que não tenham a ver com a receita sugerida.  
      O nome da receita será utilizado por um outro API. A lista de produtos será utilizada em outro API.
      Dessa forma, é EXTREMAMENTE importante que você responda EXATAMENTE da mesma maneira que os exemplos abaixos:
      Exemplo 1: "X1 Feijão Preto, Linguiça, Cerveja". Resposta: '{Sugestão: {Feijoada}, Lista: {Arroz, Bacon, Paio, Couve mineira, Laranja, Pimenta}}'
      Exemplo 2: "X1 Leite, Farinha, Chocolate, Peixe". Resposta: '{Sugestão: {Bolo de Chocolate}, Lista: {Fermento, Ovos, Açúcar, Chocolate em barras}}'
      IMPORTANTE 1: Se um dos produtos não tiver ligação com os outros em uma possível receita, simplesmente ignore aquele produto específico, como Cerveja e Peixe nos exemplos.
      IMPORTANTE 2: Se não tiver sugestão, somente responda com valores vazios, dessa forma: {Sugestão: [], Lista: []}
      IMPORTANTE 3: Não invente receita! Não dê receitas com ingredientes se não forem compatíveis!
      IMPORTANTE 4: Não seja genérico! Só dê receitas consagradas e conhecidas!
      """;

    var userMessage = "X1 $productsStr";

    // Com base nos produtos listados, você deverá fornecer o nome de uma receita sugerida e uma lista com o nome dos ingredientes adicionais necessários sugeridos.
    var messages = [
      OpenAIChatCompletionChoiceMessageModel(
        content: systemMessage,
        role: OpenAIChatMessageRole.system,
      ),
      OpenAIChatCompletionChoiceMessageModel(
        content: userMessage,
        role: OpenAIChatMessageRole.user,
      ),
    ];

    var chatCompletion = await _aiService.createChat(
      model: model,
      messages: messages,
    );

    SuggestionModel suggestion = SuggestionModel();
    //suggestion.initialProductList = products;
    //suggestion.initialProductList = products.map((product) => product.nome).toList();
    // Copiamos a lista de produtos para initialProductList em vez de mapeá-la para seus nomes
    suggestion.initialProductList = List.from(products);
    suggestion = await px1(chatCompletion.choices[0].message.content, suggestion);
    suggestion.createTotalProductList();

    print(
      """
      "X1 ---> RECEITA: ${suggestion.recipe},\n 
      PRODUCTS: $products, \n
      LISTA INITIAL:  ${suggestion.initialProductList.map((product) => product.nome).join(', ')},\n
      LISTA SUGEST: ${suggestion.suggestProductList},\n
      LISTA TOTAL: ${suggestion.totalProductList},\n
      """);  // Imprima a recomendação. Voce pode fazer algo mais com isso, se quiser
    
    print("X1 TERMINADO");
    suggestion.toString();

    if (onCompleted != null) onCompleted();
    return suggestion;
    
  }

  /////////////////////////
  // Método para lidar com a resposta do X1 e transformá-la em uma instância de SuggestionModel
  Future<SuggestionModel> px1(String response, SuggestionModel suggestion) async {
    
    //SuggestionModel suggestion = SuggestionModel();
    final suggestionPattern = RegExp(r'Sugestão: {(.*?)}');
    final listPattern = RegExp(r'Lista: {(.*?)}');

    final suggestionMatch = suggestionPattern.firstMatch(response);
    final listMatch = listPattern.firstMatch(response);

    if (suggestionMatch == null || listMatch == null) {
      // Trata erro de formatação na resposta
      // ...
      return suggestion;
    }

    suggestion.recipe = suggestionMatch.group(1)!.trim();
    suggestion.suggestProductList = listMatch.group(1)!
        .split(',')
        .map((ingredient) => ingredient.trim())
        .toList();

    // Se a sugestão ou a lista de ingredientes forem strings vazias, substitua-as por valores padrão
    if (suggestion.recipe == '[]') suggestion.recipe = '';
    //if (suggestion.suggestProductList.length == 1 && suggestion.suggestProductList[0] == '[]') suggestion.suggestProductList = [];

    suggestion.toSearchModelList();

    for (var searchModel in suggestion.searchProductList) {
      print(searchModel.toString());
      String sigla = await ax3(searchModel.nome); // ax3_1 é por cat2 - 1100 tokens;  ax3_2 é por cat0 - 300 tokens
      searchModel.sigla = sigla;  // Atualiza a sigla
      searchModel.searchType = 'prod_cat';
      print("AX3_3 (FT!!!): ${searchModel.nome} ==> $sigla");
    }

    await suggestion.generateDBSearchResults();

    return suggestion;
  }
*/
  
/* x1 anterior 23/09/23
  Future<String> x1(BasketModel basketModel) async {
  
    // Use a lista de produtos diretamente de BasketModel
    List<EanModel> products = basketModel.products;
  
    // Filtrar produtos que podem ser ingredientes em uma receita (usando informações em BasketModel)
    List<EanModel> filteredProducts = products.where((product) {
      EanInfo? info = basketModel.productInfo[product];
      return info?.hintStatus == HintStatus.I;
    }).toList();


    var productsStr = filteredProducts.map((product) => product.nome).join(', ');

    // Resto é identico
    var systemMessage = 
      """
      Você funcionará como um API para supermercado. 
      Você receberá uma lista de produtos. Você deverá escolher desta lista alguns produtos para sugerir o nome de uma receita o os ingredientes adicionais necessários. 
      Não considere produtos que não tenham a ver com a receita sugerida.  
      O nome da receita será utilizado por um outro API. A lista de produtos será utilizada em outro API.
      Dessa forma, é EXTREMAMENTE importante que você responda EXATAMENTE da mesma maneira que os exemplos abaixos:
      Exemplo 1: "Feijão Preto, Linguiça". Resposta: '{Sugestão: {Feijoada}, Lista: {Arroz, Bacon, Paio, Couve mineira, Laranja, Pimenta}}'
      Exemplo 2: "Leite, Farinha, Chocolate". Resposta: '{Sugestão: {Bolo de Chocolate}, Lista: {Fermento, Ovos, Açúcar, Chocolate em barras}}'
      
      """;

    var userMessage = productsStr;
    //IMPORTANTE 1: Se um dos produtos não tiver ligação com os outros em uma possível receita, simplesmente ignore aquele produto específico, como Cerveja e Peixe nos exemplos.
    //IMPORTANTE 2: Se não tiver sugestão, somente responda com valores vazios, dessa forma: {Sugestão: [], Lista: []}
    //IMPORTANTE 3: Não invente receita! Não dê receitas com ingredientes se não forem compatíveis!
    //IMPORTANTE 4: Não seja genérico! Só dê receitas consagradas e conhecidas!
    // Com base nos produtos listados, você deverá fornecer o nome de uma receita sugerida e uma lista com o nome dos ingredientes adicionais necessários sugeridos.
    var messages = [
      OpenAIChatCompletionChoiceMessageModel(
        content: systemMessage,
        role: OpenAIChatMessageRole.system,
      ),
      OpenAIChatCompletionChoiceMessageModel(
        content: userMessage,
        role: OpenAIChatMessageRole.user,
      ),
    ];

    var chatCompletion = await _aiService.createChat(
      model: model,
      messages: messages,
    );

    print(chatCompletion);
    return chatCompletion.choices[0].message.content;
  }
  */
