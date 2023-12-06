class BaseResponse {
  int? code;
  String? message;
  dynamic data;
  bool? isSuccess;

  BaseResponse({
    this.code,
    this.message,
    this.data,
    this.isSuccess,
  });

  factory BaseResponse.fromJson(Map<String, dynamic> json) {
    return BaseResponse(
      code: json['code'],
      message: json['message'],
      data: json['data'],
      isSuccess: json['isSuccess'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'code': code,
      'message': message,
      'data': data,
      'isSuccess': isSuccess,
    };
  }
}
