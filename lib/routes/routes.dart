import 'package:women_diary/actions_history/action_detail/action_detail.dart';
import 'package:women_diary/actions_history/action_list/action_history.dart';
import 'package:women_diary/actions_history/action_detail/new_action.dart';
import 'package:women_diary/actions_history/user_action_model.dart';
import 'package:women_diary/bottom_tab_bar/bottom_tab_bar.dart';
import 'package:women_diary/chat/chat_detail.dart';
import 'package:women_diary/chat/chat_list.dart';
import 'package:women_diary/chat/model/thread_model.dart';
import 'package:women_diary/cycle_setup/cycle_setup.dart';
import 'package:women_diary/home/home.dart';
import 'package:women_diary/menstruation/menstruation_calendar.dart';
import 'package:women_diary/menstruation/menstruation_detail.dart';
import 'package:women_diary/menstruation/menstruation_history.dart';
import 'package:women_diary/menstruation/menstruation_model.dart';
import 'package:women_diary/routes/route_name.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:women_diary/setting/setting.dart';

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
                return _createPageFadeTransition(state: state, child: const Home());
              },
            ),
            GoRoute(
              parentNavigatorKey: _shellNavigatorKey,
              path: RoutesName.menstruationHistory,
              pageBuilder: (context, state) {
                return _createPageFadeTransition(state: state, child: const MenstruationHistory());
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
              path: RoutesName.actionHistory,
              pageBuilder: (context, state) {
                return _createPageFadeTransition(state: state, child: ActionHistory());
              },
            ),
            GoRoute(
              parentNavigatorKey: _shellNavigatorKey,
              path: RoutesName.setting,
              pageBuilder: (context, state) {
                return _createPageFadeTransition(state: state, child: Setting());
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
        ),
        GoRoute(
          path: RoutesName.menstruationCalendar,
          pageBuilder: (context, state) {
            return _createPageFadeTransition(state: state, child: MenstruationCalendar());
          },
        ),
        GoRoute(
          path: RoutesName.menstruationDetail,
          pageBuilder: (context, state) {
            MenstruationModel menstruation = state.extra as MenstruationModel;
            return _createPageFadeTransition(state: state, child: MenstruationDetail(menstruation: menstruation));
          },
        ),
        GoRoute(
          path: RoutesName.actionDetail,
          pageBuilder: (context, state) {
            UserAction action = state.extra as UserAction;
            return _createPageFadeTransition(state: state, child: ActionDetail(action: action));
          },
        ),
        GoRoute(
          path: RoutesName.newAction,
          pageBuilder: (context, state) {
            return _createPageFadeTransition(state: state, child: NewAction());
          },
        ),
        GoRoute(
          path: RoutesName.firstCycleInformation,
          pageBuilder: (context, state) {
            return _createPageFadeTransition(state: state, child: FirstCycleSetupView());
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
