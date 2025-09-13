
import 'package:openapi/openapi.dart';
import 'package:variant_dashboard/app/udaan_saarathi/core/config/api_config.dart';
import 'package:variant_dashboard/app/udaan_saarathi/features/data/repositories/auth/token_storage.dart';

class AuthRepository {
  final TokenStorage _storage;
  final AuthApi _api;

  AuthRepository({TokenStorage? storage, AuthApi? api})
      : _storage = storage ?? TokenStorage(),
        _api = api ?? ApiConfig.client().getAuthApi();

  Future<String?> getToken() => _storage.getToken();

  Future<void> logout() => _storage.clearToken();

  Future<String> registerCandidate({required String fullName, required String phone}) async {
    final req = RegisterCandidateDto(fullName: fullName,phone: phone);
    final res = await _api.authControllerRegister(registerCandidateDto: req);
    // In dev, API returns dev_otp
    return res.data?.devOtp ?? '';
  }

  Future<String> verifyCandidate({required String phone, required String otp}) async {
    final req = VerifyOtpDto(phone: phone, otp: otp);
    final res = await _api.authControllerVerify(verifyOtpDto: req);
    final token = res.data?.token ?? '';
    if (token.isNotEmpty) {
      await _storage.setToken(token);
    }
    return token;
  }

  Future<String> loginStart({required String phone}) async {
    final req = AuthControllerLoginStartRequest(phone: phone);
    final res = await _api.authControllerLoginStart(authControllerLoginStartRequest: req);
    return res.data?.devOtp ?? '';
  }

  Future<String> loginVerify({required String phone, required String otp}) async {
    final req = VerifyOtpDto(phone: phone, otp: otp);
    final res = await _api.authControllerLoginVerify(verifyOtpDto: req);
    final token = res.data?.token ?? '';
    if (token.isNotEmpty) {
      await _storage.setToken(token);
    }
    return token;
  }
}
