enum AppRoutes {
  home,
  authGate,
  register,
  settings,
  chat,
  imageDetail,
  login;

  String get path {
    switch (this) {
      case AppRoutes.authGate:
        return '/';
      case AppRoutes.home:
        return '/home';
      case AppRoutes.chat:
        return '/chat';
      case AppRoutes.imageDetail:
        return '/imageDetail';
      case AppRoutes.register:
        return '/register';
      case AppRoutes.settings:
        return '/settings';
      case AppRoutes.login:
        return '/login';
    }
  }
}
