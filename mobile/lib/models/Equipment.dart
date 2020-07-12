class Equipment {
  final String name;
  final String description;
  final String imageURL;
  final String status;
  final int quantity;

  Equipment(
      {this.name,
      this.description,
      this.imageURL =
          "https://images.unsplash.com/photo-1581550279519-e2b2baf70ba6?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=300&q=80",
      this.status,
      this.quantity});
}
