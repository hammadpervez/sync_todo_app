import 'package:notifications/domain/repository/firebase_repository/firebase_user_repo.dart';
import 'package:notifications/domain/services/auth_service/all_auth_builder.dart';
import 'package:notifications/export.dart';

class UserAuthService extends ChangeNotifier {
  final authBuilder = AllTypeAuthBuilder();
  String? _errorMsg, _sessionID;

  EmailLinkAuthenticationRepo? _repo;

  String? get errorMsg => this._errorMsg;

  void get _setDefault {
    _errorMsg = null;
    //_sessionID = null;
  }

  String? get sessionID {
    return Hive.box(LOGIN_BOX).get(USER_KEY);
  }

  void logOut() {
    Hive.box(LOGIN_BOX).delete(USER_KEY);
  }

  Future<bool> login() async {
    _setDefault;
    try {
      await authBuilder.login();
      return true;
    } on BaseException catch (e) {
      log("Exception $e");
      _errorMsg = e.msg;
  notifyListeners();
      return false;
    }
    
  }

  Future<bool> register(String username, String email, String password) async {
    _setDefault;
    try {
      await authBuilder.register(username, email, password);
      return true;
    } on BaseException catch (e) {
      log("Exception $e");
      _errorMsg = e.msg;
      notifyListeners();
      return false;
    }
  }

  Future<bool> signIn(String userID, String password) async {
    _setDefault;
    try {
      await authBuilder.signIn(userID, password);
      return true;
    } on BaseException catch (e) {
      log("Exception ${e.msg}");
      _errorMsg = e.msg;
      notifyListeners();
    }
    return false;
  }

  void loginWithEmail(String email) async {
    _setDefault;
    try {
      _repo = await authBuilder.loginWithEmail(email);
      _repo!.onLinkListener(
        onSuccess: _onSuccess,
        onError: _onError,
      );
    } on BaseException catch (e) {
      log("Exception ${e.msg}");
      _errorMsg = e.msg;
    }
    notifyListeners();
  }

  Future<bool> _onSuccess(PendingDynamicLinkData? linkData) async {
    _setDefault;
    try {
      log("OnLinkAuthenticate");
      await _repo!.onLinkAuthenticate(linkData);
      return true;
    } on BaseException catch (e) {
      log("Error onSucess: $e");
      _errorMsg = e.msg;
      notifyListeners();
    }
    return false;
  }

  Future<dynamic> _onError(OnLinkErrorException? error) async {
    log("Error $error in Link");
  }

  Future<void> tryTo(Function callback) async {
    try {
      await callback();
    } on BaseException catch (e) {
      _errorMsg = e.msg;
    }
  }
}