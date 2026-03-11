class NightlifeEvent {
  final String title;
  final String venue;
  final String price;
  final String imageUrl;

  NightlifeEvent({
    required this.title,
    required this.venue,
    required this.price,
    required this.imageUrl,
  });
}

// Sample Data for your Feed
List<NightlifeEvent> sampleEvents = [
  NightlifeEvent(
    title: "SATURDAY NIGHT FEVER",
    venue: "Elements, Masaki",
    price: "20,000",
    imageUrl:
        "https://images.unsplash.com/photo-1514525253361-bee8718a74a2?q=80&w=1000",
  ),
  NightlifeEvent(
    title: "AMAPIANO SUNDAYS",
    venue: "Warehouse, Dar",
    price: "15,000",
    imageUrl:
        "https://images.unsplash.com/photo-1516450360452-9312f5e86fc7?q=80&w=1000",
  ),
  NightlifeEvent(
    title: "KARAOKE NIGHT",
    venue: "Samaki Samaki",
    price: "Free Entry",
    imageUrl:
        "https://images.unsplash.com/photo-1470225620780-dba8ba36b745?q=80&w=1000",
  ),
];
