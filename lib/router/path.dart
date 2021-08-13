import 'package:equatable/equatable.dart';

class MainPath with EquatableMixin {
  final String? path;
  final String? userId;
  final bool protected;

  MainPath._({this.path, this.protected = false, this.userId});

  factory MainPath.home() => MainPath._(protected: true);

  factory MainPath.auth() => MainPath._(path: 'auth');

  factory MainPath.chat(String userId) => MainPath._(
        path: 'chat',
        protected: true,
        userId: userId,
      );

  bool get isHome => path == null && protected;
  bool get isAuth => path == 'auth' && !protected;
  bool get isChat => path == 'chat' && userId != null && protected;

  @override
  String toString() {
    if (isHome) {
      return '/';
    }
    if (isAuth) {
      return '/auth';
    }
    if (isChat) {
      return '/chat/$userId';
    }
    throw UnimplementedError();
  }

  @override
  List<Object?> get props => [path, userId, protected];
}
