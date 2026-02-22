import 'dart:typed_data';

import 'io_download_image.dart'
    if (dart.library.html) 'web_download_image.dart';

Future<void> download(Uint8List bytes) => platformDownload(bytes);
