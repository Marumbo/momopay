class User {
  final String id;
  final String email;

  User(this.id, this.email);

  Map<String, dynamic> toMap() {
    return {'id': id, 'email': email};
  }

  User.fromFirestore(Map<String, dynamic> firestore)
      : id = firestore['id'],
        email = firestore['email'];
}
