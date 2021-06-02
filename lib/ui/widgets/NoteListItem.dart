import 'package:any_link_preview/any_link_preview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:life_app/model/NoteModel.dart';
import 'package:life_app/resources/AppColors.dart';
import 'package:url_launcher/url_launcher.dart';

class NoteListItem extends StatelessWidget {
  NoteModel noteModel;

  NoteListItem(this.noteModel, {Key key}) : super(key: key);
  static const verticalGap = SizedBox(
    height: 5,
  );
  bool showMetaData = false;
  String url = "";
  RegExp exp =
      new RegExp(r'(?:(?:https?|ftp):\/\/)?[\w/\-?=%.]+\.[\w/\-?=%.]+');

  @override
  Widget build(BuildContext context) {
    Iterable<RegExpMatch> matches = exp.allMatches(noteModel.note_name);
    matches.forEach((match) {
      url = noteModel.note_name.substring(match.start, match.end);
      print(url);
    });

    return Container(
      color: AppColors.noteBackgroundColor,
      width: double.infinity,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 60,
          ),
          Flexible(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Align(
                alignment: Alignment.centerRight,
                child: Card(
                  color: AppColors.noteCardColor,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: url.isNotEmpty
                        ? AnyLinkPreview(
                            displayDirection: UIDirection.UIDirectionHorizontal,
                            link: url,
                            errorBody: 'Show my custom error body',
                            removeElevation: true,
                            borderRadius: 0,
                            errorTitle: 'Show my custom error title',
                          )
                        : Linkify(
                            onOpen: _onOpenURL,
                            text: noteModel.note_name,
                          ),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Future<void> _onOpenURL(LinkableElement link) async {
    print("Clicked");
    if (await canLaunch(link.url)) {
      await launch(link.url);
    } else {
      throw 'Could not launch $link';
    }
  }
}
