import 'package:flutter/material.dart';
import 'package:kryptopedia/dialogs/generic_confirmation.dart';
import 'package:kryptopedia/dialogs/generic_text_input.dart';
import 'package:pdfrx/pdfrx.dart';
import 'package:url_launcher/url_launcher.dart';

class PdfViewerScreen extends StatefulWidget {
  final String pdfPath;
  final String title;
  const PdfViewerScreen({
    super.key,
    required this.pdfPath,
    required this.title,
  });

  @override
  State<PdfViewerScreen> createState() => _PdfViewerScreenState();
}

class _PdfViewerScreenState extends State<PdfViewerScreen> {
  final controller = PdfViewerController();
  late final PdfDocumentRef documentRef = PdfDocumentRefAsset(widget.pdfPath);
  PdfTextSearcher? textSearcher;
  bool searching = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          Visibility(
            visible: (!searching && textSearcher != null),
            child: IconButton(
              icon: Icon(Icons.search),
              onPressed: () async {
                String? query = await showDialog(
                  context: context,
                  builder: (context) => TextInputDialog(title: "Search text"),
                );
                if (query != null && query.isNotEmpty) {
                  textSearcher!.startTextSearch(query, goToFirstMatch: true);
                  setState(() {
                    searching = true;
                  });
                }
              },
            ),
          ),
          Visibility(
            visible: searching,
            child: Row(
              spacing: 5,
              children: [
                ElevatedButton(
                  child: const Icon(Icons.arrow_left),
                  onPressed: () => textSearcher!.goToPrevMatch(),
                ),
                ElevatedButton(
                  child: const Icon(Icons.clear),
                  onPressed: () => setState(() {
                    textSearcher!.resetTextSearch();
                    searching = false;
                  }),
                ),
                ElevatedButton(
                  child: const Icon(Icons.arrow_right),
                  onPressed: () => textSearcher!.goToNextMatch(),
                ),
              ],
            ),
          ),
        ],
      ),
      body: PdfViewer(
        documentRef,
        controller: controller,
        params: PdfViewerParams(
          calculateInitialZoom: (document, controller, fitZoom, coverZoom) =>
              fitZoom,
          linkHandlerParams: PdfLinkHandlerParams(
            onLinkTap: (link) async {
              if (link.dest != null) {
                controller.goToDest(link.dest);
              }
              if (link.url != null) {
                bool? confirmed = await showDialog(
                  context: context,
                  builder: (context) {
                    return ConfirmationDialog(
                      title: "Open URL?",
                      body: "${link.url}",
                      confirmText: "Open",
                    );
                  },
                );
                if (confirmed != true) return;
                launchUrl(link.url!);
              }
            },
          ),
          viewerOverlayBuilder: (context, size, handleLinkTap) => [
            PdfViewerScrollThumb(
              controller: controller,
              orientation: ScrollbarOrientation.right,
              thumbBuilder: (context, thumbSize, pageNumber, controller) =>
                  GestureDetector(
                    onTap: () async {
                      String? pageInput = await showDialog(
                        context: context,
                        builder: (context) => TextInputDialog(
                          title: "Jump to page",
                          numberOnly: true,
                        ),
                      );
                      if (pageInput == null) return;
                      int page = int.parse(pageInput);
                      controller.goToPage(pageNumber: page);
                    },
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Center(
                        child: Text(
                          pageNumber.toString(),
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ),
            ),
          ],
          pagePaintCallbacks: [
            if (textSearcher != null) textSearcher!.pageTextMatchPaintCallback,
          ],
          onViewerReady: (document, controller) {
            setState(() {
              textSearcher = PdfTextSearcher(controller);
            });
          },
        ),
      ),
    );
  }
}
