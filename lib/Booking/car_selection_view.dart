import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/conic_border_painter.dart';

class CarSelectionView extends StatefulWidget {
  final double sheetPosition;
  final Function(CarOption) onCarSelected;

  const CarSelectionView({
    super.key,
    required this.sheetPosition,
    required this.onCarSelected,
  });

  @override
  State<CarSelectionView> createState() => _CarSelectionViewState();
}

class _CarSelectionViewState extends State<CarSelectionView> {
  String _selectedCarName = "Riden SUV"; // Default selection

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          _buildCarCategoryContainer(
            title: "Standard Cars",
            icon: Icons.directions_car_filled,
            optionsCount: 3,
            cars: [
              CarOption(
                name: "Riden Standard",
                image: "assets/images/standard_car.png",
                time: "4 min",
                price: "C\$ 70.00",
                description: "Sedan with AC",
              ),
              CarOption(
                name: "Riden SUV",
                image: "assets/images/suv_car.png",
                time: "4 min",
                price: "C\$ 70.00",
                description: "SUV with AC",
              ),
              CarOption(
                name: "Riden Van",
                image: "assets/images/van_car.png",
                time: "4 min",
                price: "C\$ 70.00",
                description: "Van with AC",
              ),
            ],
          ),
          if (widget.sheetPosition > 0.6) ...[
            const SizedBox(height: 16),
            _buildCarCategoryContainer(
              title: "Premium Cars",
              icon: Icons.stars_rounded,
              optionsCount: 2,
              cars: [
                CarOption(
                  name: "Riden Premium",
                  image: "assets/images/premium_car.png",
                  time: "4 min",
                  price: "C\$ 70.00",
                  description: "Sedan with AC",
                ),
                CarOption(
                  name: "Riden SUV Premium",
                  image: "assets/images/suv_car.png",
                  time: "4 min",
                  price: "C\$ 70.00",
                  description: "SUV with AC",
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildCarCategoryContainer(
              title: "Handicapped Cars",
              icon: Icons.accessible_rounded,
              optionsCount: 1,
              cars: [
                CarOption(
                  name: "Riden Wheel Chair",
                  image: "assets/images/wheelchair_car.png",
                  time: "4 min",
                  price: "C\$ 70.00",
                  description: "Sedan with AC",
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildCarCategoryContainer({
    required String title,
    required IconData icon,
    required int optionsCount,
    required List<CarOption> cars,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(25),
        border: Border.all(color: Colors.white.withOpacity(0.15), width: 1),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(icon, color: Colors.white, size: 18),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const Spacer(),
                Text(
                  "$optionsCount Options",
                  style: GoogleFonts.poppins(
                    color: Colors.white70,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          const Divider(color: Colors.white10, height: 1),
          ...cars.map((car) => _buildCarItem(car)),
          const SizedBox(height: 10),
        ],
      ),
    );
  }

  Widget _buildCarItem(CarOption car) {
    final bool isSelected = _selectedCarName == car.name;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedCarName = car.name;
        });
        widget.onCarSelected(car);
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(18),
        ),
        child: Row(
          children: [
            Image.asset(
              car.image,
              width: 70,
              height: 45,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) => Icon(
                Icons.car_repair,
                color: isSelected ? Colors.black54 : Colors.white54,
                size: 40,
              ),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    car.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.poppins(
                      color: isSelected ? Colors.black : Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Row(
                    children: [
                      Icon(
                        Icons.access_time,
                        color: isSelected ? Colors.black54 : Colors.white54,
                        size: 12,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        car.time,
                        style: GoogleFonts.poppins(
                          color: isSelected ? Colors.black54 : Colors.white54,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                  Text(
                    car.description,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.poppins(
                      color: isSelected ? Colors.black45 : Colors.white38,
                      fontSize: 10,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Text(
              car.price,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.poppins(
                color: isSelected ? Colors.black : Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CarOption {
  final String name;
  final String image;
  final String time;
  final String price;
  final String description;

  CarOption({
    required this.name,
    required this.image,
    required this.time,
    required this.price,
    required this.description,
  });
}
