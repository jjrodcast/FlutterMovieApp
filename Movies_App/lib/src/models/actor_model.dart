class ActorResponse {
  List<Actor> casts = [];

  ActorResponse.fromJsonList(List<dynamic> jsonList) {
    if (jsonList == null) return;
    final castMap = jsonList.map((item) => Actor.fromJsonMap(item));
    casts.addAll(castMap);
  }
}

class Actor {
  int id;
  int castId;
  String name;
  bool adult;
  int gender;
  String knownForDepartment;
  double popularity;
  String profilePath;
  String character;
  String creditId;
  int order;

  Actor({
    this.id,
    this.castId,
    this.name,
    this.adult,
    this.gender,
    this.knownForDepartment,
    this.popularity,
    this.profilePath,
    this.character,
    this.creditId,
    this.order,
  });

  Actor.fromJsonMap(Map<String, dynamic> json) {
    id = json['id'];
    castId = json['cast_id'];
    name = json['name'];
    adult = json['adult'];
    gender = json['gender'];
    knownForDepartment = json['known_for_department'];
    popularity = json['popularity'];
    profilePath = json['profile_path'];
    character = json['character'];
    creditId = json['credit_id'];
    order = json['order'];
  }

  String getPhoto() {
    if (profilePath == null) {
      return 'https://i0.wp.com/medistar.com.au/wp-content/uploads/person-placeholder.jpg';
    }
    return 'https://image.tmdb.org/t/p/w500/$profilePath';
  }
}
