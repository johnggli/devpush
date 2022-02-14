import 'package:devpush/core/app_colors.dart';
import 'package:devpush/core/app_images.dart';
import 'package:devpush/core/app_text_styles.dart';
import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

class PostDetailScreen extends StatefulWidget {
  final String title;
  final String imageUrl;
  final String content;
  final String link;
  final String subject;
  const PostDetailScreen({
    Key key,
    @required this.imageUrl,
    @required this.title,
    @required this.content,
    @required this.link,
    @required this.subject,
  }) : super(key: key);

  @override
  _PostDetailScreenState createState() => _PostDetailScreenState();
}

class _PostDetailScreenState extends State<PostDetailScreen> {
  void _launchURL(String url) async =>
      await canLaunch(url) ? await launch(url) : throw 'Could not launch $url';

  @override
  Widget build(BuildContext context) {
    var top;

    return Scaffold(
      backgroundColor: Colors.white,
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverAppBar(
              iconTheme: IconThemeData(
                color: Colors.white,
              ),
              expandedHeight: 192,
              floating: true,
              pinned: true,
              elevation: 1,
              backgroundColor: AppColors.black,
              flexibleSpace: LayoutBuilder(builder: (context, constraints) {
                top = constraints.biggest.height;
                // print(top);
                return FlexibleSpaceBar(
                  centerTitle: true,
                  background: Stack(
                    fit: StackFit.expand,
                    children: [
                      FancyShimmerImage(
                        shimmerBaseColor: Colors.grey[300],
                        shimmerHighlightColor: Colors.grey[100],
                        imageUrl: widget.imageUrl,
                        boxFit: BoxFit.cover,
                        errorWidget: Image.asset(
                          AppImages.defaultImage,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Opacity(
                        opacity: 0.3,
                        child: Container(
                          color: AppColors.black,
                        ),
                      ),
                    ],
                  ),
                  title: top < 128
                      ? Container(
                          width: MediaQuery.of(context).size.width * 0.6,
                          child: Text(
                            "${widget.title}",
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            style: AppTextStyles.tabTitleWhite,
                            textAlign: TextAlign.center,
                          ),
                        )
                      : Container(
                          width: MediaQuery.of(context).size.width * 0.6,
                          child: Text(
                            "${widget.title}",
                            overflow: TextOverflow.ellipsis,
                            maxLines: 4,
                            style: GoogleFonts.nunito(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              height: 1,
                            ),
                            textAlign: TextAlign.start,
                          ),
                        ),
                );
              }),
              systemOverlayStyle: SystemUiOverlayStyle.light,
            )
          ];
        },
        body: ListView(
          padding: EdgeInsets.all(18),
          physics: ClampingScrollPhysics(),
          children: <Widget>[
            Text(
              "${widget.subject}",
              style: AppTextStyles.blueText,
            ),
            SizedBox(
              height: 12,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "${widget.content}",
                  style: AppTextStyles.cardTitle,
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  width: double.maxFinite,
                  decoration: BoxDecoration(
                    border: Border.fromBorderSide(
                      BorderSide(
                        color: AppColors.black,
                      ),
                    ),
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () {
                        _launchURL(widget.link);
                      },
                      customBorder: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Acessar',
                              style: AppTextStyles.blackText,
                            ),
                            SizedBox(
                              width: 4,
                            ),
                            Icon(
                              Icons.open_in_new,
                              size: 18,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
