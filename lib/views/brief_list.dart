import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:myapp/models/api_response.dart';
import 'package:myapp/models/brief_for_listing.dart';
import 'package:myapp/services/briefs_service.dart';
import 'package:myapp/views/brief_delete.dart';

import 'brief_modify.dart';

class BriefList extends StatefulWidget {
  @override
  _BriefListState createState() => _BriefListState();
}

class _BriefListState extends State<BriefList> {
  BriefsService get service => GetIt.I<BriefsService>();

  late APIResponse<List<BriefForListing>> _apiResponse;
  bool _isLoading = false;

  String formatDateTime(DateTime dateTime) {
    return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
  }

  @override
  void initState() {
    _fetchBriefs();
    super.initState();
  }

  _fetchBriefs() async {
    setState(() {
      _isLoading = true;
    });

    _apiResponse = await service.getBriefsList();

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('List of briefs')),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.of(context)
                .push(MaterialPageRoute(builder: (_) => BriefModify(briefID: '',)));
          },
          child: Icon(Icons.add),
        ),
        body: Builder(
          builder: (_) {
            if (_isLoading) {
              return Center(child: CircularProgressIndicator());
            }

            if (_apiResponse.error) {
              return Center(child: Text(_apiResponse.errorMessage?? 'error'));
            }

            return ListView.separated(
              separatorBuilder: (_, __) =>
                  Divider(height: 1, color: Colors.green),
              itemBuilder: (_, index) {
                return Dismissible(
                  key: ValueKey(_apiResponse.data?[index].briefID?? '0'),
                  direction: DismissDirection.startToEnd,
                  onDismissed: (direction) {},
                  confirmDismiss: (direction) async {
                    final result = await showDialog(
                        context: context, builder: (_) => BriefDelete());
                    print(result);
                    return result;
                  },
                  background: Container(
                    color: Colors.red,
                    padding: EdgeInsets.only(left: 16),
                    child: Align(
                      child: Icon(Icons.delete, color: Colors.white),
                      alignment: Alignment.centerLeft,
                    ),
                  ),
                  child: ListTile(
                    title: Text(
                      style: TextStyle(color: Theme.of(context).primaryColor),
                      _apiResponse.data?[index].briefTitle?? 'title'
                    ),
                    subtitle: Text(
                        //'Last edited on ${formatDateTime(_apiResponse.data?[index].latestEditDateTime??  ?? _apiResponse.data?[index].createDateTime)}'
                        'Last edited on ${formatDateTime(_apiResponse.data?[index].latestEditDateTime ?? _apiResponse.data?[index].createDateTime ?? DateTime.now())}'
                    ),
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (_) => BriefModify(
                              briefID: _apiResponse.data?[index].briefID?? '0')));
                    },
                  ),
                );
              },
              itemCount: _apiResponse.data?.length?? 0,
            );
          },
        ));
  }
}
