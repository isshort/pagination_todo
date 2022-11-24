import 'package:async/async.dart';
import 'package:flutter/material.dart';
import 'package:pagination_todo/searchable_dropdown/model/base_model.dart';
import 'package:pagination_todo/searchable_dropdown/searchable_controller.dart';

extension GlobalKeyExtension on GlobalKey {
  Rect? get globalPaintBounds {
    final renderObject = currentContext?.findRenderObject();
    final translation = renderObject?.getTransformTo(null).getTranslation();
    if (translation != null && renderObject?.paintBounds != null) {
      final offset = Offset(translation.x, translation.y);

      return renderObject!.paintBounds.shift(offset);
    }
    return null;
  }
}

class SearchableDropDownWidget extends StatefulWidget {
  const SearchableDropDownWidget(
      {Key? key,
      this.onItemSelected,
      required this.getRequest,
      required this.nameField,
      this.hintText,
      this.label,
      this.isRequired = false,
      this.leadingIcon,
      this.style,
      this.dropDownMaxHeight})
      : super(key: key);

  final Function(BaseModel selectedItem)? onItemSelected;
  final Future Function(int page, String? key) getRequest;
  final String nameField;
  final String? hintText;
  final String? label;
  final bool isRequired;
  final Widget? leadingIcon;
  final TextStyle? style;
  final double? dropDownMaxHeight;

  @override
  State<SearchableDropDownWidget> createState() =>
      _SearchableDropDownWidgetState();
}

class _SearchableDropDownWidgetState extends State<SearchableDropDownWidget> {
  late SearchableController controller;

