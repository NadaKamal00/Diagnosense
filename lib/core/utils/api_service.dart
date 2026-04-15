import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// A centralized service for managing API requests across the application.
/// USAGE: ApiService().get(...) or ApiService().post(...)
class ApiService {
  // --- Singleton Pattern ---
  static final ApiService _instance = ApiService._internal();

  factory ApiService() => _instance;

  late final Dio _dio;

  // Private constructor
  ApiService._internal() {
    _dio = Dio(
      BaseOptions(
        // baseUrl: 'https://toothlike-intermetatarsal-avah.ngrok-free.dev',
        baseUrl: 'https://nontelepathically-pamphletary-cyndi.ngrok-free.dev',
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    // Optional: Add logging interceptor for easier debugging during development
    _dio.interceptors.add(
      LogInterceptor(requestBody: true, responseBody: true),
    );
  }

  /// Generic GET request.
  Future<Response> get(
    String endpoint, {
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      final response = await _dio.get(
        endpoint,
        queryParameters: queryParameters,
        options: options,
      );
      return response;
    } on DioException catch (e) {
      if (e.response != null) return e.response!;
      rethrow;
    }
  }

  /// Generic POST request.
  Future<Response> post(
    String endpoint, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      final response = await _dio.post(
        endpoint,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
      return response;
    } on DioException catch (e) {
      if (e.response != null) return e.response!;
      rethrow;
    }
  }

  /// Generic PATCH request.
  Future<Response> patch(
    String endpoint, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      final response = await _dio.patch(
        endpoint,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
      return response;
    } on DioException catch (e) {
      if (e.response != null) return e.response!;
      rethrow;
    }
  }

  /// Handles user login.
  /// Endpoint: /api/login/patient
  Future<Map<String, dynamic>> login({
    required String identity,
    required String password,
  }) async {
    final response = await post(
      '/api/login/patient',
      data: {'identity': identity, 'password': password},
    );

    if (response.statusCode == 200 && response.data['success'] == true) {
      final prefs = await SharedPreferences.getInstance();

      // --- Save Token ---
      final token = response.data['data']?['token']?.toString() ?? "";
      if (token.isNotEmpty) {
        await prefs.setString('auth_token', token);
        print(
          "API Debug: Saved Token to SharedPreferences: ${token.substring(0, 5)}...",
        );
      }

      // --- Save User Info (Parsing 'data' -> 'user' structure) ---
      final userData = response.data['data']?['user'];
      print("API User Data: $userData");
      if (userData != null) {
        final name = userData['name']?.toString() ?? "";
        final email = userData['email']?.toString() ?? "";
        final phone = userData['phone']?.toString() ?? "";

        print(
          "API Debug: Saving to SharedPreferences -> name: $name, email: $email, phone: $phone",
        );
        await prefs.setString('user_name', name);
        await prefs.setString('user_email', email);
        await prefs.setString('user_phone', phone);
        await prefs.setString(
          'saved_user_phone',
          userData['phone']?.toString() ?? "",
        );

        final savedName = prefs.getString('user_name');
        print(
          "API Debug: Verification after save -> key: 'user_name', value in prefs: $savedName",
        );
      }
    }

    return response.data;
  }

  /// Sends an OTP to the provided identity (email/phone) for password reset.
  /// Endpoint: /api/forget-password/patient
  Future<Map<String, dynamic>> sendForgotPasswordOTP(String identity) async {
    final response = await post(
      '/api/forget-password/patient',
      data: {'identity': identity},
    );
    if (response.data is Map<String, dynamic>) {
      final data = Map<String, dynamic>.from(response.data);
      data['status_code'] = response.statusCode;
      return data;
    }
    return {
      'success': false,
      'message': 'Unknown error',
      'status_code': response.statusCode,
    };
  }

  /// Verifies the OTP for a given identity.
  /// Endpoint: /api/verify-otp/patient
  Future<Map<String, dynamic>> verifyOTP(String identity, String otp) async {
    final response = await post(
      '/api/verify-otp/patient',
      data: {'identity': identity, 'otp': otp},
    );
    return response.data;
  }

  /// Resets the password for a given token.
  /// Endpoint: /api/reset-password/patient
  Future<Map<String, dynamic>> resetPassword({
    required String token,
    required String password,
    required String passwordConfirmation,
  }) async {
    final response = await post(
      '/api/reset-password/patient',
      data: {
        'reset_token': token,
        'password': password,
        'password_confirmation': passwordConfirmation,
      },
    );
    return response.data;
  }

  /// Handles user logout.
  /// Endpoint: /api/logout/patient
  Future<Map<String, dynamic>> logout(String token) async {
    final response = await post(
      '/api/logout/patient',
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );
    return response.data;
  }

  /// Resends the OTP for the forgot-password flow.
  /// Endpoint: POST /api/forget-password/patient
  Future<Map<String, dynamic>> resendCode(String identity) async {
    final response = await post(
      '/api/forget-password/patient',
      data: {'identity': identity},
    );
    if (response.data is Map<String, dynamic>) {
      return Map<String, dynamic>.from(response.data);
    }
    return {'success': false, 'message': 'Unknown error'};
  }

  /// Resends the OTP for the signup flow using an auth token.
  /// Endpoint: GET /api/resend-otp/patient
  Future<Map<String, dynamic>> resendOTP({
    String? token,
    String? identity,
  }) async {
    String? finalToken = token;

    // Fallback: If token is missing, try to fetch from SharedPreferences
    if (finalToken == null || finalToken.isEmpty) {
      final prefs = await SharedPreferences.getInstance();
      finalToken = prefs.getString('auth_token');
      if (finalToken != null && finalToken.isNotEmpty) {
        print(
          'DEBUG: [0.5] Token retrieved from Storage fallback: ${finalToken.substring(0, 10)}...',
        );
      }
    }

    String url = '/api/resend-otp/patient';

    if (finalToken == null || finalToken.isEmpty) {
      if (identity != null && identity.isNotEmpty) {
        url = '$url?identity=$identity';
        print('DEBUG: [0.6] Still NULL, using Identity instead: $identity');
      } else {
        print('DEBUG: [ERROR] No Token AND No Identity provided to ApiService');
      }
    }

    final fullUrl = '${_dio.options.baseUrl}$url';
    final headers = {
      if (finalToken != null && finalToken.isNotEmpty)
        'Authorization': 'Bearer $finalToken',
      'Accept': 'application/json',
      'Content-Type': 'application/json',
    };

    print('DEBUG: [1] Attempting GET to: $fullUrl');
    print('DEBUG: [2] Headers: ${headers.toString()}');

    try {
      final response = await _dio.get(
        url,
        options: Options(headers: headers, validateStatus: (status) => true),
      );

      print('DEBUG: [3] Status Code: ${response.statusCode}');
      print('DEBUG: [4] Raw Body: ${response.data}');

      if (response.statusCode == 401) {
        print('DEBUG: [!] Server rejected the Token (Unauthorized).');
      } else if (response.statusCode == 419) {
        print('DEBUG: [!] CSRF or Session Timeout.');
      }

      if (response.data is Map<String, dynamic>) {
        final result = Map<String, dynamic>.from(response.data);
        result['debug_status_code'] = response.statusCode;
        return result;
      }

      return {
        'success': false,
        'message': 'Invalid server response',
        'debug_status_code': response.statusCode,
      };
    } catch (e) {
      print('DEBUG: [ERROR] Catch: $e');
      return {
        'success': false,
        'message': e.toString(),
        'debug_exception': true,
      };
    }
  }

  /// Fetches the patient's next visit data.
  /// Endpoint: GET /api/patient/next-visit
  Future<Map<String, dynamic>> getNextVisit() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');

    final response = await get(
      '/api/patient/next-visit',
      options: Options(
        headers: {if (token != null) 'Authorization': 'Bearer $token'},
      ),
    );

    if (response.data is Map<String, dynamic>) {
      return Map<String, dynamic>.from(response.data);
    }
    return {'success': false, 'message': 'Unknown error', 'data': null};
  }

  /// Fetches the patient's medical history timeline.
  /// Endpoint: GET /api/patient/timeline
  Future<Map<String, dynamic>> getPatientTimeline() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');

    try {
      final response = await get(
        '/api/patient/timeline',
        options: Options(
          headers: {if (token != null) 'Authorization': 'Bearer $token'},
        ),
      );

      if (response.data is Map<String, dynamic>) {
        return Map<String, dynamic>.from(response.data);
      }
      return {
        'success': false,
        'message': 'Invalid response format',
        'data': null,
      };
    } catch (e) {
      return {'success': false, 'message': e.toString(), 'data': null};
    }
  }

