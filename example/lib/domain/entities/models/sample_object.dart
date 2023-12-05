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
  First? first;
  Second? second;

  Complicated({
    this.first,
    this.second,
  });

  factory Complicated.fromJson(Map<String, dynamic> json) {
    return Complicated(
      first: First.fromJson(json['first']),
      second: Second.fromJson(json['second']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'first': first?.toJson(),
      'second': second?.toJson(),
    };
  }
}

class First {
  String? title;
  String? description;

  First({
    this.title,
    this.description,
  });

  factory First.fromJson(Map<String, dynamic> json) {
    return First(
      title: json['title'],
      description: json['description'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
    };
  }
}

class Second {
  String? title;
  String? description;

  Second({
    this.title,
    this.description,
  });

  factory Second.fromJson(Map<String, dynamic> json) {
    return Second(
      title: json['title'],
      description: json['description'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
    };
  }
}
