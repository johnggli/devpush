import 'package:devpush/core/app_colors.dart';
import 'package:devpush/core/app_images.dart';
import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

class VideoCard extends StatelessWidget {
  final Map<String, dynamic> postData;
  final ValueChanged<Widget> onTap;
  const VideoCard({
    Key key,
    @required this.postData,
    @required this.onTap,
  }) : super(key: key);

  void _launchURL(String url) async =>
      await canLaunch(url) ? await launch(url) : throw 'Could not launch $url';

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 136,
      width: 154,
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
            _launchURL(postData['link']);
          },
          customBorder: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            // crossAxisAlignment: CrossAxisAlignment.start,
            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: double.maxFinite,
                height: 82,
                child: ClipRRect(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10),
                  ),
                  child: FancyShimmerImage(
                    shimmerBaseColor: Colors.grey[300],
                    shimmerHighlightColor: Colors.grey[100],
                    imageUrl: postData['imageUrl'],
                    boxFit: BoxFit.cover,
                    errorWidget: Image.asset(
                      AppImages.defaultImage,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              Container(
                  padding: const EdgeInsets.only(top: 8, left: 8, right: 8),
                  height: 36,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: Text(
                          postData['title'],
                          style: GoogleFonts.nunito(
                            color: AppColors.black,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            height: 1,
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                        ),
                      ),
                      Icon(
                        Icons.play_arrow,
                        size: 22,
                        color: AppColors.lightGray,
                      ),
                    ],
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
