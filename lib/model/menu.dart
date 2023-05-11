import 'package:rentmate_flutter_app/auth_page.dart';
import 'package:rentmate_flutter_app/entry_pages/Entry_flats.dart';
import 'package:rentmate_flutter_app/entry_pages/Entry_groups.dart';
import 'package:rentmate_flutter_app/Entry_login.dart';
import 'package:rentmate_flutter_app/entry_pages/Entry_my_flats_and_groups.dart';
import 'package:rentmate_flutter_app/entry_pages/entry_point.dart';
import 'package:rentmate_flutter_app/home_page.dart';
import 'package:rentmate_flutter_app/login_page.dart';

import 'rive_model.dart';

class Menu {
  final String title;
  final RiveModel rive;
  final redirectPage;

  Menu({required this.title, required this.rive, required  this.redirectPage,});
}



List<Menu> sidebarMenus = [
  Menu(
    title: "Головна",
    redirectPage: AuthPage(),
    rive: RiveModel(
        src: "assets/RiveAssets/icons.riv",
        artboard: "HOME",
        stateMachineName: "HOME_interactivity"),
  ),
  Menu(
    title: "Профіль",
    redirectPage: LoginPage(),
    rive: RiveModel(
        src: "assets/RiveAssets/icons.riv",
        artboard: "USER",
        stateMachineName: "USER_Interactivity"),
  ),
  Menu(
    title: "Сповіщення",
    redirectPage: AuthPage(),
    rive: RiveModel(
        src: "assets/RiveAssets/icons.riv",
        artboard: "BELL",
        stateMachineName: "BELL_Interactivity"),
  ),
  Menu(
    title: "Вийти",
    redirectPage: AuthPage(),
    rive: RiveModel(
        src: "assets/RiveAssets/icons.riv",
        artboard: "EXIT",
        stateMachineName: "state_machine"),
  )
];

List<Menu> bottomNavItems = [
  Menu(
    title: "Home",
    redirectPage: AuthPage(),
    rive: RiveModel(
        src: "assets/RiveAssets/icons.riv",
        artboard: "HOME",
        stateMachineName: "HOME_interactivity"),
  ),
  Menu(
    title: "Flats",
    redirectPage: EntryFlats(),
    rive: RiveModel(
        src: "assets/RiveAssets/icons.riv",
        artboard: "SEARCH",
        stateMachineName: "SEARCH_Interactivity"),
  ),
  Menu(
    title: "Groups",
    redirectPage: EntryGroup(),
    rive: RiveModel(
        src: "assets/RiveAssets/icons.riv",
        artboard: "DASHBOARD",
        stateMachineName: "DASHBOARD_Interactivity"),
  ),
  Menu(
    title: "MyRents",
    redirectPage: EntryMyRents(),
    rive: RiveModel(
        src: "assets/RiveAssets/icons.riv",
        artboard: "MENU",
        stateMachineName: "MENU_Interactivity"),
  ),
  Menu(
    title: "Profile",
    redirectPage: AuthPage(),
    rive: RiveModel(
        src: "assets/RiveAssets/icons.riv",
        artboard: "USER",
        stateMachineName: "USER_Interactivity"),
  ),
];
