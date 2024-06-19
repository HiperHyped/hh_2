

abstract class HHVar{


    // VARIAVEIS PARA DIVISÃO DE TELA - FLEX ENTRE CATBAR E GRIDTAB (cg)
    static int cgPVratio = 2 ; // 1:4 Portrait - Vertical
    static int cgPHratio = 10 ; // 1:7 Portrait - Horizontal
    static int cgLVratio = 3; // 1:6 Landscape - Vertical
    static int cgLHratio = 4 ; // 1:5 Landscape - Horizontal

    // VARIAVEIS PARA DIVISÃO DE TELA - FLEX ENTRE PRODPAGE E BASKETBAR (pb)
    static int pbPVratio = 4 ; // 1:4 Portrait - Vertical
    static int pbPHratio = 4 ; // 1:7 Portrait - Horizontal
    static int pbLVratio = 2 ; // 1:2 Landscape - Vertical
    static int pbLHratio = 2 ; // 1:2 Landscape - Horizontal

    // VARIAVEIS PARA DIVISÃO DE TELA - FLEX ENTRE PRODPAGE E BASKETBAR (pb)
    static int grPVline = 4 ; // 1:4 Portrait - Vertical
    static int grPHline = 4 ; // 1:7 Portrait - Horizontal
    static int grLVline = 3 ; // 1:2 Landscape - Vertical
    static int grLHline = 3 ; // 1:2 Landscape - Horizontal


    // VARIAVEIS PARA A RAZÃO ENTRE A ALTURA E LARGURA DO PRODUTO (PARA O GRIDTAB)
    static double vRatio = 2; //temos que dinamizar esse valor
    static double hRatio = 4;
    

    static bool isVertical = true;

    static bool rot90 = true;


    // VARIAVEIS PARA SUGGESTION CARD:
    static double sugWidth = 100;
    static double sugShrink = 30;
    static double barHeight =120;


    static String c = "?";
    //static String c = "%s";

    static int HistoryLimit = 5;


    // LIMITE PARA GRID
    static int GridLimit = 450;

    // XERXES OPERATIONS PERFORMING
    static bool XOPerforming = false;

}