import 'package:flutter/material.dart';

import '../Utils/constants.dart';
import 'InwardListScreen.dart';
import 'Inward_ItemList.dart';
import 'Inward_MainForm.dart';
class Inward_TabPage extends StatefulWidget {
  var Urn,status;
  Inward_TabPage(
      {Key? key, required this.Urn, this.status})
      : super(key: key);
  @override
  State<Inward_TabPage> createState() => _Inward_TabPageState();
}

class _Inward_TabPageState extends State<Inward_TabPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: kMainColor,
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: kMainColor,
          leading: IconButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => InwardListScreen(),));
              },
              icon: Icon(Icons.arrow_back)),
          elevation: 0.0,
          titleSpacing: 0.0,
          iconTheme: IconThemeData(color: Colors.white),
          title: Text(
            'Inward',
            maxLines: 2,
            style: kTextStyle.copyWith(color: Colors.white, fontSize: 20.0),
          ),
          // actions:  [
          //   // Image(
          //   //   image: AssetImage('assets/images/notificationicon.png'),
          //   // ),
          // ],
          bottom: TabBar(
            controller: _tabController,
            indicatorColor: Colors.transparent,
            tabs: [
              Tab(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.home,
                      color: _tabController.index == 0
                          ? Colors.orange
                          : Colors.grey,
                    ),
                    SizedBox(width: 8),
                    Text(
                      'Main Details',
                      style: TextStyle(
                        color: _tabController.index == 0
                            ? Colors.orange
                            : Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
              Tab(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.list,
                      color: _tabController.index == 1
                          ? Colors.orange
                          : Colors.grey,
                    ),
                    SizedBox(width: 8),
                    Text(
                      'Item Details',
                      style: TextStyle(
                        color: _tabController.index == 1
                            ? Colors.orange
                            : Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        body: TabBarView(
          controller: _tabController,
          children: [
            Inward_MainForm(tabController: _tabController,urn:widget.Urn,status: widget.status,),
            Inward_ItemList(tabController: _tabController,urn:widget.Urn,status: widget.status,),
            //ItemsPage(tabController: _tabController),
          ],
        ),
      ),
    );
  }
}