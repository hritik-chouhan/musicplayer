
class Mode{
  Mode({required this.isRepeat, required this.isSingle, required this.prev});

  final bool isSingle;
  final bool isRepeat;
  final bool prev;


  Mode copyWith({bool? isSingle , bool? isRepeat, bool? prev}){
    return Mode(isRepeat: isRepeat ?? this.isRepeat, isSingle: isSingle ?? this.isSingle, prev: prev ?? this.prev);
  }


}