// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class Datas {
  final String name;
  final int age;
  Datas({
    required this.name,
    required this.age,
  });

  Datas copyWith({
    String? name,
    int? age,
  }) {
    return Datas(
      name: name ?? this.name,
      age: age ?? this.age,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'age': age,
    };
  }

  factory Datas.fromMap(Map<String, dynamic> map) {
    return Datas(
      name: map['name'] as String,
      age: map['age'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory Datas.fromJson(String source) =>
      Datas.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'Datas(name: $name, age: $age)';

  @override
  bool operator ==(covariant Datas other) {
    if (identical(this, other)) return true;

    return other.name == name && other.age == age;
  }

  @override
  int get hashCode => name.hashCode ^ age.hashCode;
}
