class WordModel {
  final String eng, kor;
  final int id, day;
  final bool isDone;

  const WordModel({
    required this.eng,
    required this.kor,
    required this.id,
    required this.day,
    required this.isDone,
  });

  WordModel.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        day = json['day'],
        eng = json['eng'],
        kor = json['kor'],
        isDone = json['done'];
}
