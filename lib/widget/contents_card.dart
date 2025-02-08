import 'package:flutter/material.dart';

class ContentsCardWidget extends StatelessWidget {
  const ContentsCardWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(10.0),
      child: Card(
        elevation: 5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
          side: BorderSide(color: Colors.blueAccent.withAlpha(100), width: 2),
        ),
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    backgroundImage: NetworkImage(
                      'https://cdn.pixabay.com/photo/2016/03/31/19/56/avatar-1295396_1280.png',
                    ),
                    radius: 20,
                  ),
                  SizedBox(width: 10),
                  Text(
                    'User',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Spacer(),
                  PopupMenuButton<int>(
                    onSelected: (item) => print('Selected: $item'),
                    iconColor: Colors.black87,
                    itemBuilder: (context) => [
                      PopupMenuItem<int>(
                        value: 0,
                        child: Text(
                          'Edit',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                        textStyle: TextStyle(color: Colors.black),
                      ),
                      PopupMenuItem<int>(
                        value: 1,
                        child: Text(
                          'Delete',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                        textStyle: TextStyle(color: Colors.black),
                      ),
                    ],
                    color: Colors.white,
                  )
                ],
              ),
              SizedBox(height: 10),
              Text(
                'Title of the Post',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 5),
              Text(
                'Content text...',
                style: TextStyle(fontSize: 16),
              ),
              Image.network(
                "https://cdn.pixabay.com/photo/2023/02/04/20/32/man-7768120_1280.jpg",
                errorBuilder: (context, error, stackTrace) => Icon(Icons.error),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
