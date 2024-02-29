//v6 - 13-05
/*class Cat3Box extends StatefulWidget {
  final CatModel cat;
  //final VoidCallback onTap;

  Cat3Box({Key? key, required this.cat, /*required this.onTap*/}) : super(key: key);

  @override
  _Cat3BoxState createState() => _Cat3BoxState();
}

class _Cat3BoxState extends State<Cat3Box> {
  bool _isOpen = true;

  @override
  Widget build(BuildContext context) {
    Widget tile;
    switch (widget.cat.level) {
      case 0: // CAT0
        tile = Row(
          children: [
            // Adicione o botão aqui. IA 13-05
            IconButton(
              icon: Icon(_isOpen ? Icons.remove : Icons.add), // IA 13-05
              onPressed: () { // IA 13-05
                setState(() { // IA 13-05
                  _isOpen = !_isOpen; // IA 13-05
                }); // IA 13-05
              }, // IA 13-05
            ), // IA 13-05
            //Text(widget.cat.emj), 
            Expanded(child: Text(widget.cat.nom, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold))),
          ],
        );
        break;
      case 1: // CAT1
        tile = Padding(
          padding: EdgeInsets.only(left: 15),
          child: Row(
            children: [
              // Adicione o botão aqui. IA 13-05
              IconButton(
                icon: Icon(_isOpen ? Icons.remove : Icons.add), // IA 13-05
                onPressed: () { // IA 13-05
                  setState(() { // IA 13-05
                    _isOpen = !_isOpen; // IA 13-05
                  }); // IA 13-05
                }, // IA 13-05
              ), // IA 13-05
              //Text(widget.cat.emj), 
              Expanded(child: Text(widget.cat.nom, style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold))),
            ],
          ),
        );
        break;
      default: // CAT2
        tile = Row(
          children: [
            Text(widget.cat.emj), //, style: TextStyle(fontSize: 50)),
            SizedBox(width: 2),
            Expanded(child: Text(widget.cat.nom)),
          ],
        );
        break;
    }
    return GestureDetector(
      onTap: () {
        if (widget.cat.level < 2) {
          setState(() {
            _isOpen = !_isOpen;
          });
        } else {
          //widget.onTap();
        }
      },
      child: Container(
        padding: EdgeInsets.all(2),
        decoration: BoxDecoration(
          color: widget.cat.level<2?  widget.cat.color: Colors.transparent,
          borderRadius: BorderRadius.circular(5),
        ),
        child: _isOpen ? tile : null,
      ),
    );
  }
}
*/

//v5 com lógica de selection - não funciona
/*class Cat3Box extends StatefulWidget {
  final CatModel cat;
  final bool isSelected;
  final VoidCallback onTap;

  Cat3Box({Key? key, required this.cat, required this.isSelected, required this.onTap}) : super(key: key);

  @override
  _Cat3BoxState createState() => _Cat3BoxState();
}

class _Cat3BoxState extends State<Cat3Box> {
  bool _isOpen = true;

  @override
  Widget build(BuildContext context) {
    Widget tile;
    switch (widget.cat.level) {
      case 0: // CAT0
        tile = Row(
          children: [
            AutoSizeText(widget.cat.nom, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          ],
        );
        break;
      case 1: // CAT1
        tile = Padding(
          padding: EdgeInsets.only(left: 15),
          child: Row(
            children: [
              AutoSizeText(widget.cat.nom, style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
            ],
          ),
        );
        break;
      default: // CAT2
        tile = Row(
          children: [
            Text(widget.cat.emj),
            SizedBox(width: 2),
            AutoSizeText(widget.cat.nom),
          ],
        );
        break;
    }

    return GestureDetector(
      onTap: () {
        if (widget.cat.level < 2) {
          setState(() {
            _isOpen = !_isOpen;
          });
        } else {
          widget.onTap();
        }
      },
      child: Container(
        padding: EdgeInsets.all(2),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          border: Border.all(
            color: widget.isSelected ? HHColors.hhColorFirst : Colors.transparent,
            width: 2,
          ),
        ),
        child: _isOpen ? tile : null,
      ),
    );
  }
}*/

  //gesture Detector alterado
    /*return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        padding: EdgeInsets.all(2),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          border: Border.all(
            color: widget.isSelected ? HHColors.hhColorFirst : Colors.transparent,
            width: 2,
          ),
        ),
        child: tile,
      ),
    );
  }
}*/

