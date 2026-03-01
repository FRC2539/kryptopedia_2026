class TBAWLTRecord {
  TBAWLTRecord({required this.losses, required this.wins, required this.ties});

  final int losses;
  final int wins;
  final int ties;

  factory TBAWLTRecord.fromJson(Map<String, dynamic> data) {
    final losses = data["losses"] as int;
    final wins = data["wins"] as int;
    final ties = data["ties"] as int;
    return TBAWLTRecord(losses: losses, wins: wins, ties: ties);
  }
}
