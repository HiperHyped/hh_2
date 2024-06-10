// v7.2 -  CAT3TILE - IA 15-05
/*
class Cat3Tile extends StatelessWidget {
  final CatModel cat;
  final VoidCallback onPressed;
  final String selectedCat;
  final bool vertical;

  Cat3Tile({
    Key? key,
    required this.cat,
    required this.onPressed,
    required this.selectedCat,
    required this.vertical,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (vertical == false) {
      return Row(
        children: [
          Cat3Box(
            cat: cat, 
            onTap: cat.level == 2 ? onPressed : null,
            isSelected: selectedCat == cat.sigla,
          ),
          if (cat.subCats != null && cat.subCats.isNotEmpty)
            ListView.builder(
              scrollDirection: Axis.horizontal,
              shrinkWrap: true, // importante para evitar conflitos de rolagem
              physics: NeverScrollableScrollPhysics(), // importante para evitar conflitos de rolagem
              itemCount: cat.subCats.length,
              itemBuilder: (context, index) {
                return Cat3Tile(
                  onPressed: onPressed,
                  cat: cat.subCats[index], // IA 15-05 - Correção: deve passar cat.subCats[index] e não apenas cat
                  selectedCat: selectedCat,
                  vertical: vertical,
                );
              },
            ),
        ],
      );
    } else {
      return Column(
        children: [
          Cat3Box(
            cat: cat, 
            onTap: cat.level == 2 ? onPressed : null,
            isSelected: selectedCat == cat.sigla,
          ),
          if (cat.subCats != null && cat.subCats.isNotEmpty)
            ListView.builder(
              scrollDirection: Axis.vertical,
              shrinkWrap: true, // importante para evitar conflitos de rolagem
              physics: NeverScrollableScrollPhysics(), // importante para evitar conflitos de rolagem
              itemCount: cat.subCats.length,
              itemBuilder: (context, index) {
                return Cat3Tile(
                  onPressed: onPressed,
                  cat: cat.subCats[index], // IA 15-05 - Correção: deve passar cat.subCats[index] e não apenas cat
                  selectedCat: selectedCat,
                  vertical: vertical,
                );
              },
            ),
        ],
      );
    }
  }
}
*/
//FIM CAT3TILE - IA 15-05


// v7.1 -  CAT3TILE - IA 15-05
/*class Cat3Tile extends StatelessWidget {
  final CatModel cat;
  final VoidCallback onPressed;

  Cat3Tile({
    Key? key,
    required this.cat,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Column(
        children: [
          Cat3Box(
            cat: cat, 
            onTap: cat.level == 2 ? onPressed : null,
            ),
          if (cat.subCats != null && cat.subCats.isNotEmpty)
            ListView.builder(
              shrinkWrap: true, // importante para evitar conflitos de rolagem
              physics: NeverScrollableScrollPhysics(), // importante para evitar conflitos de rolagem
              itemCount: cat.subCats.length,
              itemBuilder: (context, index) {
                return Cat3Tile(
                  onPressed: onPressed,
                  cat: cat.subCats[index],
                );
              },
            ),
        ],
      ),
    );
  }
}*/
//FIM CAT3TILE - IA 15-05


//v6 - 13-05
// IA 13-05: Adicionar o parâmetro 'isExpanded' ao widget Cat3Tile
/*class Cat3Tile extends StatelessWidget {
  final CatModel cat;
  final VoidCallback onPressed;
  final bool isExpanded; // IA 13-05: Novo parâmetro

  Cat3Tile({
    Key? key,
    required this.cat,
    required this.onPressed,
    required this.isExpanded, // IA 13-05: Novo parâmetro
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Column(
        children: [
          Cat3Box(cat: cat),
          if (isExpanded && cat.subCats != null && cat.subCats.isNotEmpty) // IA 13-05: Verifique 'isExpanded' antes de renderizar subcategorias
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: cat.subCats.length,
              itemBuilder: (context, index) {
                return Cat3Tile(
                  onPressed: () {},
                  cat: cat.subCats[index],
                  isExpanded: cat.subCats[index].isExpanded, // IA 13-05: Passe 'isExpanded' para subcategorias
                );
              },
            ),
        ],
      ),
    );
  }
}*/

//v5.5 com Cat3Box v5 --- nao funciona
/*
class Cat3Tile extends StatelessWidget {
  final CatModel cat;
  final VoidCallback onPressed;
  final bool isSelected;

  Cat3Tile({
    Key? key,
    required this.cat,
    required this.onPressed,
    required this.isSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Column(
        children: [
          Cat3Box(cat: cat, isSelected: isSelected, onTap: onPressed),
          if (cat.subCats != null && cat.subCats.isNotEmpty)
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: cat.subCats.length,
              itemBuilder: (context, index) {
                return Cat3Tile(
                  onPressed: () {},
                  cat: cat.subCats[index],
                  isSelected: cat.subCats[index].sig == cat.sig,
                );
              },
            ),
        ],
      ),
    );
  }
}
*/

//v5 ---- com Cat3Box v5

/*class Cat3Tile extends StatelessWidget {
  final CatModel cat;
  final bool isSelected;
  final VoidCallback onPressed;

  Cat3Tile({Key? key, required this.cat, required this.isSelected, required this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Column(
        children: [
          Cat3Box(cat: cat, isSelected: isSelected, onTap: onPressed),
          if (cat.subCats != null && cat.subCats.isNotEmpty)
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: cat.subCats.length,
              itemBuilder: (context, index) {
                return Cat3Tile(
                  onPressed: onPressed,
                  cat: cat.subCats[index],
                  isSelected: isSelected,
                );
              },
            ),
        ],
      ),
    );
  }
}*/


