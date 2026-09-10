class UserAkun {
  final String username;
  final String password;
  final String fullName;

  const UserAkun({
    required this.username,
    required this.password,
    required this.fullName,
  });
}

const List<UserAkun> groupData = [
  UserAkun(username: 'Angga', password: '124240065', fullName: "Angga Baradyan"),
  UserAkun(username: 'Faris', password: '124240139', fullName: "Muhammad Faris Rafi'uddin"),
  UserAkun(username: 'Krisna', password: '124240154', fullName: "Krisna Mus'ad Zein"),
  UserAkun(username: 'Robi', password: '124240155', fullName: "Robihul Ihsan Lavano"),
];
