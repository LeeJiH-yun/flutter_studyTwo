import 'package:flutter/material.dart';
import 'package:flutter_studytwo/common/const/colors.dart';
import 'package:collection/collection.dart';
import 'package:flutter_studytwo/rating/model/rating_model.dart';

class RatingCard extends StatelessWidget {
  //NetworkImage
  //AssetImage
  //CircleAvatar
  final ImageProvider avatarImage;

  //리스트로 위젯 이미지 보여줄 때
  final List<Image> images;
  final int rating;
  final String email;
  final String content;

  const RatingCard({required this.avatarImage,
    required this.images,
    required this.rating,
    required this.email,
    required this.content,
    Key? key}) : super(key: key);

  factory RatingCard.fromModel({
    required RatingModel model
  }) {
    return RatingCard(
      avatarImage: NetworkImage(
        model.user.imageUrl
      ),
      images: model.imgUrls.map((e) => Image.network(e)).toList(),
      rating: model.rating,
      email: model.user.username,
      content: model.content,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Divider(thickness: 1, color: Colors.grey,),
        _Header(avatarImage: avatarImage, email: email, rating: rating,),
        SizedBox(height: 8.0,),
        _Body(content: content,),
        if(images.length > 0)
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: SizedBox(
              height: 100,
              child: _Images(
                images: images,
              ),
            ),
          ),
      ],
    );
  }
}

class _Header extends StatelessWidget {
  final ImageProvider avatarImage;
  final int rating;
  final String email;

  const _Header({
    required this.avatarImage,
    required this.rating,
    required this.email,
    Key? key
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(
          radius: 12.0,
          backgroundImage: avatarImage,
        ),
        const SizedBox(width: 8.0,),
        Expanded(
          child: Text(
            email,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
                fontSize: 14.0,
                color: Colors.black,
                fontWeight: FontWeight.w500
            ),
          ),
        ),
        ...List.generate(5, (index) =>
            Icon(
              index < rating ? Icons.star : Icons.star_border_outlined,
              //인덱스가 rating보다 작을때만
              color: PRIMARY_COLOR,
            )),
      ],
    );
  }
}

class _Body extends StatelessWidget {
  final String content;

  const _Body({
    required this.content,
    Key? key
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Flexible(
          child: Text(
            content,
            style: TextStyle(
                color: BODY_TEXT_COLOR,
                fontSize: 14.0
            ),
          ),
        ),
      ],
    );
  }
}

class _Images extends StatelessWidget {
  final List<Image> images;

  const _Images({
    required this.images,
    Key? key
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
        scrollDirection: Axis.horizontal,
        children: images.mapIndexed( //collection.dart를 import함으로 index 사용 가능
              (index, e) =>
              Padding(
                padding: EdgeInsets.only(
                    right: index == images.length - 1 ? 0 : 16.0),
                //만약 인덱스가 마지막 이미지라면 패딩을 넣지 않고 아니면 넣는다.
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: e,
                ),
              ),
        ).toList()
    );
  }
}