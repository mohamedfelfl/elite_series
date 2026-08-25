import 'package:auto_route/auto_route.dart';
import 'app_router.gr.dart';

@AutoRouterConfig(replaceInRouteName: 'Screen|Page,Route')
class AppRouter extends RootStackRouter {
  @override
  RouteType get defaultRouteType => const RouteType.adaptive();

  @override
  List<AutoRoute> get routes => [
    AutoRoute(page: LoginRoute.page, initial: true),
    AutoRoute(page: SetupWizardRoute.page),
    AutoRoute(
      path: '/',
      page: ShellRoute.page,
      children: [
        AutoRoute(path: '', page: DashboardRoute.page, initial: true),
        AutoRoute(page: AdminPanelRoute.page),
        AutoRoute(page: StudentListRoute.page),
        AutoRoute(page: GroupListRoute.page),
        AutoRoute(page: PaymentListRoute.page),
        AutoRoute(page: QrScannerRoute.page),
        AutoRoute(page: QrCardGeneratorRoute.page),
        AutoRoute(page: ExamListRoute.page),
        AutoRoute(page: HonoredStudentsRoute.page),
        AutoRoute(page: ReportRoute.page),
        AutoRoute(page: AssistantListRoute.page),
        AutoRoute(page: NotesRoute.page),
        AutoRoute(page: SettingsRoute.page),
      ],
    ),
    AutoRoute(page: UserFormRoute.page),
    AutoRoute(page: StudentFormRoute.page),
    AutoRoute(page: StudentDetailRoute.page),
    AutoRoute(page: GroupFormRoute.page),
    AutoRoute(page: PaymentFormRoute.page),
    AutoRoute(page: ExamsManagementRoute.page),
    AutoRoute(page: ExamFormRoute.page),
    AutoRoute(page: ExamDetailRoute.page),
    AutoRoute(page: MarkEntryRoute.page),
    AutoRoute(page: AssistantFormRoute.page),
    AutoRoute(page: AssistantDetailRoute.page),
  ];

  @override
  List<AutoRouteGuard> get guards => [];
}
