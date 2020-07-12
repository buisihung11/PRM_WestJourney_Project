class Actor {
  final int id;
  final String description;
  final String imageURL;
  final String username;
  final String name;
  final String gender;
  final String phone;

  Actor(
      {this.id,
      this.description,
      this.imageURL =
          "https://i.pinimg.com/originals/9d/97/a2/9d97a28b5894f5118f5841810eacae80.png",
      this.username,
      this.name,
      this.gender,
      this.phone});
}