  /// Fetches the patient's tasks.
  /// Endpoint: GET /api/patient/tasks
  Future<Map<String, dynamic>> getPatientTasks() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');

    final response = await get(
      '/api/patient/tasks',
      options: Options(
        headers: {if (token != null) 'Authorization': 'Bearer $token'},
      ),
    );

    if (response.data is Map<String, dynamic>) {
      return Map<String, dynamic>.from(response.data);
    }
    return {'success': false, 'message': 'Unknown error', 'data': null};
  }

  /// Fetches details for a specific task.
  /// Endpoint: GET /api/patient/tasks/{id}
  Future<Map<String, dynamic>> getTaskDetails(int id) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');

    try {
      final response = await get(
        '/api/patient/tasks/$id',
        options: Options(
          headers: {if (token != null) 'Authorization': 'Bearer $token'},
        ),
      );

      if (response.data is Map<String, dynamic>) {
        return Map<String, dynamic>.from(response.data);
      }
      return {
        'success': false,
        'message': 'Invalid response format',
        'data': null,
      };
    } catch (e) {
      return {'success': false, 'message': e.toString(), 'data': null};
    }
  }

  /// Toggles the completion status of a specific task.
  /// Endpoint: PATCH /api/patient/tasks/{id}/complete
  Future<Map<String, dynamic>> toggleTaskStatus(int id) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');

    try {
      final response = await patch(
        '/api/patient/tasks/$id/complete',
        options: Options(
          headers: {if (token != null) 'Authorization': 'Bearer $token'},
        ),
      );

      if (response.data is Map<String, dynamic>) {
        return Map<String, dynamic>.from(response.data);
      }
      return {'success': false, 'message': 'Invalid response format'};
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }

  /// Fetches the patient's medications.
  /// Endpoint: GET /api/patient/medications
  Future<Map<String, dynamic>> getMedications() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');

    print('DEBUG: [MedicationsAPI] GET /api/patient/medications');
    print('DEBUG: [MedicationsAPI] Token: ${token?.substring(0, 5)}...');

    try {
      final response = await get(
        '/api/patient/medications',
        options: Options(
          headers: {
            if (token != null) 'Authorization': 'Bearer $token',
            'Accept': 'application/json',
            'Content-Type': 'application/json',
          },
        ),
      );

      print('DEBUG: [MedicationsAPI] Status: ${response.statusCode}');
      print('DEBUG: [MedicationsAPI] Body: ${response.data}');

      if (response.data is Map<String, dynamic>) {
        return Map<String, dynamic>.from(response.data);
      }

      return {
        'success': false,
        'message': 'Invalid response from server.',
        'data': null,
      };
    } catch (e) {
      print('DEBUG: [MedicationsAPI] CATCH: $e');
      return {'success': false, 'message': e.toString(), 'data': null};
    }
  }

  /// Updates the patient's profile information.
  /// Endpoint: PUT /api/patient/profile
  Future<Map<String, dynamic>> updateProfile({
    required String name,
    required String email,
    required String phone,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');

    print('DEBUG: [ProfileAPI] PUT /api/patient/profile');
    print('DEBUG: [ProfileAPI] Token: ${token?.substring(0, 5)}...');
    print('DEBUG: [ProfileAPI] Body: name=$name, email=$email, phone=$phone');

    try {
      final response = await _dio.put(
        '/api/patient/profile',
        data: {'name': name, 'email': email, 'phone': phone},
        options: Options(
          headers: {
            if (token != null) 'Authorization': 'Bearer $token',
            'Accept': 'application/json',
            'Content-Type': 'application/json',
          },
        ),
      );

      print('DEBUG: [ProfileAPI] Response Status: ${response.statusCode}');
      print('DEBUG: [ProfileAPI] Response Body: ${response.data}');

      if (response.data is Map<String, dynamic>) {
        final result = Map<String, dynamic>.from(response.data);
        if (result['success'] == true) {
          print(
            'DEBUG: [ProfileAPI] Success! Attempting to persist updated info...',
          );
          print(
            'DEBUG: [ProfileAPI] Data to save: name: $name, email: $email, phone: $phone',
          );

          await prefs.setString('user_name', name);
          await prefs.setString('user_email', email);
          await prefs.setString('user_phone', phone);

          final verifyName = prefs.getString('user_name');
          print(
            'DEBUG: [ProfileAPI] Verification check after setString -> user_name: $verifyName',
          );
        }
        return result;
      }

      return {'success': false, 'message': 'Invalid response from server.'};
    } on DioException catch (e) {
      print(
        'DEBUG: [ProfileAPI] DioException: ${e.response?.statusCode} | ${e.response?.data}',
      );
      if (e.response?.data is Map<String, dynamic>) {
        return Map<String, dynamic>.from(e.response!.data);
      }
      return {'success': false, 'message': e.message ?? 'Network error.'};
    } catch (e) {
      print('DEBUG: [ProfileAPI] CATCH: $e');
      return {'success': false, 'message': e.toString()};
    }
  }

  /// Fetches the patient's medical history.
  /// Endpoint: GET /api/patient/medical-history
  Future<Map<String, dynamic>> getMedicalHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');

    try {
      final response = await get(
        '/api/patient/medical-history',
        options: Options(
          headers: {if (token != null) 'Authorization': 'Bearer $token'},
        ),
      );

      if (response.data is Map<String, dynamic>) {
        final Map<String, dynamic> responseData = Map<String, dynamic>.from(
          response.data,
        );
        if (response.statusCode == 200) {
          responseData['success'] = true;
        }
        return responseData;
      }
      return {
        'success': false,
        'message': 'Invalid response format',
        'data': null,
      };
    } catch (e) {
      return {'success': false, 'message': e.toString(), 'data': null};
    }
  }

  /// Fetches the patient's lab reports.
  /// Endpoint: GET /api/patient/lab-reports
  Future<Map<String, dynamic>> getLabReports() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');

    try {
      final response = await get(
        '/api/patient/lab-reports',
        options: Options(
          headers: {if (token != null) 'Authorization': 'Bearer $token'},
        ),
      );

      if (response.data is Map<String, dynamic>) {
        return Map<String, dynamic>.from(response.data);
      }
      return {
        'success': false,
        'message': 'Invalid response format',
        'data': null,
      };
    } catch (e) {
      return {'success': false, 'message': e.toString(), 'data': null};
    }
  }

  /// Fetches the patient's radiology reports.
  /// Endpoint: GET /api/patient/radiology-reports
  Future<Map<String, dynamic>> getRadiologyReports() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');

    print('DEBUG: [RadiologyAPI] GET /api/patient/radiology-reports');
    print('DEBUG: [RadiologyAPI] Token: ${token?.substring(0, 5)}...');

    try {
      final response = await get(
        '/api/patient/radiology-reports',
        options: Options(
          headers: {
            if (token != null) 'Authorization': 'Bearer $token',
            'Accept': 'application/json',
            'Content-Type': 'application/json',
          },
        ),
      );

      print('DEBUG: [RadiologyAPI] Status: ${response.statusCode}');

      if (response.data is Map<String, dynamic>) {
        final Map<String, dynamic> responseData = Map<String, dynamic>.from(
          response.data,
        );

        // Normalize response: if the actual list is inside responseData['data']['data']
        final nestedData = responseData['data'];
        if (nestedData is Map &&
            nestedData.containsKey('data') &&
            nestedData['data'] is List) {
          print('DEBUG: [RadiologyAPI] Found nested data list. Normalizing.');
          return {
            'success': responseData['success'] ?? (response.statusCode == 200),
            'data': nestedData['data'],
            'message': responseData['message'],
          };
        }

        if (response.statusCode == 200) {
          responseData['success'] = true;
        }
        return responseData;
      }
      return {
        'success': false,
        'message': 'Invalid response format',
        'data': null,
      };
    } catch (e) {
      print('DEBUG: [RadiologyAPI] CATCH: $e');
      return {'success': false, 'message': e.toString(), 'data': null};
    }
  }

  /// Fetches the patient's notifications.
  /// Endpoint: GET /api/patient/notifications
  Future<Map<String, dynamic>> getNotifications() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');

    try {
      final response = await get(
        '/api/patient/notifications',
        options: Options(
          headers: {
            if (token != null) 'Authorization': 'Bearer $token',
            'Accept': 'application/json',
            'Content-Type': 'application/json',
          },
        ),
      );

      if (response.data is Map<String, dynamic>) {
        final Map<String, dynamic> responseData = Map<String, dynamic>.from(
          response.data,
        );
        if (response.statusCode == 200) {
          responseData['success'] = true;
        }
        return responseData;
      }
      return {
        'success': false,
        'message': 'Invalid response format',
        'data': null,
      };
    } catch (e) {
      return {'success': false, 'message': e.toString(), 'data': null};
    }
  }
}
