import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:sqlite3_flutter_libs/sqlite3_flutter_libs.dart';
import 'dart:io';

QueryExecutor createConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'profileforge.sqlite3'));

    if (Platform.isAndroid) {
      await applyWorkaroundToOpenSqlite3OnOldAndroidVersions();
    }

    await file.parent.create(recursive: true);

    if (!await file.exists()) {
      try {
        final assetData = await rootBundle.load('assets/data/profileforge.sqlite3');
        await file.create(recursive: true);
        await file.writeAsBytes(assetData.buffer.asUint8List());
      } catch (_) {}
    }

    return NativeDatabase.createInBackground(file);
  });
}
