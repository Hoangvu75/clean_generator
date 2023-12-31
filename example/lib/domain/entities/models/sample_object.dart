class SampleObject {
  String? greeting;
  List? instructions;
  Complicated? complicated;

  SampleObject({
    this.greeting,
    this.instructions,
    this.complicated,
  });

  factory SampleObject.fromJson(Map<String, dynamic> json) {
    return SampleObject(
      greeting: json['greeting'],
      instructions: json['instructions'],
      complicated: Complicated.fromJson(json['complicated']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'greeting': greeting,
      'instructions': instructions,
      'complicated': complicated?.toJson(),
    };
  }
}

class Complicated {
  int? first;
  int? second;

  Complicated({
    this.first,
    this.second,
  });

  factory Complicated.fromJson(Map<String, dynamic> json) {
    return Complicated(
      first: json['first'],
      second: json['second'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'first': first,
      'second': second,
    };
  }
}
