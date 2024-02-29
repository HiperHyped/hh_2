import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:hh_2/src/config/common/var/hh_globals.dart';
import 'package:hh_2/src/config/common/var/hh_settings.dart';
import 'package:hh_2/src/config/common/var/hh_var.dart';
import 'package:hh_2/src/models/ean_model.dart';
import 'package:hh_2/src/models/user_model.dart';
import 'package:hh_2/src/pages/grid/components/image_tile.dart';


class ProdGrid extends StatefulWidget {


  ProdGrid({
    Key? key,
  }) : super(key: key);

  @override
  State<ProdGrid> createState() => _ProdGridState();
}


class _ProdGridState extends State<ProdGrid> {
  void resetScroll() {
    innerController.jumpTo(0);
  }

  final innerController = ScrollController();
  final double _offset = 2;

  final double _vRatio = HHVar.vRatio;
  final double _hRatio = HHVar.hRatio;

  final int index = 0;

  final double _padding = 0;
  final double _spacing = 0;
  EanModel selectedProduct = EanModel();
  UserModel user = HHGlobals.HHUser;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: HHGlobals.HHGridList,
      builder: (context, List<EanModel> products, _) {
        return Scrollbar(
          controller: innerController,
          thumbVisibility: false,
          child: Listener(
            onPointerSignal: (event) {
              if (event is PointerScrollEvent) {
                final offset = event.scrollDelta.dy;
                innerController.jumpTo(innerController.offset + offset * _offset);
              }
            },
            child: NotificationListener<ScrollNotification>(
              onNotification: (t) {
                if (t is ScrollUpdateNotification) {
                } else if (t is ScrollEndNotification) {}
                return true;
              },
              child: GridView.builder(
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.all(_padding),
                controller: innerController,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: HHSettings.gridLines,
                  childAspectRatio: HHSettings.gridView? _vRatio: _hRatio,
                  mainAxisSpacing: _spacing,
                  crossAxisSpacing: _spacing,
                ),
                itemCount: products.length,
                itemBuilder: (BuildContext context, int index) {
                  return ImageTile(
                    onPressed: (){
                      setState(() {
                        selectedProduct = products[index];
                        HHGlobals.selectedProduct = products[index];
                        }
                      );
                    },
                    product: products[index],
                    selected: products[index].ean == HHGlobals.selectedProduct.ean,
                    );
                },
              ),
            ),
          ),
        );
      }, //builder
    );
  }

  @override
  void didUpdateWidget(covariant ProdGrid oldWidget) {
    super.didUpdateWidget(oldWidget);
    resetScroll();
  }
}


//v0
/*
class ProdGrid extends StatefulWidget {
  final bool isVertical;
  final int vCross;
  final int hCross;

  ProdGrid({
    Key? key,
    required this.isVertical,
    required this.vCross,
    required this.hCross,
  }) : super(key: key);

  @override
  State<ProdGrid> createState() => _ProdGridState();
}

class _ProdGridState extends State<ProdGrid> {
  void resetScroll() {
    innerController.jumpTo(0);
  }

  final innerController = ScrollController();
  final double _offset = 2;

  List<EanModel> products = [];

  final double _vRatio = HHVar.vRatio;
  final double _hRatio = HHVar.hRatio;

  final int index = 0;

  final double _padding = 0;
  final double _spacing = 0;
  EanModel selectedProduct = EanModel();
  UserModel user = HHGlobals.HHUser;

  @override
  void initState() {
    super.initState();
    products = HHGlobals.HHGridList;
  }

  @override
  Widget build(BuildContext context) {
    return Scrollbar(
      controller: innerController,
      thumbVisibility: false,
      child: Listener(
        onPointerSignal: (event) {
          if (event is PointerScrollEvent) {
            final offset = event.scrollDelta.dy;
            innerController.jumpTo(innerController.offset + offset * _offset);
          }
        },
        child: NotificationListener<ScrollNotification>(
          onNotification: (t) {
            if (t is ScrollUpdateNotification) {
            } else if (t is ScrollEndNotification) {}
            return true;
          },
          child: GridView.builder(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.all(_padding),
            controller: innerController,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: widget.isVertical ? widget.vCross : widget.hCross,
              childAspectRatio: widget.isVertical? _vRatio: _hRatio,
              mainAxisSpacing: _spacing,
              crossAxisSpacing: _spacing,
            ),
            itemCount: products.length,
            itemBuilder: (BuildContext context, int index) {
              return ImageTile(
                onPressed: (){
                  setState(() {
                    selectedProduct = products[index];
                    HHGlobals.selectedProduct = products[index];
                    }
                  );
                },
                product: products[index],
                selected: products[index].ean == HHGlobals.selectedProduct.ean,
                );
            },
          ),
        ),
      ),
    );
  }
}
*/