import 'package:flutter/material.dart';

class Orders extends StatefulWidget {
  const Orders({super.key});

  @override
  State<Orders> createState() => _OrdersState();
}

class _OrdersState extends State<Orders> {
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Container(
      width: screenWidth,
      height: screenHeight,
      color: Colors.white,
      padding: EdgeInsets.symmetric(
        horizontal: screenWidth * 0.05,
        vertical: screenHeight * 0.02,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title Section
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Orders',
                style: TextStyle(
                  fontSize: screenWidth * 0.06,
                  fontWeight: FontWeight.bold,
                ),
              ),
              IconButton(
                onPressed: () {
                  // Handle refresh action
                },
                icon: Icon(
                  Icons.refresh,
                  size: screenWidth * 0.06,
                  color: Colors.green,
                ),
              ),
            ],
          ),

          SizedBox(height: screenHeight * 0.02),

          // Orders List
          Expanded(
            child: ListView.builder(
              itemCount: 10, // Replace with the actual number of orders
              itemBuilder: (context, index) {
                final plasticKg = (index + 1) * 2; // Example: Plastic in kg
                final coinsEarned = plasticKg * 40; // Coins calculation
                final isCollected = index % 2 == 0; // Example status logic
                final collectionDate = isCollected
                    ? "2025-01-14, 3:30 PM" // Replace with dynamic date
                    : "Pending"; // Example date for collected orders

                return Card(
                  elevation: 2,
                  margin: EdgeInsets.symmetric(vertical: screenHeight * 0.01),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(screenWidth * 0.04),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Order #${index + 1}',
                              style: TextStyle(
                                fontSize: screenWidth * 0.045,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Row(
                              children: [
                                Text(
                                  '$coinsEarned',
                                  style: TextStyle(
                                    fontSize: screenWidth * 0.045,
                                    color: Colors.green,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(width: screenWidth * 0.01),
                                Icon(
                                  Icons.monetization_on,
                                  color: Colors.amber,
                                  size: screenWidth * 0.05,
                                ),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(height: screenHeight * 0.01),
                        Text(
                          'Plastic Reported: ${plasticKg} kg',
                          style: TextStyle(
                            fontSize: screenWidth * 0.04,
                            color: Colors.black87,
                          ),
                        ),
                        SizedBox(height: screenHeight * 0.005),
                        Text(
                          'Status: ${isCollected ? "Collected" : "Not Collected"}',
                          style: TextStyle(
                            fontSize: screenWidth * 0.04,
                            color: isCollected ? Colors.green : Colors.orange,
                          ),
                        ),
                        SizedBox(height: screenHeight * 0.005),
                        Text(
                          'Collection Date: $collectionDate',
                          style: TextStyle(
                            fontSize: screenWidth * 0.04,
                            color: Colors.blueGrey,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
