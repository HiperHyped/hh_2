import 'package:hh_2/src/config/common/components/hh_button.dart';
import 'package:hh_2/src/config/common/components/hh_text_field.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:hh_2/src/config/common/var/hh_colors.dart';

class PayByCardTab extends StatelessWidget {
  final double totalPrice;

  PayByCardTab({required this.totalPrice});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pop(context);
      },
      child: Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.6,
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
                    'Pagamento com Cartão',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: HHColors.hhColorFirst),
                  ),
                  SizedBox(height: 8),
                  // Exibe o valor total da compra
                  Text(
                    "Pagar ${NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$').format(totalPrice)}",
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: HHColors.hhColorFirst),
                  ),
                SizedBox(height: 8),
                // Número do cartão
                const HHTextField(
                  label: 'Número do cartão',
                  icon: Icons.credit_card,
                  keyboardType: TextInputType.number,
                ),
                  
                SizedBox(height: 8),
                // Data de validade
                const HHTextField(
                  label: 'Data de validade',
                  hint: 'MM/AA',
                  icon: Icons.calendar_month,
                  keyboardType: TextInputType.datetime,
                ),

                SizedBox(height: 8),
                // Código de segurança
                const HHTextField(
                  label: 'Código de segurança',
                  icon: Icons.security,
                  keyboardType: TextInputType.number,
                ),
                SizedBox(height: 8),
                // Botão de confirmar pagamento
                HHButton(
                  onPressed: () {},
                  label: 'Pagar'
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
