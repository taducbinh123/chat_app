import 'package:get/get.dart';
import 'package:hello_world_flutter/features/authentication/authentication.dart';
import 'package:hello_world_flutter/model/models.dart';
import 'package:hello_world_flutter/provider/user_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthenticationController extends GetxController {
  final AuthenticationService _authenticationService;
  final UserProvider userProvider = UserProvider();
  final _authenticationStateStream = AuthenticationState().obs;

  AuthenticationState get state => _authenticationStateStream.value;

  AuthenticationController(this._authenticationService);
  // var flag = false.obs;
  @override
  void onInit() {
    _getAuthenticatedUser();
    super.onInit();
  }

  Future<void> signIn(String username, String password) async {
    final user = await _authenticationService.signInWithUsernameAndPassword(
        username, password);
    _authenticationStateStream.value = Authenticated(user: user);
    // flag.value = false;
  }

  void signOut() async {
    await _authenticationService.signOut();
    // flag.value = true;
    _authenticationStateStream.value = UnAuthenticated();
    _authenticationStateStream.refresh();
    // Get.offAll(LoginPage());
  }

  void _getAuthenticatedUser() async {
    _authenticationStateStream.value = AuthenticationLoading();

    // final user = await _authenticationService.getCurrentUser();

    SharedPreferences prefs = await SharedPreferences.getInstance();

    final String? accessToken = prefs.getString('access_token');
    if (accessToken == null) {
      _authenticationStateStream.value = UnAuthenticated();
    } else {
      String? expires_in = prefs.getString('expires_in');
      DateTime dateTime = DateTime.parse(expires_in!);

      DateTime timeCompare = DateTime.now().add(new Duration(days:0, hours : 0,minutes:10, seconds:0, milliseconds : 0));

      if(timeCompare.compareTo(dateTime) < 0) {

        String? username = prefs.getString("username");

        _authenticationStateStream.value =
            Authenticated(user: new User(name: username!, email: ""));
      }else{
        _authenticationStateStream.value = UnAuthenticated();
      }
    }
  }
}
