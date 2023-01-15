class Person {
  int? id;
  String name;
  String city;

  Person({this.id, required this.name, required this.city});

  Map<String, dynamic> toMap() => {"id": id, "name": name, "city": city};

  factory Person.fromMap(Map<String, dynamic> map) =>
      Person(id: map['id'], name: map['name'], city: map['city']);
}
