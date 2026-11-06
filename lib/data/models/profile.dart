/// The person using Veronica. Asked for in onboarding.
class Profile {
  const Profile({required this.name, this.onboarded = false});

  final String name;
  final bool onboarded;

  Profile copyWith({String? name, bool? onboarded}) =>
      Profile(name: name ?? this.name, onboarded: onboarded ?? this.onboarded);
}