//v4
/*class Cat3Box extends StatefulWidget {
  final CatModel cat;

  Cat3Box({Key? key, required this.cat}) : super(key: key);

  @override
  _Cat3BoxState createState() => _Cat3BoxState();
}

class _Cat3BoxState extends State<Cat3Box> {
  bool _isOpen = false;
  
  // MODIFICADO: Adicionado um novo estado para controlar se os filhos de Cat3Box estão abertos ou fechados
  bool _isChildrenOpen = false;

  @override
  Widget build(BuildContext context) {
    Widget tile;
    switch (widget.cat.level) {
      case 0: // CAT0
        tile = Row(
          children: [
            Expanded(child: Text(widget.cat.nom, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold))),
          ],
        );
        break;
      case 1: // CAT1
        tile = Padding(
          padding: EdgeInsets.only(left: 15),
          child: Row(
            children: [
              Expanded(child: Text(widget.cat.nom, style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold))),
            ],
          ),
        );
        break;
      default: // CAT2
        tile = Row(
          children: [
            Text(widget.cat.emj),
            SizedBox(width: 2),
            Expanded(child: Text(widget.cat.nom)),
          ],
        );
        break;
    }
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            if (widget.cat.level < 2) {
              setState(() {
                _isOpen = !_isOpen;
              });
            }
          },
          child: Container(
            padding: EdgeInsets.all(2),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
            ),
            child: Row(
              children: [
                if (widget.cat.level < 2)
                  IconButton(
                    iconSize: 20,
                    icon: Icon(_isOpen ? Icons.remove : Icons.add),
                    onPressed: () {
                      setState(() {
                        _isOpen = !_isOpen;
                        _isChildrenOpen = _isOpen; // MODIFICADO: Atualiza _isChildrenOpen quando o botão é pressionado
                      });
                    },
                  ),
                tile,
              ],
            ),
          ),
        ),
        if (_isOpen)
          ...widget.cat.subCats.map((cat) => Cat3Box(cat: cat)).toList(),
      ],
    );
  }
}*/


//v3
/*class Cat3Box extends StatefulWidget {
  final CatModel cat;
  final ValueChanged<bool> onExpand;

  Cat3Box({Key? key, required this.cat, required this.onExpand}) : super(key: key);

  @override
  _Cat3BoxState createState() => _Cat3BoxState();
}

class _Cat3BoxState extends State<Cat3Box> {
  bool _isOpen = false;

  @override
  Widget build(BuildContext context) {
    Widget tile;
    switch (widget.cat.level) {
      case 0: // CAT0
        tile = Row(
          children: [
            Text(widget.cat.nom, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          ],
        );
        break;
      case 1: // CAT1
        tile = Padding(
          padding: EdgeInsets.only(left: 15),
          child: Row(
            children: [
              Text(widget.cat.nom, style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
            ],
          ),
        );
        break;
      default: // CAT2
        tile = Row(
          children: [
            Text(widget.cat.emj),
            SizedBox(width: 2),
            Text(widget.cat.nom),
          ],
        );
        break;
    }

    return Column(
      children: [
        GestureDetector(
          onTap: () {
            if (widget.cat.level < 2) {
              setState(() {
                _isOpen = !_isOpen;
                widget.onExpand(_isOpen);
              });
            }
          },
          child: Container(
            padding: EdgeInsets.all(2),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
            ),
            child: Row(
              children: [
                if (widget.cat.level < 2)
                  IconButton(
                    iconSize: 20,
                    icon: Icon(_isOpen ? Icons.remove : Icons.add),
                    onPressed: () {
                      setState(() {
                        _isOpen = !_isOpen;
                        widget.onExpand(_isOpen);
                      });
                    },
                  ),
                tile,
              ],
            ),
          ),
        ),
        if (_isOpen)
          ...widget.cat.subCats.map((cat) => Cat3Box(cat: cat, onExpand: (bool value) {
            setState(() {
              _isOpen = value;
            });
          })).toList(),
      ],
    );
  }
}*/



