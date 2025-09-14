import 'package:women_diary/actions_history/action_detail/action_detail.dart';
import 'package:women_diary/actions_history/action_detail/new_action.dart';
import 'package:women_diary/actions_history/action_list/action_history.dart';
import 'package:women_diary/actions_history/action_model.dart';
import 'package:women_diary/bottom_tab_bar/bottom_tab_bar.dart';
import 'package:women_diary/chat/chat_detail.dart';
import 'package:women_diary/chat/chat_list.dart';
import 'package:women_diary/chat/component/new_thread.dart';
import 'package:women_diary/chat/model/thread_model.dart';
import 'package:women_diary/cycle/cycle_model.dart';
import 'package:women_diary/cycle/first_setup/cycle_setup.dart';
import 'package:women_diary/cycle/list/cycle_history.dart';
import 'package:women_diary/cycle/detail/cycle_calendar.dart';
import 'package:women_diary/cycle/detail/cycle_detail.dart';
import 'package:women_diary/home/home.dart';
import 'package:women_diary/routes/route_name.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:women_diary/schedule/new_schedule.dart';
import 'package:women_diary/schedule/schedule_detail.dart';
import 'package:women_diary/schedule/schedule_list.dart';
import 'package:women_diary/schedule/schedule_model.dart';
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
              path: RoutesName.cycleList,
              pageBuilder: (context, state) {
                return _createPageFadeTransition(state: state, child: CycleHistory());
              },
            ),
            GoRoute(
              parentNavigatorKey: _shellNavigatorKey,
              path: RoutesName.schedules,
              pageBuilder: (context, state) {
                return _createPageFadeTransition(state: state, child: const Schedule());
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
              path: RoutesName.chat,
              pageBuilder: (context, state) {
                return _createPageFadeTransition(state: state, child: Chat());
              },
            )
          ],
        ),
        GoRoute(
          path: RoutesName.scheduleDetail,
          pageBuilder: (context, state) {
            ScheduleModel schedule = state.extra as ScheduleModel;
            return _createPageFadeTransition(state: state, child: ScheduleDetail(schedule: schedule));
          },
        ),
        GoRoute(
          path: RoutesName.cycleCalendar,
          pageBuilder: (context, state) {
            List<CycleModel> cycleList = state.extra as List<CycleModel>;
            return _createPageFadeTransition(state: state, child: CycleCalendar());
          },
        ),
        GoRoute(
          path: RoutesName.cycleDetail,
          pageBuilder: (context, state) {
            CycleModel cycle = state.extra as CycleModel;
            return _createPageFadeTransition(state: state, child: CycleDetail(cycle: cycle));
          },
        ),
        GoRoute(
          path: RoutesName.actionDetail,
          pageBuilder: (context, state) {
            ActionModel action = state.extra as ActionModel;
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
        ),
        GoRoute(
          path: RoutesName.schedules,
          pageBuilder: (context, state) {
            return _createPageFadeTransition(state: state, child: Schedule());
          },
        ),
        GoRoute(
          path: RoutesName.scheduleDetail,
          pageBuilder: (context, state) {
            ScheduleModel schedule = state.extra as ScheduleModel;
            return _createPageFadeTransition(state: state, child: ScheduleDetail(schedule: schedule));
          },
        ),
        GoRoute(
          path: RoutesName.newSchedule,
          pageBuilder: (context, state) {
            return _createPageFadeTransition(state: state, child: NewSchedule());
          },
        ),
        GoRoute(
          path: RoutesName.chatDetail,
          pageBuilder: (context, state) {
            ThreadModel thread = state.extra as ThreadModel;
            return _createPageFadeTransition(state: state, child: ChatDetail(thread: thread));
          },
        ),
        GoRoute(
          path: RoutesName.newChat,
          pageBuilder: (context, state) {
            return _createPageFadeTransition(state: state, child: NewThread());
          },
        ),
        GoRoute(
          path: RoutesName.setting,
          pageBuilder: (context, state) {
            return _createPageFadeTransition(state: state, child: Setting());
          },
        ),
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
