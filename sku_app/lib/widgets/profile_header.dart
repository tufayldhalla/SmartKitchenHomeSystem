import 'package:flutter/material.dart';

class ProfileHeader extends StatelessWidget {
  const ProfileHeader({
    Key key,
    @required this.size,
    this.editMode = false,
  }) : super(key: key);

  final Size size;
  final bool editMode;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: size.height * 0.15,
      child: Stack(
        children: [
          Container(
            height: size.height * 0.12,
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                child: Icon(
                  Icons.person,
                  size: size.height * 0.12,
                ),
                height: size.height * 0.15,
                width: size.height * 0.15,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(size.height * 0.1),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                        blurRadius: 5,
                        spreadRadius: 0,
                        color: Colors.grey,
                        offset: Offset(0, 4)),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
