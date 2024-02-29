import 'package:flutter/material.dart';
import 'package:hh_2/src/config/common/var/hh_globals.dart';
import 'package:intl/intl.dart';
import 'package:hh_2/src/config/common/var/hh_colors.dart';
import '../../config/common/var/hh_summary.dart';

class SummaryPage extends StatelessWidget {
  final moneyFormat = NumberFormat.simpleCurrency(locale: 'pt_BR');
  final dateFormat = DateFormat('dd/MM/yyyy');
  final timeFormat = DateFormat('HH:mm');

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4.0),
      child: Text(
        text,
        style: TextStyle(color: HHColors.hhColorFirst, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildDataBox(String data, {bool isCurrency = false, bool isPercentage = false, bool isDate = false, bool isTime = false}) {
    TextStyle valueStyle = TextStyle(
      fontSize: 16,
      color: Colors.black,
      fontWeight: FontWeight.bold,
    );

    String formattedData = data;
    if (isCurrency) {
      formattedData = moneyFormat.format(double.tryParse(data) ?? 0);
    } else if (isPercentage) {
      formattedData += '%';
    } else if (isDate) {
      try {
        final date = dateFormat.parse(data);
        formattedData = dateFormat.format(date);
      } catch (e) {
        formattedData = data;
      }
    } else if (isTime) {
      try {
        final time = timeFormat.parse(data);
        formattedData = timeFormat.format(time);
      } catch (e) {
        formattedData = data;
      }
    }

    return Container(
      height: 40.0,
      padding: const EdgeInsets.symmetric(horizontal: 0.0),
      decoration: BoxDecoration(
        color: HHColors.hhColorWhite,
        borderRadius: BorderRadius.circular(8),
      ),
      alignment: Alignment.center,
      child: FittedBox(
        fit: BoxFit.scaleDown, // Isso garante que o texto se redimensione para caber no espaço disponível
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0),
          decoration: BoxDecoration(
            color: HHColors.hhColorWhite,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(formattedData, style: valueStyle),
        ),
      ),
    );
  }




  Widget _buildDataRow({required String label, required String data, bool isCurrency = false, bool isPercentage = false, bool isDate = false, bool isTime = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLabel(label),
        _buildDataBox(data, isCurrency: isCurrency, isPercentage: isPercentage, isDate: isDate, isTime: isTime),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: HHColors.hhColorGreyMedium,
      appBar: AppBar(
        title: Text(
          'Relatório de Compra',
          style: TextStyle(color: HHColors.hhColorWhite),
        ),
        backgroundColor: HHColors.hhColorFirst,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Primeira linha com dois itens
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  flex: 3, // Ajuste de acordo com a proporção desejada
                  child: _buildDataRow(
                    label: 'Nome',
                    data: HHGlobals.HHUser.name, // Substituir pelo valor adequado
                  ),
                ),
                const SizedBox(width: 16), // Espaçamento entre os boxes
                Expanded(
                  flex: 2, // Ajuste de acordo com a proporção desejada
                  child: _buildDataRow(
                    label: 'Login',
                    data: HHGlobals.HHUser.login, // Substituir pelo valor adequado
                  ),
                ),
                const SizedBox(width: 16), // Espaçamento entre os boxes
                Expanded(
                  flex: 2, // Ajuste de acordo com a proporção desejada
                  child: _buildDataRow(
                    label: 'UF',
                    data: HHGlobals.HHUser.uf, // Substituir pelo valor adequado
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16), // Espaçamento entre as linhas
            // Segunda linha com três itens
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: _buildDataRow(
                    label: 'Valor Total',
                    data: HHSummary.valorTotalCompras.toString(),
                    isCurrency: true,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildDataRow(
                    label: 'Ticket Médio',
                    data: HHSummary.ticketMedio.toString(),
                    isCurrency: true,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildDataRow(
                    label: 'Compras',
                    data: HHSummary.numeroCompras.toString(),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16), // Espaçamento entre as linhas
            // Continuação da terceira linha com três itens
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: _buildDataRow(
                    label: 'Quantidade Produtos Média',
                    data: HHSummary.qtdeMediaProdutosCompra.toString(), // Substituir pelo valor adequado
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildDataRow(
                    label: 'Valor Máximo Produto',
                    data: HHSummary.valorMaximoProduto.toString(),
                    isCurrency: true,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildDataRow(
                    label: 'Frequência Média (dias)',
                    data: HHSummary.frequenciaMediaComprasDias.toString(), // Substituir pelo valor adequado
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16), // Espaçamento entre as linhas

            // Quarta linha com dois itens
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: _buildDataRow(
                    label: 'Data Primeira Compra',
                    data: dateFormat.format(DateTime.parse(HHSummary.dataPrimeiraCompra)),
                  ),
                ),
                const SizedBox(width: 16), // Espaçamento entre os boxes
                Expanded(
                  child: _buildDataRow(
                    label: 'Data Última Compra',
                    data: dateFormat.format(DateTime.parse(HHSummary.dataUltimaCompra)),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16), // Espaçamento entre as linhas

            // Quinta linha com dois itens
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: _buildDataRow(
                    label: 'Horário Mais Comum',
                    data: HHSummary.horarioMaisComum, // Garanta que esteja em formato 'HH:mm'
                  ),
                ),
                const SizedBox(width: 16), // Espaçamento entre os boxes
                Expanded(
                  child: _buildDataRow(
                    label: 'Dia Semana Mais Comum',
                    data: HHSummary.diaSemanaMaisComum,
                  ),
                ),
              ],
            ),
            const SizedBox(height:16), // Espaçamento entre as linhas

            // Sexta linha com três itens
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: _buildDataRow(
                    label: 'Categoria Principal',
                    data: HHSummary.categoriaPrincipal, // Substituir pelo valor adequado
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildDataRow(
                    label: 'Marca Principal Comprada',
                    data: HHSummary.marcaPrincipal, // Substituir pelo valor adequado
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildDataRow(
                    label: 'Produto Mais Comprado',
                    data: HHSummary.produtoMaisComprado, // Substituir pelo valor adequado
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16), // Espaçamento entre as linhas

            // Sétima linha com quatro itens
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    children: [
                      _buildDataRow(
                        label: 'Compra Padrão',
                        data: HHSummary.G.toString(),
                        isCurrency: true,
                      ),
                      _buildDataRow(
                        label: '',
                        data: HHSummary.pG.toString(),
                        isPercentage: true,
                      ),
                    ],
                  )
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    children: [
                      _buildDataRow(
                        label: 'Compra Histórico',
                        data: HHSummary.H.toString(),
                        isCurrency: true,
                      ),
                      _buildDataRow(
                        label: '',
                        data: HHSummary.pH.toString(),
                        isPercentage: true,
                      ),
                    ],
                  )
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    children: [
                      _buildDataRow(
                        label: 'Compra Receita',
                        data: HHSummary.R.toString(),
                        isCurrency: true,
                      ),
                      _buildDataRow(
                        label: '',
                        data: HHSummary.pR.toString(),
                        isPercentage: true,
                      ),
                    ],
                  )
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    children: [
                      _buildDataRow(
                        label: 'Compra Livro',
                        data: HHSummary.B.toString(),
                        isCurrency: true,
                      ),
                      _buildDataRow(
                        label: '',
                        data: HHSummary.pB.toString(),
                        isPercentage: true,
                      ),
                    ],
                  )
                ),
              ],
            ),
            //const SizedBox(height: 16), // Espaçamento entre as linhas
          ],
        ),
      ),
    );
  }
}