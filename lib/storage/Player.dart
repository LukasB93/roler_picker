class Player {
  int id;
  String name;

  Player(this.id, this.name);

  Player.fromJson(Map<String, dynamic> json)
    : id = json['id'],
      name = json['name'];

  Map<String, dynamic> toJson() =>
    {
      'id': id,
      'name': name,
    };

}