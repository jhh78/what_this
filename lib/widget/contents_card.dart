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
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(color: Colors.black),
                  ),
                  Spacer(),
                  PopupMenuButton<int>(
                    onSelected: (item) => print('Selected: $item'),
                    iconColor: Colors.black87,
                    itemBuilder: (context) => [
                      PopupMenuItem<int>(
                        value: 0,
                        child: Text(
                          '違反を報告',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.black),
                        ),
                        textStyle: TextStyle(color: Colors.black),
                      ),
                      PopupMenuItem<int>(
                        value: 1,
                        child: Text(
                          '削除',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.black),
                        ),
                        textStyle: TextStyle(color: Colors.black),
                      ),
                      PopupMenuItem<int>(
                        value: 0,
                        child: Text(
                          'ブロック',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.black),
                        ),
                        textStyle: TextStyle(color: Colors.black),
                      ),
                      PopupMenuItem<int>(
                        value: 0,
                        child: Text(
                          '修正',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.black),
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
                style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.black),
              ),
              SizedBox(height: 5),
              Text(
                'Content text...',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Colors.black),
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