//QQ COISA TAMO AQUI
//v4  -- funcionando com Cat3Box v1 ---- FUNCIONA SEM LOGICA DE SELECAO
/*
class Cat3Tile extends StatelessWidget {
  final CatModel cat;
  final VoidCallback onPressed;

  Cat3Tile({
    Key? key,
    required this.cat,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Column(
        children: [
          Cat3Box(cat: cat),
          if (cat.subCats != null && cat.subCats.isNotEmpty)
            ListView.builder(
              shrinkWrap: true, // importante para evitar conflitos de rolagem
              physics: NeverScrollableScrollPhysics(), // importante para evitar conflitos de rolagem
              itemCount: cat.subCats.length,
              itemBuilder: (context, index) {
                return Cat3Tile(
                  onPressed: () {},
                  cat: cat.subCats[index],
                );
              },
            ),
        ],
      ),
    );
  }
}
*/

//v3
/*class Cat3Tile extends StatelessWidget {
  final CatModel cat;
  final VoidCallback onPressed;
  final int level;
  final bool vertical;

  Cat3Tile({
    Key? key,
    required this.cat,
    required this.onPressed,
    required this.level,
    this.vertical = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color tileColor;
    double tileSize;
    EdgeInsets tilePadding;

    switch (level) {
      case 0: // CAT0
        tileColor = cat.color;
        tileSize = 30;
        tilePadding = EdgeInsets.only(left: 0.0);
        break;
      case 1: // CAT1
        tileColor = cat.color;
        tileSize = 40;
        tilePadding = EdgeInsets.only(left: 10.0);
        break;
      default: // CAT2
        tileColor = cat.color;
        tileSize = 50;
        tilePadding = EdgeInsets.only(left: 20.0);
        break;
    }

    return Padding(
      padding: tilePadding,
      child: GestureDetector(
        onTap: onPressed,
        child: Column(
          children: [
            if (cat.subCats != null && cat.subCats.isNotEmpty)
              Expanded(
                child: ListView.builder(
                  itemCount: cat.subCats.length,
                  itemBuilder: (context, index) {
                    return Cat3Tile(
                      onPressed: () {}, // Provide a suitable onPressed function here
                      cat: cat.subCats[index],
                      level: level + 1,
                      vertical: vertical,
                    );
                  },
                ),
              ),
            Flexible(
              child: Container(
                width: vertical ? double.infinity : tileSize,
                height: vertical ? null : double.infinity,
                decoration: BoxDecoration(
                  color: tileColor,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: Text(
                    cat.emj,
                    style: TextStyle(fontSize: 24),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}*/

//v2
/*class Cat3Tile extends StatelessWidget {
  final CatModel cat;
  final VoidCallback onPressed;
  final int level;
  final bool vertical;

  Cat3Tile({
    Key? key,
    required this.cat,
    required this.onPressed,
    required this.level,
    this.vertical = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color tileColor;
    double tileSize;
    EdgeInsets tilePadding;

    switch (level) {
      case 0: // CAT0
        tileColor = cat.color; // Or any color you want for level 0
        tileSize = 30; // Or any size you want for level 0
        tilePadding = EdgeInsets.only(left: 0.0); // No indent for level 0
        break;
      case 1: // CAT1
        tileColor = cat.color; // Or any color you want for level 1
        tileSize = 40; // Or any size you want for level 1
        tilePadding = EdgeInsets.only(left: 10.0); // Indent for level 1
        break;
      default: // CAT2
        tileColor = cat.color; // Or any color you want for level 2
        tileSize = 50; // Or any size you want for level 2
        tilePadding = EdgeInsets.only(left: 20.0); // Double indent for level 2
        break;
    }

    return Padding(
      padding: tilePadding,
      child: GestureDetector(
        onTap: onPressed,
        child: Container(
          width: vertical ? double.infinity : tileSize,
          height: vertical ? tileSize : double.infinity,
          decoration: BoxDecoration(
            color: tileColor,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Center(
            child: Text(
              cat.emj,
              style: TextStyle(fontSize: 24),
            ),
          ),
        ),
      ),
    );
  }
}*/

//v1
/*class Cat3Tile extends StatelessWidget {
  final CatModel cat;
  final VoidCallback onPressed;
  final int level;

  Cat3Tile({
    Key? key,
    required this.cat,
    required this.onPressed,
    required this.level,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color tileColor;
    double tileSize;
    EdgeInsets tilePadding;

    switch (level) {
      case 0: // CAT0
        tileColor = cat.color; // Or any color you want for level 0
        tileSize = 30; // Or any size you want for level 0
        tilePadding = EdgeInsets.only(left: 0.0); // No indent for level 0
        break;
      case 1: // CAT1
        tileColor = cat.color; // Or any color you want for level 1
        tileSize = 40; // Or any size you want for level 1
        tilePadding = EdgeInsets.only(left: 10.0); // Indent for level 1
        break;
      default: // CAT2
        tileColor = cat.color; // Or any color you want for level 2
        tileSize = 50; // Or any size you want for level 2
        tilePadding = EdgeInsets.only(left: 20.0); // Double indent for level 2
        break;
    }

    return Padding(
      padding: tilePadding,
      child: GestureDetector(
        onTap: onPressed,
        child: Container(
          width: tileSize,
          height: tileSize,
          decoration: BoxDecoration(
            color: tileColor,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Center(
            child: Text(
              cat.emj,
              style: TextStyle(fontSize: 24),
            ),
          ),
        ),
      ),
    );
  }
}*/