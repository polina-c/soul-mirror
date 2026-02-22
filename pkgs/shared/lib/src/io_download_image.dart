import 'dart:io';
import 'dart:typed_data';

import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

Future<void> platformDownloadImage(Uint8List bytes) async {
  final dir = await getDownloadsDirectory();
  if (dir == null) throw Exception('Downloads directory not available');
  await File(p.join(dir.path, 'image.png')).writeAsBytes(bytes);
}
