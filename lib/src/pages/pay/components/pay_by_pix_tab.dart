import 'package:flutter/material.dart';
import 'package:hh_2/src/config/common/components/hh_button.dart';
import 'package:hh_2/src/config/common/var/hh_colors.dart';
import 'package:qr_flutter/qr_flutter.dart';

class PayByPixTab extends StatelessWidget {
  final double totalPrice;

  PayByPixTab({required this.totalPrice});

  @override
  Widget build(BuildContext context) {
    // Substitua isso pelo código Pix obtido da sua API
    final String pixCode = '12345678901234567890';

    return GestureDetector(
      onTap: () {
        Navigator.pop(context);
      },
      child: Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.3,
            maxHeight: MediaQuery.of(context).size.height * 0.9,
          ),
          child: Container(
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: HHColors.hhColorFirst,
                width: 4,
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Pagar R\$${totalPrice.toStringAsFixed(2)}',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: HHColors.hhColorFirst,
                  ),
                ),
                SizedBox(height: 8),
                const Text(
                  'Use o QR Code abaixo para realizar o pagamento pelo Pix:',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(height: 16),
                QrImage(
                  data: pixCode,
                  version: QrVersions.auto,
                  //size: MediaQuery.of(context).size.width * 0.6,
                  gapless: false,
                ),
                SizedBox(height: 8),
                // Botão de confirmar pagamento
                HHButton(
                  onPressed: () {},
                  label:'Pagar',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
