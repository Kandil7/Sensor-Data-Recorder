// import 'dart:io';
//
// import 'package:excel/excel.dart';
// import 'package:open_file/open_file.dart';
// import 'package:path_provider/path_provider.dart';
//
// Future<String> get _localPath async {
//   final directory = await getApplicationDocumentsDirectory();
//   return directory.path;
// }
// // Path: lib/excel_helper.dart
// Future<Excel> get _localFile async {
//   return Excel.createExcel();
//
// }
//
//  writeDate(
//   cellValue,{String sheet='Data'}) async {
//
//   var file = await Excel.createExcel();
//    //file.insertRowIterables(sheet, row, rowIndex);
//
//   for(var i = 1; i < cellValue.length+1; i++){
//     file[sheet].updateCell(CellIndex.indexByColumnRow(
//         columnIndex:1, rowIndex:i), cellValue[i].getDate.toString());
//     file[sheet].updateCell(CellIndex.indexByColumnRow(
//         columnIndex:2, rowIndex:i), cellValue[i].getValue[0].toString());
//     file[sheet].updateCell(CellIndex.indexByColumnRow(
//         columnIndex:3, rowIndex:i), cellValue[i].getValue[1].toString());
//     file[sheet].updateCell(CellIndex.indexByColumnRow(
//         columnIndex:4, rowIndex:i), cellValue[i].getValue[2].toString());
//
//   }
//
//
//   print('row inserted');
//   var directory = await getDownloadsDirectory()?? await getApplicationDocumentsDirectory();
//   File('${directory.path}/$sheet.xlsx').writeAsBytes(file.save()!);
//   print('${directory.path}/$sheet.xlsx');
//   await OpenFile.open('${directory.path}/$sheet.xlsx');
//
// }
//
// downloadExcel(String sheet) async {
//   var file = await _localFile;
//   var path = await getDownloadsDirectory();
//   File('$path/$sheet.xlsx').writeAsBytes(file.save()!);
//
// }
//
//
//
