class Actor {
  final int id;
  String description;
  String imageURL;
  String username;
  String name;
  String gender;
  String phone;
  String password;
  Actor(
      {this.password = "123456",
      this.id,
      this.description,
      this.imageURL =
          "https://i.pinimg.com/originals/9d/97/a2/9d97a28b5894f5118f5841810eacae80.png",
      this.username,
      this.name,
      this.gender,
      this.phone});
}
