// ignore_for_file: use_string_in_part_of_directives, avoid_print

import 'dart:io';

void main(List<String> arguments) {
  if (arguments.length != 3 ||
      arguments[0].isEmpty ||
      arguments[2].isEmpty ||
      !(arguments[1] == '-create-mvc' || arguments[1] == '-create-repo')) {
    print('⚠️ Kullanım:');
    print('  clean_arch lib/screens -create-mvc [ModuleName]');
    print('  clean_arch lib/repository -create-repo [RepositoryName]');
    return;
  }

  final String basePath = arguments[0]; // lib/repository veya lib/screens
  final String command = arguments[1]; // -create-mvc veya -create-repo
  final String moduleName = arguments[2]; // Kullanıcıdan alınan isim (Auth)
  final String moduleSnakeCase = _toSnakeCase(moduleName); // auth
  final String modulePath = '$basePath/$moduleSnakeCase';

  if (command == '-create-mvc') {
    _generateMVC(modulePath, moduleName);
  } else if (command == '-create-repo') {
    _generateRepository(basePath,modulePath, moduleName);
  }
}

/// 📌 **MVC Yapısını Oluştur**
void _generateMVC(String modulePath, String moduleName) {
  final String srcPath = '$modulePath/src';

  final Map<String, String> files = {
    '$modulePath/${_toSnakeCase(moduleName)}.dart':
        _generateLibraryFile(moduleName),
    '$srcPath/controller/__init__.dart': _generateControllerFile(moduleName),
    '$srcPath/view/__init__.dart': _generateViewFile(moduleName),
    '$srcPath/service/__init__.dart': _generateServiceFile(moduleName),
  };

  for (var entry in files.entries) {
    _createFileWithContent(entry.key, entry.value);
  }

  print("✅ '${_toSnakeCase(moduleName)}' modülü başarıyla oluşturuldu!");
}

/// 📌 **Repository Yapısını Oluştur**
void _generateRepository(String basePath,String modulePath, String moduleName) {
  final String repoPath = modulePath;
  final String srcPath = '$repoPath/src';
  final String providerPath = '$srcPath/provider';
  final String providerSrcPath = '$providerPath/src';
  final String httpPath = '$providerSrcPath/http';
  final String mockPath = '$providerSrcPath/mock';
  final String repoClassName = '${moduleName}Repository';

  final Map<String, String> files = {
    '$repoPath/${_toSnakeCase(moduleName)}_repository.dart':
        _generateRepoLibraryFile(moduleName),
    '$srcPath/repo/__init__.dart': _generateRepoInitFile(moduleName),
    '$providerPath/${_toSnakeCase(moduleName)}_provider.dart':
        _generateProviderFile(moduleName),
    '$httpPath/__init__.dart': _generateHttpProviderFile(moduleName),
    '$mockPath/__init__.dart': _generateMockProviderFile(moduleName),
    '$basePath/__init__.dart':
        _generateDependencyInjectionFile(), // 📌 DI dosyasını ekle
  };

  for (var path in [
    repoPath,
    srcPath,
    providerPath,
    providerSrcPath,
    httpPath,
    mockPath
  ]) {
    Directory(path).createSync(recursive: true);
  }

  for (var entry in files.entries) {
    _createFileWithContent(entry.key, entry.value);
  }

  print("✅ '$repoClassName' deposu başarıyla oluşturuldu!");
}

/// 📌 **Dosya oluştur ve içerik ekle**
void _createFileWithContent(String path, String content) {
  final file = File(path);
  if (!file.existsSync()) {
    file.createSync(recursive: true);
    file.writeAsStringSync(content);
    print('📄 Dosya oluşturuldu: $path');
  }
}

/// 📌 **MVC Modülleri İçin Kod Üretimi**
String _generateLibraryFile(String moduleName) => '''
// ignore_for_file: unnecessary_library_name

library ${_toSnakeCase(moduleName)};

import 'package:clean_arch/clean_arch.dart';
import 'package:flutter/material.dart';

part 'src/controller/__init__.dart';
part 'src/service/__init__.dart';
part 'src/view/__init__.dart';
''';

String _generateControllerFile(String moduleName) => '''
// ignore_for_file: use_string_in_part_of_directives

part of ${_toSnakeCase(moduleName)};

class ${moduleName}Controller extends CleanArchBaseController {
  
}
''';

String _generateViewFile(String moduleName) => '''
// ignore: use_string_in_part_of_directives
part of ${_toSnakeCase(moduleName)};

class ${moduleName}View extends StatelessWidget {
  const ${moduleName}View({super.key});

  @override
  Widget build(BuildContext context) {
    return CleanArchBuilder(
      viewModelBuilder: () => ${moduleName}Controller(),
      serviceBuilder: () => ${moduleName}Service(),
      builder: (context, controller, service) {
        return const SizedBox.shrink();
      },
    );
  }
}
''';

String _generateServiceFile(String moduleName) => '''
// ignore_for_file: use_string_in_part_of_directives

part of ${_toSnakeCase(moduleName)};

class ${moduleName}Service extends CleanArchBaseService {
  @override
  void init() {
    // TODO: implement init
  }
  @override
  void dispose() {
    // TODO: implement dispose
  }
}
''';

/// 📌 **Repository İçin Kod Üretimi**
String _generateRepoLibraryFile(String moduleName) => '''
// ignore_for_file: unnecessary_library_name

library ${_toSnakeCase(moduleName)}_repository;

import 'package:clean_arch/clean_arch.dart';

part 'src/repo/__init__.dart';
part 'src/provider/${_toSnakeCase(moduleName)}_provider.dart';
part 'src/provider/src/http/__init__.dart';
part 'src/provider/src/mock/__init__.dart';
''';

String _generateRepoInitFile(String moduleName) => '''
// ignore_for_file: use_string_in_part_of_directives

part of ${_toSnakeCase(moduleName)}_repository;

abstract class ${moduleName}Repository implements CleanArchBaseRepository {

}
''';

String _generateProviderFile(String moduleName) => '''
// ignore_for_file: use_string_in_part_of_directives

part of ${_toSnakeCase(moduleName)}_repository;

class ${moduleName}Provider implements ${moduleName}Repository {
  final ${moduleName}Repository provider;
  ${moduleName}Provider({
    required this.provider,
  });
}
''';

String _generateHttpProviderFile(String moduleName) => '''
// ignore_for_file: use_string_in_part_of_directives

part of ${_toSnakeCase(moduleName)}_repository;

class ${moduleName}HttpProvider implements ${moduleName}Repository {
  
}
''';

String _generateMockProviderFile(String moduleName) => '''
// ignore_for_file: use_string_in_part_of_directives

part of ${_toSnakeCase(moduleName)}_repository;

class ${moduleName}MockProvider implements ${moduleName}Repository {
  
}
''';

String _generateDependencyInjectionFile() => '''
class RepositoryInjection {
  static final RepositoryInjection instance = RepositoryInjection._internal();

  factory RepositoryInjection() => instance;

  RepositoryInjection._internal();

  void init() {
   //TODO Injections here
  }
}
''';

/// 📌 **`AuthRepository` → `auth_repository` formatına çevirir**
String _toSnakeCase(String text) {
  return text.replaceAllMapped(RegExp(r'([a-z])([A-Z])'), (match) {
    return '${match.group(1)}_${match.group(2)}';
  }).toLowerCase();
}