//v2
/*class Cat3Box extends StatefulWidget {
  final CatModel cat;

  Cat3Box({Key? key, required this.cat}) : super(key: key);

  @override
  _Cat3BoxState createState() => _Cat3BoxState();
}

class _Cat3BoxState extends State<Cat3Box> {
  bool _isOpen = false;

  @override
  Widget build(BuildContext context) {
    Widget tile;
    switch (widget.cat.level) {
      case 0: // CAT0
        tile = Row(
          children: [
            Text(widget.cat.nom, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          ],
        );
        break;
      case 1: // CAT1
        tile = Padding(
          padding: EdgeInsets.only(left: 15),
          child: Row(
            children: [
              Text(widget.cat.nom, style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
            ],
          ),
        );
        break;
      default: // CAT2
        tile = Row(
          children: [
            Text(widget.cat.emj),
            SizedBox(width: 2),
            Text(widget.cat.nom),
          ],
        );
        break;
    }
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            if (widget.cat.level < 2) {
              setState(() {
                _isOpen = !_isOpen;
              });
            }
          },
          child: Container(
            padding: EdgeInsets.all(2),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
            ),
            child: Row(
              children: [
                if (widget.cat.level < 2)
                  IconButton(
                    iconSize: 20,
                    icon: Icon(_isOpen ? Icons.remove : Icons.add, ),
                    onPressed: () {
                      setState(() {
                        _isOpen = !_isOpen;
                      });
                    },
                  ),
                tile,
              ],
            ),
          ),
        ),
        if (_isOpen)
          ...widget.cat.subCats.map((cat) => Cat3Box(cat: cat)).toList(),
      ],
    );
  }
}*/


//v1 -- FUNCIONA ! AINDA SEM BOTOES NEM LOGICA DE EXPANSAO

/*class Cat3Box extends StatefulWidget {
  final CatModel cat;
  //final VoidCallback onTap;

  Cat3Box({Key? key, required this.cat, /*required this.onTap*/}) : super(key: key);

  @override
  _Cat3BoxState createState() => _Cat3BoxState();
}

class _Cat3BoxState extends State<Cat3Box> {
  bool _isOpen = true;

  @override
  Widget build(BuildContext context) {
    Widget tile;
    switch (widget.cat.level) {
      case 0: // CAT0
        tile = Row(
          children: [
            //Text(widget.cat.emj), 
            Expanded(child: Text(widget.cat.nom, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold))),
          ],
        );
        break;
      case 1: // CAT1
        tile = Padding(
          padding: EdgeInsets.only(left: 15),
          child: Row(
            children: [
              //Text(widget.cat.emj), 
              Expanded(child: Text(widget.cat.nom, style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold))),
            ],
          ),
        );
        break;
      default: // CAT2
        tile = Row(
          children: [
            Text(widget.cat.emj), //, style: TextStyle(fontSize: 50)),
            SizedBox(width: 2),
            Expanded(child: Text(widget.cat.nom)),
          ],
        );
        break;
    }
    return GestureDetector(
      onTap: () {
        if (widget.cat.level < 2) {
          setState(() {
            _isOpen = !_isOpen;
          });
        } else {
          //widget.onTap();
        }
      },
      child: Container(
        padding: EdgeInsets.all(2),
        decoration: BoxDecoration(
          color: widget.cat.level<2?  widget.cat.color: Colors.transparent,
          borderRadius: BorderRadius.circular(5),
        ),
        child: _isOpen ? tile : null,
      ),
    );
  }
}*/
