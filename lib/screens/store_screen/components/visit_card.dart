import 'package:devpush/core/app_colors.dart';
import 'package:devpush/core/app_text_styles.dart';
import 'package:devpush/providers/database_provider.dart';
import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class VisitCard extends StatefulWidget {
  final String visitCardId;
  final String image;
  final int value;
  const VisitCard({
    Key key,
    @required this.visitCardId,
    @required this.image,
    @required this.value,
  }) : super(key: key);

  @override
  _VisitCardState createState() => _VisitCardState();
}

class _VisitCardState extends State<VisitCard> {
  bool _bought = false;

  @override
  Widget build(BuildContext context) {
    var databaseProvider = Provider.of<DatabaseProvider>(context);

    return Container(
      // height: 236,
      decoration: BoxDecoration(
        border: Border.fromBorderSide(
          BorderSide(
            color: AppColors.light,
          ),
        ),
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            width: double.maxFinite,
            height: 136,
            child: ClipRRect(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10),
                topRight: Radius.circular(10),
              ),
              child: FancyShimmerImage(
                shimmerBaseColor: Colors.grey[300],
                shimmerHighlightColor: Colors.grey[100],
                imageUrl: widget.image,
                boxFit: BoxFit.cover,
                errorWidget: Container(),
              ),
            ),
          ),
          FutureBuilder(
            future: databaseProvider.getUserVisitCardById(widget.visitCardId),
            builder: (context, snapshot) {
              if (snapshot.data == null)
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Center(
                    child: Container(
                      width: 28,
                      height: 28,
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(
                          AppColors.lightGray,
                        ),
                      ),
                    ),
                  ),
                );
              if (snapshot.data)
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 18),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(),
                      TextButton(
                        onPressed: () async {
                          if (databaseProvider.user.visitCard != widget.image)
                            await databaseProvider.setVisitCard(widget.image);
                        },
                        child: databaseProvider.user.visitCard == widget.image
                            ? Text(
                                'EM USO',
                                style: AppTextStyles.grayText,
                              )
                            : Text(
                                'USAR',
                                style: AppTextStyles.blueText,
                              ),
                      )
                    ],
                  ),
                );
              else
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 18),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _bought
                          ? Container()
                          : Row(
                              children: [
                                Container(
                                  height: 24,
                                  width: 24,
                                  child: CircleAvatar(
                                    backgroundColor: Colors.yellow[500],
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: Colors.yellow[700],
                                      ),
                                      child: Icon(
                                        Icons.code,
                                        color: Colors.white,
                                        size: 18,
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 4,
                                ),
                                Text(
                                  '${widget.value}',
                                  style: AppTextStyles.cardTitle,
                                ),
                              ],
                            ),
                      _bought
                          ? TextButton(
                              onPressed: () async {
                                if (databaseProvider.user.visitCard !=
                                    widget.image)
                                  await databaseProvider
                                      .setVisitCard(widget.image);
                              },
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(),
                                  databaseProvider.user.visitCard ==
                                          widget.image
                                      ? Text(
                                          'EM USO',
                                          style: AppTextStyles.grayText,
                                        )
                                      : Text(
                                          'USAR',
                                          style: AppTextStyles.blueText,
                                        ),
                                ],
                              ),
                            )
                          : TextButton(
                              onPressed: () async {
                                if (widget.value <=
                                    databaseProvider.user.devCoins) {
                                  if (!_bought) {
                                    Future<void> buy() async {
                                      databaseProvider.buyVisitCard(
                                        widget.visitCardId,
                                        widget.value,
                                      );
                                    }

                                    buy().then(
                                      (value) => setState(() {
                                        _bought = true;
                                      }),
                                    );
                                  }
                                } else {
                                  showDialog(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                      title: Text('Ops..'),
                                      content: Text('DevCoins insuficientes.'),
                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          child: Text('Ok'),
                                        ),
                                      ],
                                    ),
                                  );
                                }
                              },
                              child: Text(
                                'COMPRAR',
                                style: AppTextStyles.blueText,
                              ),
                            ),
                    ],
                  ),
                );
            },
          ),
        ],
      ),
    );
  }
}
