// ignore_for_file: use_string_in_part_of_directives

part of clean_arch_extensions;

class CleanArchAsset {
  late String _assetPath;
  void init(String assetPath) {
    _assetPath = assetPath;
  }

  String lottie(String assetName) {
    return "$_assetPath/lottie/$assetName";
  }

  String images(String assetName) {
    return "$_assetPath/images/$assetName";
  }


  String jsons(String assetName) {
    return "$_assetPath/jsons/$assetName";
  }

  String voices(String assetName) {
    return "$_assetPath/voices/$assetName";
  }
}

extension CAAsset on CleanArch {
  CleanArchAsset get assets {
    return CleanArchInjector.getInstance<CleanArchAsset>();
  }
}
