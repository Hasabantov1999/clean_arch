// ignore_for_file: use_string_in_part_of_directives

part of app;

class AppController extends CleanArchBaseController {
  ThemeData get getTheme {
    return CleanArch().getTheme;
  }


  void init() {}
}
