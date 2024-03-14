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
      HHSummary.tempoUltimaCompra = int.parse(summary['TempoUltimaCompra'].toString());  
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

  Future<void> fetchTimeSummary(int userId) async {
    final sql = 'SELECT * FROM TimeSummary WHERE user_id = ?';
    final values = [userId];
    final results = await _dbService.query(sql, values);

    //print("RESULT FETCH TIMESUMMARY:/n");
    //print(results.first);
    if (results.isNotEmpty) {
      var summary = results.first;
      
      // Assuming the DBService returns a map for each row
      Map<String, int> weekCounts = {};
      Map<String, int> hourCounts = {};

      // Extract weekCounts and hourCounts from summary
      for (var day in ['dom', 'seg', 'ter', 'qua', 'qui', 'sex', 'sab']) {
        weekCounts[day] = int.tryParse(summary[day].toString()) ?? 0;
      }
      for (var hour in ['00h', '03h', '06h', '09h', '12h', '15h', '18h', '21h']) {
        hourCounts[hour] = int.tryParse(summary[hour].toString()) ?? 0;
      }
      TimeSummary timeSummary = TimeSummary(weekCounts: weekCounts, hourCounts: hourCounts);
      
      HHSummary.setTimeSummary(timeSummary);
      print(HHSummary.timeSummary!.weekCounts);
      print(HHSummary.timeSummary!.hourCounts);

      // Encontrar o dia da semana mais comum
      var commonDay = timeSummary.weekCounts.entries.reduce((a, b) => a.value > b.value ? a : b).key;
      HHSummary.diaSemanaMaisComum = commonDay;

      // Encontrar o horário mais comum, arredondado
      var commonHour = timeSummary.hourCounts.entries.reduce((a, b) => a.value > b.value ? a : b).key;
      HHSummary.horarioMaisComum = commonHour;

      // Impressão para verificação
      print('Dia mais comum: $commonDay, com ${timeSummary.weekCounts[commonDay]} ocorrências');
      print('Hora mais comum: $commonHour, com ${timeSummary.hourCounts[commonHour]} ocorrências');
    } 
  }
}
