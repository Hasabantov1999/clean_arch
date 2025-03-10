import 'package:clean_arch/clean_arch.dart';

import 'package:flutter/material.dart';

void main() => CleanArchApp.build(
      config: ".env",
      sentryOptions: null,
      oriantationModes: null,
      firebase: null,
      sentryNavigatorObserver: false,
      performanceNavigatorObserver: false,
      serviceLog: null,
      adaptiveCacheTheme: true,
      themes: [
        CleanArchTheme(
          themeName: "dark",
          palette: ThemeData.dark(),
        ),
        CleanArchTheme(
          themeName: "light",
          palette: ThemeData.light(),
        ),
      ],
      initialTheme: "",
      home: CleanArchRoute(
        mobile: Home(),
        path: "home",
      ),
      mainLocale: CleanArchLocale(
        locale: "tr",
      ),
    );

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CleanArchText(
            "Dil: Türkçe",
          ),
          TextButton(
            onPressed: () {
              CleanArch().changeLocale(
                CleanArchLocale(locale: "tr"),
              );
            },
            child: Text("Türkçe"),
          ),
          TextButton(
            onPressed: () {
           
              CleanArch().changeLocale(
                CleanArchLocale(locale: "en"),
              );
            },
            child: Text("İngilizce"),
          ),
          TextButton(
            onPressed: () {
              CleanArch().changeTheme("dark");
            },
            child: Text(
              "Dark Theme",
            ),
          ),
          TextButton(
            onPressed: () {
              CleanArch().changeTheme("light");
            },
            child: Text("Light Theme"),
          ),
        ],
      ),
    );
  }
}
