import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:devpush/core/app_colors.dart';
import 'package:devpush/core/app_images.dart';
import 'package:devpush/core/app_text_styles.dart';
import 'package:devpush/providers/database_provider.dart';
import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class VisitCard extends StatefulWidget {
  final String visitCardId;
  final String title;
  final String image;
  final int value;
  final ValueChanged<Widget> onTap;
  const VisitCard({
    Key key,
    @required this.visitCardId,
    @required this.title,
    @required this.image,
    @required this.value,
    @required this.onTap,
  }) : super(key: key);

  @override
  State<VisitCard> createState() => _VisitCardState();
}

class _VisitCardState extends State<VisitCard> {
  @override
  Widget build(BuildContext context) {
    var databaseProvider = Provider.of<DatabaseProvider>(context);
    var inUse = databaseProvider.user.visitCard == widget.image;

    return Container(
      height: 136,
      width: 264,
      decoration: BoxDecoration(
        border: Border.fromBorderSide(
          BorderSide(
            color: AppColors.light,
          ),
        ),
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            showDialog(
              context: context,
              builder: (context) => Dialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 0.0,
                backgroundColor: Colors.transparent,
                child: Stack(
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.only(
                        top: 120,
                        bottom: 12,
                        left: 32,
                        right: 32,
                      ),
                      margin: EdgeInsets.only(top: 28),
                      decoration: new BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.rectangle,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 10.0,
                            offset: const Offset(0.0, 10.0),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisSize:
                            MainAxisSize.min, // To make the card compact
                        children: <Widget>[
                          StreamBuilder<DocumentSnapshot>(
                            stream: databaseProvider
                                .getUserVisitCardById(widget.visitCardId),
                            builder: (BuildContext context,
                                AsyncSnapshot<DocumentSnapshot> snapshot) {
                              if (snapshot.hasData) {
                                if (snapshot.data.exists) {
                                  return Align(
                                    alignment: Alignment.bottomCenter,
                                    child: Container(
                                      width: double.maxFinite,
                                      child: inUse
                                          ? TextButton(
                                              onPressed: () async {
                                                await databaseProvider
                                                    .setVisitCard("")
                                                    .then((_) {
                                                  Navigator.of(context).pop();
                                                });
                                              },
                                              style: TextButton.styleFrom(
                                                primary: Colors.white,
                                                backgroundColor: AppColors.red,
                                              ),
                                              child: Text(
                                                'Tirar',
                                                textAlign: TextAlign.center,
                                              ),
                                            )
                                          : TextButton(
                                              onPressed: () async {
                                                await databaseProvider
                                                    .setVisitCard(widget.image)
                                                    .then((_) {
                                                  Navigator.of(context).pop();
                                                });
                                              },
                                              style: TextButton.styleFrom(
                                                primary: Colors.white,
                                                backgroundColor: AppColors.blue,
                                              ),
                                              child: Text(
                                                'Usar',
                                                textAlign: TextAlign.center,
                                              ),
                                            ),
                                    ),
                                  );
                                } else {
                                  return Align(
                                    alignment: Alignment.bottomCenter,
                                    child: Container(
                                      width: double.maxFinite,
                                      child: TextButton(
                                        onPressed: () async {
                                          await databaseProvider.buyVisitCard(
                                            widget.visitCardId,
                                            widget.value,
                                          );
                                        },
                                        style: TextButton.styleFrom(
                                          primary: Colors.white,
                                          backgroundColor: AppColors.green,
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              'Comprar por:',
                                              textAlign: TextAlign.center,
                                            ),
                                            SizedBox(
                                              width: 4,
                                            ),
                                            Row(
                                              children: [
                                                Container(
                                                  height: 18,
                                                  width: 18,
                                                  child: CircleAvatar(
                                                    backgroundColor:
                                                        Colors.yellow[500],
                                                    child: Container(
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10),
                                                        color:
                                                            Colors.yellow[700],
                                                      ),
                                                      child: Icon(
                                                        Icons.code,
                                                        color: Colors.white,
                                                        size: 14,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: 4,
                                                ),
                                                Text(
                                                  '${widget.value}',
                                                  textAlign: TextAlign.left,
                                                  style: AppTextStyles.label,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  maxLines: 1,
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                }
                              }
                              return Container();
                            },
                          ),
                          Align(
                            alignment: Alignment.bottomCenter,
                            child: Container(
                              width: double.maxFinite,
                              child: TextButton(
                                onPressed: () {
                                  Navigator.of(context)
                                      .pop(); // To close the dialog
                                },
                                style: TextButton.styleFrom(
                                  primary: Colors.white,
                                  backgroundColor: AppColors.blueGray,
                                ),
                                child: Text(
                                  'Fechar',
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Positioned(
                      left: 0,
                      right: 0,
                      top: 0,
                      child: Container(
                        height: 120,
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
                            errorWidget: Image.asset(
                              AppImages.defaultImage,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      left: 0,
                      right: 0,
                      top: 120,
                      child: Container(
                        height: 20,
                        color: AppColors.blueGray,
                      ),
                    ),
                    Positioned(
                      left: 0,
                      right: 0,
                      top: 120,
                      child: Text(
                        '${widget.title}',
                        style: AppTextStyles.label,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
          customBorder: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                child: FancyShimmerImage(
                  shimmerBaseColor: Colors.grey[300],
                  shimmerHighlightColor: Colors.grey[100],
                  imageUrl: widget.image,
                  boxFit: BoxFit.cover,
                  errorWidget: Image.asset(
                    AppImages.defaultImage,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Positioned(
                bottom: 8,
                left: 12,
                child: Container(
                  width: 176,
                  child: Text(
                    '${widget.title}',
                    textAlign: TextAlign.left,
                    style: AppTextStyles.label,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ),
              ),
              if (inUse)
                Positioned(
                  top: 8,
                  right: 12,
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 2, horizontal: 6),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: AppColors.black,
                    ),
                    child: Container(
                      child: Text(
                        'Atual',
                        style: AppTextStyles.label,
                      ),
                    ),
                  ),
                ),
              StreamBuilder<DocumentSnapshot>(
                stream:
                    databaseProvider.getUserVisitCardById(widget.visitCardId),
                builder: (BuildContext context,
                    AsyncSnapshot<DocumentSnapshot> snapshot) {
                  if (snapshot.hasData) {
                    if (snapshot.data.exists) {
                      return Container();
                    } else {
                      return Stack(
                        children: [
                          Positioned(
                            bottom: 8,
                            right: 12,
                            child: Row(
                              children: [
                                Container(
                                  height: 18,
                                  width: 18,
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
                                        size: 14,
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 4,
                                ),
                                Text(
                                  '${widget.value}',
                                  textAlign: TextAlign.left,
                                  style: AppTextStyles.label,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                ),
                              ],
                            ),
                          ),
                          Center(
                            child: Icon(
                              Icons.lock,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                        ],
                      );
                    }
                  }
                  return Center(
                    child: SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
