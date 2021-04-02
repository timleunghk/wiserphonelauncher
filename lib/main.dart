import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:device_apps/device_apps.dart';
import 'dart:async';
import 'package:intl/intl.dart';
import 'package:splashscreen/splashscreen.dart';

void main() => runApp(MyApp());



class MySplashScreen extends StatefulWidget {
  MySplashScreen({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MySplashScreenState createState() => _MySplashScreenState();
}


class _MySplashScreenState extends State<MySplashScreen> {
  @override
  Widget build(BuildContext context) {
    print("Triggered MySplashScreenState");
    return new SplashScreen(
      seconds: 10,
      navigateAfterSeconds: new Homepage(),
      image:  new Image.asset('assets/WiserPhone.png'),
      loadingText: new Text("Please Wait..."),
      backgroundColor: Colors.white,
      photoSize: 175,
      loaderColor: Colors.white,
    );
  }
}

class MyApp extends StatelessWidget{
  @override
  Widget build(BuildContext context){
    return new MaterialApp(
      title: 'Launcher',
      home: new MySplashScreen(),
    );
  }
}

class ShowClock extends StatefulWidget{
  @override
  _ShowClockState createState()=> _ShowClockState();

}

class _ShowClockState extends State<ShowClock>
{
  String _timeString;

  @override
  void initState()
  {
    DateTime now = DateTime.now();
    _timeString = DateFormat('HH:mm').format(now);

    Timer.periodic(Duration(seconds:1), (Timer t)=>_getCurrentTime());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
        data: Theme.of(context).copyWith(
          // Set the transparency here
          canvasColor: Colors.white70.withOpacity(0.3), //or any other color you want. e.g Colors.blue.withOpacity(0.5)
        ),
        child: Container(
          child:Center(
            child: Text(_timeString, style: TextStyle(fontSize: 100, fontFamily: 'NHK' , color: Colors.white,  ),),
          ),
        )
    );

  }

  void _getCurrentTime()  {
    setState(()
    {
      DateTime now = DateTime.now();
      _timeString = DateFormat('HH:mm').format(now);
    });
  }
}


class Homepage extends StatefulWidget{
  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {

  BouncingScrollPhysics _bouncingScrollPhysics = BouncingScrollPhysics();

  @override
  Widget build(BuildContext context){
    return Scaffold(
      body: Container(
        height: (MediaQuery.of(context).size.height),
        width: (MediaQuery.of(context).size.width),
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage("assets/background.png"), fit: BoxFit.cover)),
        child: PageView(
          children: [
            Container(
              child: Table(
                  border: TableBorder.all(width:0.0 ,style: BorderStyle.none   ),
                  defaultVerticalAlignment: TableCellVerticalAlignment.top,
                  children: <TableRow>[
                    TableRow(
                      children: <Widget>[
                        Container(
                          height: (MediaQuery.of(context).size.height) * 0.86 ,
                          width: (MediaQuery.of(context).size.width),
                          child: Center(
                            child: ShowClock(),

                          ),
                        ),
                      ],
                    ),
                    TableRow(
                      children: <Widget>[
                        Container(
                          height: (MediaQuery.of(context).size.height) * 0.24,
                          width: (MediaQuery.of(context).size.width),
                          color: Colors.grey.withOpacity(0.3),
                          child: FutureBuilder(
                            future: DeviceApps.getInstalledApplications(
                              includeSystemApps: true,
                              onlyAppsWithLaunchIntent: true,
                              includeAppIcons: true,
                            ),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState==ConnectionState.done){
                                List<Application> allapps=[];
                                List<Application> loadedAllapps=snapshot.data;
                                for (Application appitem in loadedAllapps){
                                  if (appitem.packageName.contains("dialer") || appitem.packageName.contains("contacts") ||
                                      appitem.packageName.contains("email") || appitem.packageName.contains("jelly")){
                                    allapps.add(appitem);
                                  }
                                }
                                return GridView.count(
                                  crossAxisCount: 4,
                                  padding: EdgeInsets.only(
                                    top: 5.0,
                                  ),
                                  physics: _bouncingScrollPhysics,
                                  children: List.generate(allapps.length,(index){
                                    return GestureDetector(
                                      onTap: () {
                                        DeviceApps.openApp(allapps[index].packageName);
                                      },
                                      child: Column(
                                        children: [
                                          Image.memory(
                                            (allapps[index] as ApplicationWithIcon).icon,
                                            width:48,
                                          ),
                                          SizedBox(height:3.0,),
                                          Text("${allapps[index].appName}",
                                            style:TextStyle(
                                              color: Colors.white,
                                            ),
                                            overflow: TextOverflow.ellipsis, //if name too long, add .....
                                          )
                                        ],
                                      ),
                                    );

                                  }),
                                );
                              }
                              return Container(
                                child: Center(
                                  child: CircularProgressIndicator(),
                                ),
                              );
                            },
                          ),

                          //child: FutureBuilder(), //PHONE, CALENDAR,BROWSER,EMAIL
                        ),
                      ],
                    ),

                  ]
              ),
            ),
            Container(
              child: Table(
                  border: TableBorder.all(width:0.0, style: BorderStyle.none ),
                  defaultVerticalAlignment: TableCellVerticalAlignment.top,
                  children: <TableRow>[
                    TableRow(
                      children: <Widget>[
                        Container(
                          height: (MediaQuery.of(context).size.height) * 0.26 ,
                          width: (MediaQuery.of(context).size.width),
                          color: Colors.grey.withOpacity(0.2),
                          child: Center(
                            child: ShowClock(),
                          ),
                          //child:FutureBuilder(), //CLOCK
                        ),
                      ],
                    ),
                    TableRow(
                      children: <Widget>[
                        Container(
                          height: (MediaQuery.of(context).size.height) * 0.60,
                          width: (MediaQuery.of(context).size.width),
                          child: FutureBuilder(
                            future: DeviceApps.getInstalledApplications(
                              includeSystemApps: true,
                              onlyAppsWithLaunchIntent: true,
                              includeAppIcons: true,
                            ),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState==ConnectionState.done){
                                List<Application> allapps=snapshot.data;
                                return GridView.count(
                                  crossAxisCount: 4,
                                  padding: EdgeInsets.only(
                                    top: 5.0,
                                  ),
                                  physics: _bouncingScrollPhysics,
                                  children: List.generate(allapps.length,(index){
                                    return GestureDetector(
                                      onTap: () {
                                        DeviceApps.openApp(allapps[index].packageName);
                                      },
                                      child: Column(
                                        children: [
                                          Image.memory(
                                            (allapps[index] as ApplicationWithIcon).icon,
                                            width:48,
                                          ),
                                          SizedBox(height:3.0,),
                                          Text("${allapps[index].appName}",
                                            style:TextStyle(
                                              color: Colors.white,
                                            ),
                                            overflow: TextOverflow.ellipsis, //if name too long, add .....
                                          )
                                        ],
                                      ),
                                    );

                                  }),
                                );
                              }
                              return Container(
                                child: Center(
                                  child: CircularProgressIndicator(),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                    TableRow(
                      children: <Widget>[
                        Container(
                          height: (MediaQuery.of(context).size.height) * 0.24,
                          width: (MediaQuery.of(context).size.width),
                          color: Colors.grey.withOpacity(0.3),
                          child: FutureBuilder(
                            future: DeviceApps.getInstalledApplications(
                              includeSystemApps: true,
                              onlyAppsWithLaunchIntent: true,
                              includeAppIcons: true,
                            ),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState==ConnectionState.done){
                                List<Application> allapps=[];
                                List<Application> loadedAllapps=snapshot.data;
                                for (Application appitem in loadedAllapps){
                                  if (appitem.packageName.contains("dialer") || appitem.packageName.contains("contacts") ||
                                      appitem.packageName.contains("email") || appitem.packageName.contains("jelly")){
                                    allapps.add(appitem);
                                  }
                                }
                                return GridView.count(
                                  crossAxisCount: 4,
                                  padding: EdgeInsets.only(
                                    top: 5.0,
                                  ),
                                  physics: _bouncingScrollPhysics,
                                  children: List.generate(allapps.length,(index){
                                    return GestureDetector(
                                      onTap: () {
                                        DeviceApps.openApp(allapps[index].packageName);
                                      },
                                      child: Column(
                                        children: [
                                          Image.memory(
                                            (allapps[index] as ApplicationWithIcon).icon,
                                            width:48,
                                          ),
                                          SizedBox(height:3.0,),
                                          Text("${allapps[index].appName}",
                                            style:TextStyle(
                                              color: Colors.white,
                                            ),
                                            overflow: TextOverflow.ellipsis, //if name too long, add .....
                                          )
                                        ],
                                      ),
                                    );

                                  }),
                                );
                              }
                              return Container(
                                child: Center(
                                  child: CircularProgressIndicator(),
                                ),
                              );
                            },
                          ),
                          //child: FutureBuilder(), //PHONE, CALENDAR,BROWSER,EMAIL
                        ),
                      ],
                    ),
                  ]
              ),
            ),

          ],
        ),
      ),
    );



  }
}


