class DoctorItem {
  final String name;
  final String specialty;
  final String experience;
  final String imageUrl;

  const DoctorItem({
    required this.name,
    required this.specialty,
    required this.experience,
    required this.imageUrl,
  });
}

class DoctorData {
  static const List<DoctorItem> doctors = [
    DoctorItem(
      name: 'Dr. Jonathan',
      specialty: 'Mental Health',
      experience: '10+ Years',
      imageUrl:
          'https://images.unsplash.com/photo-1612349317150-e413f6a5b16d?w=200&q=80',
    ),
    DoctorItem(
      name: 'Dr. Aliya',
      specialty: 'Mental Health',
      experience: '8+ Years',
      imageUrl:
          'https://images.unsplash.com/photo-1559839734-2b71ea197ec2?w=200&q=80',
    ),
    DoctorItem(
      name: 'Dr. Sebastian',
      specialty: 'Psychiatry',
      experience: '12+ Years',
      imageUrl:
          'https://images.unsplash.com/photo-1537368910025-700350fe46c7?w=200&q=80',
    ),
  ];
}