  @override
  void initState() {
    super.initState();
    controller = SearchableController();
    controller.getRequestFun = widget.getRequest;
    controller.onInit();
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      key: controller.key,
      width: MediaQuery.of(context).size.width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (widget.label != null) labelText,
          buildDropDown(controller),
        ],
      ),
    );
  }

  Padding get labelText => Padding(
        padding:
            EdgeInsets.only(left: MediaQuery.of(context).size.height * 0.015),
        child: Text(
          widget.label! + (widget.isRequired ? '*' : ''),
          style:
              TextStyle(fontSize: MediaQuery.of(context).size.height * 0.022),
        ),
      );
  _dropDownOnTab(SearchableController controller) {
    bool isReversed = false;
    double? possitionFromBottom = controller.key.globalPaintBounds != null
        ? MediaQuery.of(context).size.height -
            controller.key.globalPaintBounds!.bottom
        : null;
    double alertDialogMaxHeight =
        widget.dropDownMaxHeight ?? MediaQuery.of(context).size.height * 0.3;
    double? dialogPossitionFromBottom = possitionFromBottom != null
        ? possitionFromBottom - alertDialogMaxHeight
        : null;
    if (dialogPossitionFromBottom != null) {
      //Dialog ekrana sığmıyor ise reverseler
      //If dialog couldn't fit the screen, reverse it
      if (dialogPossitionFromBottom <= 0) {
        isReversed = true;
        dialogPossitionFromBottom += alertDialogMaxHeight +
            controller.key.globalPaintBounds!.height +
            MediaQuery.of(context).size.height * 0.005;
      } else {
        dialogPossitionFromBottom -= MediaQuery.of(context).size.height * 0.005;
      }
    }
    controller.getRequest(page: 1, isNewSearch: true);
    //Hesaplamaları yaptıktan sonra dialogu göster
    //Show the dialog
    showDialog(
      context: context,
      builder: (context) {
        double? reCalculatePosition = dialogPossitionFromBottom;
        double keyboardHeight = MediaQuery.of(context).viewInsets.bottom;
        //Keyboard varsa digalogu ofsetler
        //If keyboard pushes the dialog, recalculate the dialog's possition.
        if (reCalculatePosition != null &&
            reCalculatePosition <= keyboardHeight) {
          reCalculatePosition =
              (keyboardHeight - reCalculatePosition) + reCalculatePosition;
        }
        return Padding(
          padding: EdgeInsets.only(
              bottom: reCalculatePosition ?? 0,
              left: MediaQuery.of(context).size.height * 0.02,
              right: MediaQuery.of(context).size.height * 0.02),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              SizedBox(
                height: alertDialogMaxHeight,
                child: _buildStatefullDropdownCard(controller, isReversed),
              ),
            ],
          ),
        );
      },
      barrierDismissible: true,
      barrierColor: Colors.transparent,
    );
  }

  Widget _buildStatefullDropdownCard(
      SearchableController controller, bool isReversed) {
    return Column(
      mainAxisAlignment:
          isReversed ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        Flexible(
          child: Card(
            margin: EdgeInsets.zero,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(
                    MediaQuery.of(context).size.height * 0.015))),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              verticalDirection:
                  isReversed ? VerticalDirection.up : VerticalDirection.down,
              children: [
                buildSearchBar(controller),
                Flexible(
                  child: buildListView(controller, isReversed),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Padding buildSearchBar(SearchableController controller) {
    return Padding(
      padding: EdgeInsets.all(MediaQuery.of(context).size.height * 0.01),
      child: CustomSearchBar(
        focusNode: controller.searchFocusNode,
        changeCompletionDelay: const Duration(milliseconds: 200),
        hintText: 'Search',
        isOutlined: true,
        leadingIcon: Icon(Icons.search,
            size: MediaQuery.of(context).size.height * 0.033),
        onChangeComplete: (value) {
          controller.searchText = value;
          if (value == '') {
            controller.getRequest(page: 1, isNewSearch: true);
          } else {
            controller.getRequest(page: 1, key: value, isNewSearch: true);
          }
        },
      ),
    );
  }

  CustomInkwell buildDropDown(SearchableController controller) {
    return CustomInkwell(
      padding: EdgeInsets.zero,
      disableTabEfect: true,
      onTap: () => _dropDownOnTab(controller),
      child: Card(
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
                Radius.circular(MediaQuery.of(context).size.height * 0.015))),
        child: Padding(
          padding: EdgeInsets.all(MediaQuery.of(context).size.height * 0.015),
          child: Row(
            children: [
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    if (widget.leadingIcon != null) widget.leadingIcon!,
                    if (widget.leadingIcon != null)
                      SizedBox(
                          width: MediaQuery.of(context).size.height * 0.01),
                    dropDownText(controller),
                  ],
                ),
              ),
              Icon(
                Icons.keyboard_arrow_down_rounded,
                size: MediaQuery.of(context).size.height * 0.033,
                color: widget.style?.color,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildListView(SearchableController controller, bool isReversed) {
    return ValueListenableBuilder(
      valueListenable: controller.itemList,
      builder: (context, List<BaseModel>? itemList, child) => itemList == null
          ? const Center(child: CircularProgressIndicator())
          : itemList.isEmpty
              ? Padding(
                  padding: EdgeInsets.all(
                      MediaQuery.of(context).size.height * 0.015),
                  child: const Text('No record'),
                )
              : Scrollbar(
                  thumbVisibility: true,
                  controller: controller.scrollController,
                  child: ListView.builder(
                    controller: controller.scrollController,
                    padding: _listviewPadding(isReversed),
                    itemCount: itemList.length + 1,
                    shrinkWrap: true,
                    reverse: isReversed,
                    itemBuilder: (context, index) {
                      if (index < itemList.length) {
                        final item = itemList.elementAt(index);
                        return CustomInkwell(
                          child: Text(item.toJson()?[widget.nameField] ?? ''),
                          onTap: () {
                            controller.selectedItem.value = item;
                            if (widget.onItemSelected != null) {
                              widget.onItemSelected!(item);
                            }
                            Navigator.pop(context);
                          },
                        );
                      } else {
                        return ValueListenableBuilder(
                          valueListenable: controller.state,
                          builder: (context, SearchableControllerState state,
                                  child) =>
                              state == SearchableControllerState.busy
                                  ? const Center(
                                      child: CircularProgressIndicator(),
                                    )
                                  : const SizedBox(),
                        );
                      }
                    },
                  ),
                ),
    );
  }

  EdgeInsets _listviewPadding(bool isReversed) {
    return EdgeInsets.only(
        left: MediaQuery.of(context).size.height * 0.01,
        right: MediaQuery.of(context).size.height * 0.01,
        bottom: !isReversed ? MediaQuery.of(context).size.height * 0.06 : 0,
        top: isReversed ? MediaQuery.of(context).size.height * 0.06 : 0);
  }

  Widget dropDownText(SearchableController controller) {
    return ValueListenableBuilder(
        valueListenable: controller.selectedItem,
        builder: (context, BaseModel? selectedItem, child) => Text(
              (selectedItem != null
                  ? (selectedItem.toJson()?[widget.nameField] ?? '')
                  : widget.hintText),
              style: widget.style?.copyWith(
                      color: selectedItem == null
                          ? (widget.style?.color ?? Colors.black)
                              .withOpacity(0.5)
                          : null) ??
                  TextStyle(color: Colors.black.withOpacity(0.5)),
            ));
  }
}

class CustomSearchBar extends StatelessWidget {
  final Function(String value)? onChangeComplete;

  final Duration changeCompletionDelay;

  final String? hintText;
  final Widget? leadingIcon;
  final bool isOutlined;
  final FocusNode? focusNode;
  final TextEditingController? controller;
  final TextStyle? style;

  const CustomSearchBar({
    Key? key,
    this.onChangeComplete,
    this.changeCompletionDelay = const Duration(milliseconds: 800),
    this.hintText,
    this.leadingIcon,
    this.isOutlined = false,
    this.focusNode,
    this.controller,
    this.style,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // ignore: no_leading_underscores_for_local_identifiers
    FocusNode _focusNode = focusNode ?? FocusNode();
    CancelableOperation? cancelableOpertaion;

    void _startCancelableOperation() {
      cancelableOpertaion = CancelableOperation.fromFuture(
        Future.delayed(changeCompletionDelay),
        onCancel: () {},
      );
    }

    Padding _buildTextField() {
      return Padding(
        padding: EdgeInsets.all(MediaQuery.of(context).size.height * 0.015),
        child: TextField(
          controller: controller,
          focusNode: focusNode,
          maxLines: 1,
          onChanged: (value) async {
            await cancelableOpertaion?.cancel();
            _startCancelableOperation();
            cancelableOpertaion?.value.whenComplete(() async {
              if (onChangeComplete != null) onChangeComplete!(value);
            });
          },
          style: style,
          decoration: InputDecoration(
            contentPadding: EdgeInsets.zero,
            isDense: true,
            border: InputBorder.none,
            hintText: hintText,
            icon: leadingIcon,
          ),
        ),
      );
    }

    return CustomInkwell(
      padding: EdgeInsets.zero,
      disableTabEfect: true,
      onTap: _focusNode.requestFocus,
      child: isOutlined
          ? Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(
                    MediaQuery.of(context).size.height * 0.01),
                border: Border.all(
                    color: (style?.color ?? Colors.black).withOpacity(0.5)),
              ),
              child: _buildTextField(),
            )
          : Card(
              margin: EdgeInsets.zero,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(
                      MediaQuery.of(context).size.height * 0.015))),
              child: _buildTextField(),
            ),
    );
  }
}

class CustomInkwell extends StatelessWidget {
  final Function()? onTap;
  final EdgeInsets? padding;
  final Widget child;
  final bool disableTabEfect;
  const CustomInkwell(
      {Key? key,
      required this.onTap,
      required this.child,
      this.padding,
      this.disableTabEfect = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      focusColor: disableTabEfect ? Colors.transparent : null,
      splashColor: disableTabEfect ? Colors.transparent : null,
      highlightColor: disableTabEfect ? Colors.transparent : null,
      onTap: onTap,
      borderRadius:
          BorderRadius.circular(MediaQuery.of(context).size.height * 0.015),
      child: Padding(
        padding: padding ??
            EdgeInsets.all(MediaQuery.of(context).size.height * 0.015),
        child: child,
      ),
    );
  }
}
