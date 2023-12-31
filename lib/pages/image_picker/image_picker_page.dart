import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sample/pages/image_picker/tmp_cache_directory.dart';
import 'package:image_picker/image_picker.dart';

class ImagePickerPage extends StatefulWidget {
  const ImagePickerPage({super.key});

  static Future<void> show(BuildContext context) {
    return Navigator.of(context, rootNavigator: true).push<void>(
      CupertinoPageRoute(
        settings: const RouteSettings(name: 'image_picker_page'),
        builder: (_) => const ImagePickerPage(),
      ),
    );
  }

  @override
  State<ImagePickerPage> createState() => _State();
}

class _State extends State<ImagePickerPage> {
  Uint8List? _imageBytes;

  @override
  Widget build(BuildContext context) {
    final imageBytes = _imageBytes;

    Future<void> onPickImage() async {
      final xFile = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (xFile == null) {
        return;
      }
      debugPrint(xFile.path);
      final bytes = await xFile.readAsBytes();
      setState(() {
        _imageBytes = bytes;
      });
      // File(xFile.path).deleteSync();
    }

    Future<void> onClearTempFiles() async {
      await TmpCacheDirectory.deleteFiles();
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Image Picker'),
      ),
      body: Center(
        child: imageBytes != null
            ? Image.memory(
                imageBytes,
                width: 300,
                fit: BoxFit.contain,
              )
            : const SizedBox.shrink(),
      ),
      persistentFooterAlignment: AlignmentDirectional.center,
      persistentFooterButtons: [
        Column(
          children: [
            FilledButton(
              onPressed: onPickImage,
              child: const Text(
                '画像選択',
                maxLines: 1,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Flexible(
                  child: FilledButton(
                    onPressed: () async {
                      final files = await TmpCacheDirectory.fetchFiles();
                      if (files.isEmpty) {
                        debugPrint('empty');
                        return;
                      }
                      for (final element in files) {
                        debugPrint(element.path);
                      }
                    },
                    child: const Text(
                      'キャッシュ確認',
                      maxLines: 1,
                    ),
                  ),
                ),
                Flexible(
                  child: FilledButton(
                    onPressed: onClearTempFiles,
                    child: const Text(
                      'キャッシュ削除',
                      maxLines: 1,
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ],
    );
  }
}
