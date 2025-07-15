import 'package:women_diary/bottom_tab_bar/bottom_tab_bar.dart';
import 'package:women_diary/chat/chat_detail.dart';
import 'package:women_diary/chat/chat_list.dart';
import 'package:women_diary/chat/model/thread_model.dart';
import 'package:women_diary/diary/diary_list.dart';
import 'package:women_diary/home/home.dart';
import 'package:women_diary/knowledge/knowledge.dart';
import 'package:women_diary/main.dart';
import 'package:women_diary/music/music.dart';
import 'package:women_diary/routes/route_name.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class Routes {
  static const GlobalObjectKey<NavigatorState> _rootNavigatorKey = GlobalObjectKey<NavigatorState>('root');
  static const GlobalObjectKey<NavigatorState> _shellNavigatorKey = GlobalObjectKey<NavigatorState>('shell');

  static GlobalKey<NavigatorState> get navigatorKey => _rootNavigatorKey;

  static Future<dynamic> navigateToWithoutDuplicate(String routeName, {dynamic arguments}) async {
    if (navigatorKey.currentState?.currentRouteName == routeName) {
      return null;
    }
    return navigatorKey.currentContext?.push(routeName, extra: arguments);
  }

  static GoRouter? router;

  static GoRouter generateRouter(String init) {
    router ??= _generateRouter(init);
    return router!;
  }

  static GoRouter _generateRouter(String init) {
    return GoRouter(
      navigatorKey: navigatorKey,
      initialLocation: init,
      observers: [WomenDiary.observer],
      routes: [
        ShellRoute(
          navigatorKey: _shellNavigatorKey,
          builder: (BuildContext context, GoRouterState state, Widget child) {
            return MainBottomTabBar(child: child);
          },
          routes: [
            GoRoute(
              parentNavigatorKey: _shellNavigatorKey,
              path: RoutesName.home,
              pageBuilder: (context, state) {
                return _createPageFadeTransition(state: state, child: const HomePage());
              },
            ),
            GoRoute(
              parentNavigatorKey: _shellNavigatorKey,
              path: RoutesName.period,
              pageBuilder: (context, state) {
                return _createPageFadeTransition(state: state, child: const DiaryList());
              },
            ),
            GoRoute(
              parentNavigatorKey: _shellNavigatorKey,
              path: RoutesName.chat,
              pageBuilder: (context, state) {
                return _createPageFadeTransition(state: state, child: const Chat());
              },
            ),
            GoRoute(
              parentNavigatorKey: _shellNavigatorKey,
              path: RoutesName.diaries,
              pageBuilder: (context, state) {
                return _createPageFadeTransition(state: state, child: const DiaryList());
              },
            ),
            GoRoute(
              parentNavigatorKey: _shellNavigatorKey,
              path: RoutesName.knowledge,
              pageBuilder: (context, state) {
                return _createPageFadeTransition(state: state, child: Knowledge());
              },
            ),
          ],
        ),
        GoRoute(
          path: RoutesName.diaryDetail,
          pageBuilder: (context, state) {
            ThreadModel thread = state.extra as ThreadModel;
            return _createPageFadeTransition(state: state, child: ChatDetail(thread: thread));
          },
        )
      ],
    );
  }

  static CustomTransitionPage _createPageFadeTransition({required GoRouterState state, required Widget child}) {
    return CustomTransitionPage<void>(
      key: state.pageKey,
      child: child,
      transitionDuration: const Duration(milliseconds: 0),
      reverseTransitionDuration: const Duration(milliseconds: 0),
      transitionsBuilder: (
          BuildContext context,
          Animation<double> animation,
          Animation<double> secondaryAnimation,
          Widget child,
          ) {
        return FadeTransition(
          opacity: CurveTween(curve: Curves.easeInOut).animate(animation),
          child: child,
        );
      },
    );
  }
}

extension NavigatorStateX on NavigatorState {
  String? get currentRouteName {
    String? currentPath;
    popUntil((route) {
      currentPath = route.settings.name;
      return true;
    });
    return currentPath;
  }
}

extension NavigatorContext on BuildContext {
  Future<dynamic> navigateTo(String routeName, {Object? arguments}) async {
    return push(routeName, extra: arguments);
  }

  Future<dynamic> goTo(String routeName, {Object? arguments}) async {
    return go(routeName, extra: arguments);
  }

  void popUntilPath(String routePath, {Object? result}) {
    final router = GoRouter.of(this);
    while (router.routerDelegate.currentConfiguration.matches.last.matchedLocation != routePath) {
      if (!router.canPop()) {
        return;
      }
      router.pop(result);
    }
  }
}
