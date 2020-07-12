class Equipment {
  final int id;
  String name;
  String description;
  String imageURL;
  String status;
  int quantity;

  Equipment(
      {this.id,
      this.name,
      this.description,
      this.imageURL =
          "https://images.unsplash.com/photo-1581550279519-e2b2baf70ba6?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=300&q=80",
      this.status,
      this.quantity});
}
