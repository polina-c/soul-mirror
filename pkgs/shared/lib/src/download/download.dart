import 'dart:typed_data';

import 'io_download.dart' if (dart.library.html) 'web_download.dart';

Future<void> download(Uint8List bytes) => platformDownload(bytes);
