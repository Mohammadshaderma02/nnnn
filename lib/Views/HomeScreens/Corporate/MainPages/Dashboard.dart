import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Dashboard extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  String _customerName;




  @override
  void initState() {
    newFunction();
    super.initState();
  }

  void newFunction()async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if(prefs.containsKey("selectedSearchCriteria2save")){
      print(">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>");
      setState(() {
       // newSellec = prefs.getString('selectedSearchCriteria2save');
      //  idddd=prefs.getInt('searchIDd');
      //  SellectCheck=true;
      //  kkkkkk=prefs.getString('searchValuenew');
    //    showGo360Viwe=true;
        _customerName=prefs.getString("customerName");
       // _subscriberName=prefs.getString("subscriberName");
      //  _customerID=prefs.getString("customerID");
      });

    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Color(0xFF392156),

            ),
            child: Column(
              children: [
                const SizedBox(height: 50),
                ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 30),
                  title: Text('Dashboard',
                      style: Theme.of(context)
                          .textTheme
                          .headlineSmall
                          ?.copyWith(color: Colors.white)),
                  subtitle: Text(_customerName.toString(),
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium
                          ?.copyWith(color: Colors.white)),
                ),
                const SizedBox(height: 20)
              ],
            ),
          ),
          Expanded(
            child:  ListView(
              padding: EdgeInsets.zero,
              children: [
                Container(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: GridView.count(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisCount: 2,
                      crossAxisSpacing: 30,
                      mainAxisSpacing: 20,
                      children: [
                        itemDashboard('Customer','360 View', Icons.person_pin_outlined, Colors.deepOrange),
                        itemDashboard('Subscriber','360 View', Icons.circle_notifications, Colors.green),
                        itemDashboard('Subscriber', 'List',Icons.format_list_bulleted_outlined, Colors.purple),
                        itemDashboard('Promotions', '',Icons.discount, Color(0xffC70039 )),
                        itemDashboard('Kurmalak','', Icons.star_half_outlined, Colors.indigo),
                        itemDashboard('Balance','', Icons.monetization_on, Colors.teal),
                        itemDashboard('Subscriber','Services', Icons.miscellaneous_services_sharp, Colors.blue),
                        itemDashboard('Home', '',Icons.home,Color(0xFF392156)),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20)
              ],
            ),
          ),

        ],
      ),
    );
  }

  itemDashboard(String title,String Subtitle, IconData iconData, Color background) => Container(
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                  offset: const Offset(0, 5),
                  color: Color(0xFF392156).withOpacity(.2),
                  spreadRadius: 2,
                  blurRadius: 5)
            ]),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: background,
                  shape: BoxShape.circle,
                ),
                child: Icon(iconData, color: Colors.white)),
            const SizedBox(height: 8),
            Text(title,
                style: Theme.of(context).textTheme.titleMedium),
            Text(Subtitle,
                style: Theme.of(context).textTheme.titleMedium)
          ],
        ),
      );
}
