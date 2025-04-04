import "package:flutter/material.dart";

class MenuButton extends StatelessWidget {
  final IconData icon;
  final String primaryText;
  final String secondaryText;
  final Function()? onPressed;

  const MenuButton({
    super.key,
    required this.icon,
    required this.primaryText,
    required this.secondaryText,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5.0),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.grey.shade400,
          borderRadius: BorderRadius.circular(5.0),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20.0),
              child: Row(
                children: [
                  Icon(
                    icon,
                    size: 35,
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Text(
                    primaryText,
                    style: const TextStyle(
                        fontSize: 16.0, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: onPressed,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey.shade200,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(0)),
                  ),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      secondaryText,
                      style: TextStyle(
                          fontSize: 15.0, color: Colors.grey.shade800),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            )
          ],
        ),
      ),
    );
  }
}
