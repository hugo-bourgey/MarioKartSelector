class Course {
  final String nom;
  final String coupe;
  int selectionCount;
  DateTime? lastSelected;
  bool isActive;

  Course({
    required this.nom,
    required this.coupe,
    this.selectionCount = 0,
    this.lastSelected,
    this.isActive = true,
  });

  // Méthodes pour la sérialisation JSON
  factory Course.fromJson(Map<String, dynamic> json) {
    return Course(
      nom: json['nom'],
      coupe: json['coupe'],
      selectionCount: json['selectionCount'] ?? 0,
      lastSelected: json['lastSelected'] != null
          ? DateTime.parse(json['lastSelected'])
          : null,
      isActive: json['isActive'] ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'nom': nom,
      'coupe': coupe,
      'selectionCount': selectionCount,
      'lastSelected': lastSelected?.toIso8601String(),
      'isActive': isActive,
    };
  }
}
