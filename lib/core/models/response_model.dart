class ResponseModel<T> {
  final T? data;

  const ResponseModel({
    this.data,
  });

  factory ResponseModel.fromJson(T? json) => ResponseModel(
      data: json,
    );
}
