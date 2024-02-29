import 'package:hh_2/src/config/common/var/hh_summary.dart';
import 'package:hh_2/src/config/db/db_service.dart';

class DBSummary {
  final DBService _dbService;

  DBSummary(this._dbService);

  Future<void> fetchSummary(int userId) async {
    final sql = 'SELECT * FROM ReportSummary WHERE user_id = ?';
    final values = [userId];
    final results = await _dbService.query(sql, values);

    if (results.isNotEmpty) {
      var summary = results.first;
      print("ANTES: ${summary.toString()}");

      // Atualizar os valores estáticos em HHSummary com os dados da consulta
      HHSummary.userLogin = summary['user_login'];
      HHSummary.numeroCompras = int.parse(summary['NumeroCompras'].toString());
      HHSummary.valorTotalCompras = double.parse(summary['ValorTotalCompras'].toString());
      HHSummary.ticketMedio = double.parse(summary['TicketMedio'].toString());
      HHSummary.qtdeMediaProdutosCompra = double.parse(summary['QtdeMediaProdutosCompra'].toString());
      HHSummary.valorMaximoProduto = double.parse(summary['ValorMaximoProduto'].toString());
      HHSummary.dataPrimeiraCompra = summary['DataPrimeiraCompra'];
      HHSummary.dataUltimaCompra = summary['DataUltimaCompra'];
      HHSummary.diaSemanaMaisComum = summary['DiaSemanaMaisComum'];
      HHSummary.horarioMaisComum = summary['HorarioMaisComum'];
      HHSummary.frequenciaMediaComprasDias = double.parse(summary['FrequenciaMediaComprasDias'].toString());
      HHSummary.categoriaPrincipal = summary['CategoriaPrincipal'];
      HHSummary.marcaPrincipal = summary['MarcaPrincipal'];
      HHSummary.produtoMaisComprado = summary['ProdutoMaisComprado'];
      HHSummary.G = double.parse(summary['G'].toString());
      HHSummary.pG = double.parse(summary['pG'].toString());
      HHSummary.H = double.parse(summary['H'].toString());
      HHSummary.pH = double.parse(summary['pH'].toString());
      HHSummary.R = double.parse(summary['R'].toString());
      HHSummary.pR = double.parse(summary['pR'].toString());
      HHSummary.B = double.parse(summary['B'].toString());
      HHSummary.pB = double.parse(summary['pB'].toString());
      HHSummary.E = double.parse(summary['E'].toString());
      HHSummary.pE = double.parse(summary['pE'].toString());

      print("DEPOIS: ${HHSummary.toStaticString()}");
    }
  }
}
