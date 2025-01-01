import 'package:flutter/material.dart';

import '../Response_Files/PurchaseQC_Response/Purchase_QC_MainData.dart';
import '../Utils/constants.dart';
import 'PurchaseQC_EntryList.dart';
import 'PurchaseQC_MainForm.dart';
import 'PurchaseQcItemList.dart';

class Purchase_QC_Form_TAB_Page extends StatefulWidget {
  var Urn,status;
  Purchase_QC_Form_TAB_Page(
      {Key? key, required this.Urn,this.status})
      : super(key: key);
  @override
  State<Purchase_QC_Form_TAB_Page> createState() => _Purchase_QC_Form_TAB_PageState();
}

class _Purchase_QC_Form_TAB_PageState extends State<Purchase_QC_Form_TAB_Page>
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
                Navigator.push(context, MaterialPageRoute(builder: (context) => PurchaseQC_EntryList(),));
              },
              icon: Icon(Icons.arrow_back)),
          elevation: 0.0,
          titleSpacing: 0.0,
          iconTheme: IconThemeData(color: Colors.white),
          title: Text(
            'Inward Qc',
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
            PurchaseQC_MainForm(tabController: _tabController,urn:widget.Urn,status: widget.status,),
            PurchaseQcItemList(tabController: _tabController,urn:widget.Urn,status: widget.status,),
            // Inward_ItemList(tabController: _tabController,urn:widget.Urn),
            //ItemsPage(tabController: _tabController),
          ],
        ),
      ),
    );
  }
}