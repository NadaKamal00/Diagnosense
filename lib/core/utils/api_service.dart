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
        // baseUrl: 'https://nontelepathically-pamphletary-cyndi.ngrok-free.dev',
        // baseUrl: 'https://unallegedly-wrinkly-claribel.ngrok-free.dev',
        baseUrl: 'https://diagnosense-production-5a2d.up.railway.app',
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

/// ----------------------------- AUTH -----------------------------
  /// Handles user login.
  /// Endpoint: POST /api/v1/auth/login/{type}
  Future<Map<String, dynamic>> login({
    required String type,
    required String contact,
    required String password,
  }) async {
    final response = await post(
      '/api/v1/auth/login/$type',
      data: {'contact': contact, 'password': password},
    );

    // Guard: ensure response body is a Map before any field access
    if (response.data is! Map) {
      return {'success': false, 'message': 'Unexpected server response format.'};
    }

    final Map<String, dynamic> responseMap =
        Map<String, dynamic>.from(response.data as Map);

    if (response.statusCode == 200 && responseMap['success'] == true) {
      final prefs = await SharedPreferences.getInstance();

      // --- Safe extraction of nested 'data' map ---
      final dynamic rawData = responseMap['data'];
      final Map<String, dynamic>? dataMap =
          rawData is Map ? Map<String, dynamic>.from(rawData) : null;

      // --- Save Token ---
      final String token = dataMap?['token']?.toString() ?? '';
      if (token.isNotEmpty) {
        await prefs.setString('auth_token', token);
        // Guard substring to avoid RangeError if token is very short
        final preview = token.length >= 5 ? token.substring(0, 5) : token;
        print('API Debug: Saved Token to SharedPreferences: $preview...');
      }

      // --- Save User Info (Parsing 'data' -> 'user' structure) ---
      final dynamic rawUser = dataMap?['user'];
      final Map<String, dynamic>? userData =
          rawUser is Map ? Map<String, dynamic>.from(rawUser) : null;
      print('API User Data: $userData');

      if (userData != null) {
        final String name = userData['name']?.toString() ?? '';
        final String userContact = userData['contact']?.toString() ?? '';

        print(
          'API Debug: Saving to SharedPreferences -> name: $name, contact: $userContact',
        );
        await prefs.setString('user_name', name);
        await prefs.setString('user_contact', userContact);

        // Fallback: always populate both legacy keys so screens relying on
        // either 'user_email' or 'user_phone' never receive a null/empty value.
        await prefs.setString('user_email', userContact);
        await prefs.setString('user_phone', userContact);
        await prefs.setString('saved_user_phone', userContact);

        final String? savedName = prefs.getString('user_name');
        print(
          'API Debug: Verification after save -> key: user_name, value in prefs: $savedName',
        );
      }
    }

    return responseMap;
  }


  /// Sends an OTP to the provided contact (email/phone) for password reset.
  /// Endpoint: /api/v1/auth/forget-password/$type
  Future<Map<String, dynamic>> sendForgotPasswordOTP(String type, String contact) async {
    final response = await post(
      '/api/v1/auth/forget-password/$type',
      data: {'contact': contact},
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

  /// Verifies the OTP for a given contact and user type.
  /// Endpoint: /api/v1/auth/verify-otp/{type}
  Future<Map<String, dynamic>> verifyOTP({
    required String type,
    required String contact,
    required String otp,
  }) async {
    final response = await post(
      '/api/v1/auth/verify-otp/$type',
      data: {
        'contact': contact,
        'otp': otp,
      },
    );
    if (response.data is Map) {
      return Map<String, dynamic>.from(response.data as Map);
    }
    return {'success': false, 'message': 'Unexpected server response format.'};
  }

  /// Resets the password for a given token and user type.
  /// Endpoint: /api/v1/auth/reset-password/{type}
  Future<Map<String, dynamic>> resetPassword({
    required String type,
    required String token,
    required String password,
    required String passwordConfirmation,
  }) async {
    final response = await post(
      '/api/v1/auth/reset-password/$type',
      options: Options(
        headers: {
          'Authorization': 'Bearer $token',
        },
      ),
      data: {
        'password': password,
        'password_confirmation': passwordConfirmation,
      },
    );
    if (response.data is Map) {
      return Map<String, dynamic>.from(response.data as Map);
    }
    return {'success': false, 'message': 'Unexpected server response format.'};
  }

  /// Handles user logout.
  /// Endpoint: POST /api/v1/auth/logout/{type}
  Future<Map<String, dynamic>> logout({
    required String token,
    required String type,
  }) async {
    final response = await post(
      '/api/v1/auth/logout/$type',
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );
    if (response.data is Map) {
      return Map<String, dynamic>.from(response.data as Map);
    }
    return {'success': false, 'message': 'Unexpected server response format.'};
  }

  /// Resends the OTP for the forgot-password flow.
  /// Endpoint: POST /api/v1/auth/forget-password/patient
  Future<Map<String, dynamic>> resendCode(String identity) async {
    return sendForgotPasswordOTP('patient', identity);
  }

  /// Resends the OTP for the signup flow using an auth token or contact.
  /// Endpoint: GET /api/v1/auth/resend-otp/{type}
  Future<Map<String, dynamic>> resendOTP({
    required String type,
    required String contact,
    String? token,
  }) async {
    String? finalToken = token;

    // Fallback: If token is missing, try to fetch from SharedPreferences
    if (finalToken == null || finalToken.isEmpty) {
      final prefs = await SharedPreferences.getInstance();
      finalToken = prefs.getString('auth_token');
      if (finalToken != null && finalToken.isNotEmpty) {
        final preview = finalToken.length >= 10 ? finalToken.substring(0, 10) : finalToken;
        print('DEBUG: [0.5] Token retrieved from Storage fallback: $preview...');
      }
    }

    String url = '/api/v1/auth/resend-otp/$type';

    if (finalToken == null || finalToken.isEmpty) {
      url = '$url?contact=$contact';
      print('DEBUG: [0.6] Still NULL, using contact instead: $contact');
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


// ------------------------------- PATIENT ------------------------------- 

  /// Fetches the patient's next visit data.
  /// Endpoint: GET /api/patient/next-visit
  Future<Map<String, dynamic>> getNextVisit() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');

    try {
      final response = await get(
        '/api/v1/next-visit',
        options: Options(
          headers: {if (token != null) 'Authorization': 'Bearer $token'},
        ),
      );

      if (response.data is Map) {
        return Map<String, dynamic>.from(response.data as Map);
      }
      return {'success': false, 'message': 'Unknown error', 'data': null};
    } catch (e) {
      return {'success': false, 'message': e.toString(), 'data': null};
    }
  }

  /// Fetches the patient's medical history timeline.
  /// Endpoint: GET /api/v1/timeline
  Future<Map<String, dynamic>> getPatientTimeline() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');

    try {
      final response = await get(
        '/api/v1/timeline',
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

    try {
      final response = await get(
        '/api/patient/tasks',
        options: Options(
          headers: {if (token != null) 'Authorization': 'Bearer $token'},
        ),
      );

      if (response.data is Map) {
        return Map<String, dynamic>.from(response.data as Map);
      }
      return {'success': false, 'message': 'Unknown error', 'data': null};
    } catch (e) {
      return {'success': false, 'message': e.toString(), 'data': null};
    }
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

    print('DEBUG: [MedicationsAPI] GET /api/v1/medications');
    final _medTokenPreview = (token != null && token.length >= 5) ? token.substring(0, 5) : (token ?? 'null');
    print('DEBUG: [MedicationsAPI] Token: $_medTokenPreview...');

    try {
      final response = await get(
        '/api/v1/medications',
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
    final _profTokenPreview = (token != null && token.length >= 5) ? token.substring(0, 5) : (token ?? 'null');
    print('DEBUG: [ProfileAPI] Token: $_profTokenPreview...');
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
    final _radTokenPreview = (token != null && token.length >= 5) ? token.substring(0, 5) : (token ?? 'null');
    print('DEBUG: [RadiologyAPI] Token: $_radTokenPreview...');

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
