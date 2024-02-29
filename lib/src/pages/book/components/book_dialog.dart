import 'package:flutter/material.dart';
import 'package:hh_2/src/config/common/var/hh_colors.dart';
import 'package:hh_2/src/models/suggestion_model.dart';

class BookDialog extends StatefulWidget {
  final SuggestionModel suggestion;
  final VoidCallback onThumbUp;
  final VoidCallback onThumbDown;
  final VoidCallback onShare;
  final int? userFeedback;
  final Function(int?) updateUserFeedback;

  BookDialog({
    required this.suggestion,
    required this.onThumbUp,
    required this.onThumbDown,
    required this.onShare,
    required this.userFeedback,
    required this.updateUserFeedback,
  });

  @override
  _BookDialogState createState() => _BookDialogState();
}

class _BookDialogState extends State<BookDialog> {
  int? userFeedback;

  @override
  void initState() {
    super.initState();
    userFeedback = widget.userFeedback;
  }

   @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onDoubleTap: () {
        Navigator.of(context).pop();
      },
      child: AlertDialog(
        backgroundColor: HHColors.hhColorGreyLight,
        shape: RoundedRectangleBorder(
          side: BorderSide(
            color: HHColors.hhColorDarkFirst, 
            style: BorderStyle.solid,
            width: 4.0,
          ),
          borderRadius: const BorderRadius.all(Radius.circular(12)),
        ),
        title: Center(
          child: Text(
            textAlign: TextAlign.center,
            widget.suggestion.recipe,
            style: TextStyle(color: HHColors.hhColorDarkFirst),
          ),
        ),
        content: SingleChildScrollView(
          child: Container(
            color: HHColors.hhColorGreyLight,
            child: Column(
              children: List.generate(
                widget.suggestion.recipeModel.description.length,
                (index) {
                  String step = widget.suggestion.recipeModel.description[index];
                  return Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(5),
                        ),
                      child: Padding(
                        padding: const EdgeInsets.all(2.0),
                        child: Text(
                          step,
                          style: const TextStyle(fontSize: 18),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.thumb_up_outlined),
            color: userFeedback == 1 ? HHColors.hhColorDarkFirst : HHColors.hhColorGreyDark,
            onPressed: () {
                setState(() {
                  userFeedback = 1;
                });
              widget.onThumbUp();
              //Navigator.of(context).pop(); // Fechar o dialog após ação do botão
            },
          ),
          IconButton(
            icon: const Icon(Icons.thumb_down_outlined),
            color: userFeedback == 0 ? HHColors.hhColorBack : HHColors.hhColorGreyDark,
            onPressed: () {
                  setState(() {
                    userFeedback = 0;
                  });
              widget.onThumbDown();
              //Navigator.of(context).pop(); // Fechar o dialog após ação do botão
            },
          ),
          IconButton(
            icon: const Icon(Icons.share_outlined),
            color: HHColors.hhColorGreyDark,
            onPressed: () {
              widget.onShare();
              //Navigator.of(context).pop(); // Fechar o dialog após ação do botão
            },
          ),
        ],
      ),
    );
  }

}