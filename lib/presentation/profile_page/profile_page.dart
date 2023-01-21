import 'package:flutter/material.dart';
import 'package:graphic/graphic.dart';
import 'package:pengingat_list/common/constants.dart';
import 'package:pengingat_list/common/text_theme.dart';
import 'package:pie_chart/pie_chart.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  static const data = [
    {'days': 'Sun', 'tasks': 0},
    {'days': 'Mon', 'tasks': 2},
    {'days': 'Tue', 'tasks': 0},
    {'days': 'Wed', 'tasks': 8},
    {'days': 'Thu', 'tasks': 1},
    {'days': 'Fri', 'tasks': 0},
    {'days': 'Sat', 'tasks': 2},
  ];

  final dataMap = <String, double>{
    'Personal': 1,
  };

  final colorList = <Color>[
    const Color(0xff0984e3),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leadingWidth: 70,
        backgroundColor: Colors.white,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.all(10),
          child: Container(
            decoration: BoxDecoration(
                shape: BoxShape.circle, color: Colors.grey.shade200),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(100),
              child: Image.asset(
                'assets/images/foto identity.jpeg',
                fit: BoxFit.fitWidth,
              ),
            ),
          ),
        ),
        title: const Text(
          'Mohamad Rafli Dwitama',
          style: TextStyle(color: Colors.black),
        ),
        toolbarHeight: 70,
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                titleTaskOverview,
                style: CustomTextTheme.ttCommons16Black54,
              ),
              Row(
                children: List.generate(
                  2,
                  (index) => Expanded(
                    child: SizedBox(
                      height: 120,
                      child: Card(
                        color: Colors.blue.shade50,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text('$index',
                                style: CustomTextTheme.ttCommons24Black),
                            Text(overviewCategory[index])
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                height: 250,
                child: Card(
                  color: Colors.blue.shade50,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                          padding: const EdgeInsets.only(left: 25),
                          child: const Text(completionDaily)),
                      SizedBox(
                        height: 200,
                        child: Chart(
                          data: data,
                          variables: {
                            'days': Variable(
                              accessor: (Map map) => map['days'] as String,
                            ),
                            'tasks': Variable(
                              accessor: (Map map) => map['tasks'] as num,
                            ),
                          },
                          elements: [IntervalElement()],
                          axes: [
                            Defaults.horizontalAxis,
                            Defaults.verticalAxis,
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: Size.infinite.width,
                height: 100,
                child: Card(
                  color: Colors.blue.shade50,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: const [
                      Padding(
                        padding: EdgeInsets.only(left: 20),
                        child: Text(activityNext7Days),
                      ),
                      ListTile(
                        leading: Icon(Icons.calendar_month),
                        minLeadingWidth: 20,
                        title: Text('UAS Pemograman Mobile'),
                        trailing: Text('21-01-2023'),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Card(
                color: Colors.blue.shade50,
                child: Container(
                  height: 200,
                  padding: const EdgeInsets.only(left: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      const Text(pendingTasksInCategories),
                      PieChart(
                        chartRadius: 90,
                        dataMap: dataMap,
                        chartType: ChartType.ring,
                        baseChartColor: Colors.grey,
                        colorList: colorList,
                        chartValuesOptions: const ChartValuesOptions(
                          showChartValuesInPercentage: true,
                        ),
                        totalValue: 1,
                        chartLegendSpacing: 120,
                        ringStrokeWidth: 30,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
