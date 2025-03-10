// ignore_for_file: use_string_in_part_of_directives

part of clean_arch_view_model_builder;

void main(List<String> arguments) {
  if (arguments.length != 3 || arguments[0] != 'clean_arch' || arguments[1] != '-create-mvc') {
    if (kDebugMode) {
      print('⚠️ Kullanım: clean_arch -create-mvc [ModuleName]');
    }
    return;
  }

  final String moduleName = arguments[2].toLowerCase(); // Örn: splash
  final String modulePath = 'screens/$moduleName';
  final String srcPath = '$modulePath/src';
  final Map<String, String> files = {
    '$modulePath/splash.dart': _generateLibraryFile(moduleName),
    '$srcPath/controller/__init__.dart': _generateControllerFile(moduleName),
    '$srcPath/view/__init__.dart': _generateViewFile(moduleName),
    '$srcPath/service/__init__.dart': _generateServiceFile(moduleName),
  };

  for (var path in files.keys) {
    _createFileWithContent(path, files[path]!);
  }

  if (kDebugMode) {
    print("✅ '$moduleName' modülü başarıyla oluşturuldu!");
  }
}

void _createFileWithContent(String path, String content) {
  final file = File(path);
  file.createSync(recursive: true);
  file.writeAsStringSync(content);
  if (kDebugMode) {
    print('📄 Dosya oluşturuldu: $path');
  }
}

/// 📌 **splash.dart İçeriği**
String _generateLibraryFile(String moduleName) => '''
// ignore_for_file: unnecessary_library_name

library $moduleName;

import 'package:clean_arch/clean_arch.dart';
import 'package:flutter/material.dart';

part 'src/controller/__init__.dart';
part 'src/service/__init__.dart';
part 'src/view/__init__.dart';
''';

/// 📌 **Controller Dosyası İçeriği**
String _generateControllerFile(String moduleName) => '''
// ignore_for_file: use_string_in_part_of_directives

part of $moduleName;

class ${_capitalize(moduleName)}Controller extends CleanArchBaseController {
  
}
''';

/// 📌 **View Dosyası İçeriği**
String _generateViewFile(String moduleName) => '''
// ignore: use_string_in_part_of_directives
part of $moduleName;

class ${_capitalize(moduleName)}View extends StatelessWidget {
  const ${_capitalize(moduleName)}View({super.key});

  @override
  Widget build(BuildContext context) {
    return CleanArchBuilder(
      viewModelBuilder: () => ${_capitalize(moduleName)}Controller(),
      serviceBuilder: () => ${_capitalize(moduleName)}Service(),
      builder: (context, controller, child) {
        return const SizedBox.shrink();
      },
    );
  }
}
''';

/// 📌 **Service Dosyası İçeriği**
String _generateServiceFile(String moduleName) => '''
// ignore_for_file: use_string_in_part_of_directives

part of $moduleName;

class ${_capitalize(moduleName)}Service extends CleanArchBaseService {
  @override
  void init() {
    // TODO: implement init
  }
}
''';

/// **İlk harfi büyük yapar (örn: splash -> Splash)**
String _capitalize(String text) => text[0].toUpperCase() + text.substring(1);