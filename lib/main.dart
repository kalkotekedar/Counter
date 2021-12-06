import 'import.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Counter Manager',
      theme: ThemeData(
        primarySwatch: Colors.red,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  GlobalKey<_CounterOneState> _counterOneKey = GlobalKey<_CounterOneState>();
  int _selectedTab = 0;

  incCounter() {
    if (_counterOneKey.currentState != null) {
      _counterOneKey.currentState.increamentCounter();
    }
  }

  onTabChanged(int index) {
    setState(() {
      _selectedTab = index;
      if (_counterOneKey.currentState != null) {
        _counterOneKey.currentState.counter = _selectedTab;
        _counterOneKey.currentState.getData();
      }
    });
  }

  tab(IconData icon, String label) {
    return BottomNavigationBarItem(icon: Icon(icon), label: label);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        bottomNavigationBar: BottomNavigationBar(
          onTap: onTabChanged,
          currentIndex: _selectedTab,
          items: <BottomNavigationBarItem>[
            tab(Icons.looks_one_sharp, 'Counter One'),
            tab(Icons.looks_two_sharp, 'Counter Two'),
            tab(Icons.looks_3_sharp, 'Counter Three')
          ],
        ),
        body: CounterOne(key: _counterOneKey),
        floatingActionButton: FloatingActionButton(
          onPressed: incCounter,
          tooltip: 'Increment',
          child: Icon(Icons.add),
        ), // This trailing comma makes auto-formatting nicer for build methods.
      ),
    );
  }
}

class CounterOne extends StatefulWidget {
  const CounterOne({Key key}) : super(key: key);

  inc() => createState().increamentCounter();

  @override
  _CounterOneState createState() => _CounterOneState();
}

class _CounterOneState extends State<CounterOne> {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  int fCounter = 0;
  int counter = 0;

  resetCount() async {
    _firestore.collection(p_counter).doc(c_counter_one).set({c_counter: 0});
    _firestore.collection(p_counter).doc(c_counter_two).set({c_counter: 0});
    _firestore.collection(p_counter).doc(c_counter_three).set({c_counter: 0});
    setState(() => fCounter = 0);
  }

  getData() async {
    if (!mounted) return;
    switch (counter) {
      case 0:
        _firestore.collection(p_counter).doc(c_counter_one).get().then((value) {
          setState(() {
            var data = value.data();
            setState(() {
              fCounter = data[c_counter];
            });
          });
        });
        break;
      case 1:
        _firestore.collection(p_counter).doc(c_counter_two).get().then((value) {
          setState(() {
            var data = value.data();
            setState(() {
              fCounter = data[c_counter];
            });
          });
        });
        break;
      case 2:
        _firestore
            .collection(p_counter)
            .doc(c_counter_three)
            .get()
            .then((value) {
          setState(() {
            var data = value.data();
            setState(() {
              fCounter = data[c_counter];
            });
          });
        });
        break;
      default:
        break;
    }
  }

  increamentCounter() {
    if (!mounted) return;
    fCounter++;
    switch (counter) {
      case 0:
        _firestore
            .collection(p_counter)
            .doc(c_counter_one)
            .set({c_counter: fCounter}).then((value) {
          setState(() => fCounter);
        }).catchError((onError) {
          setState(() => fCounter--);
        });
        break;
      case 1:
        _firestore
            .collection(p_counter)
            .doc(c_counter_two)
            .set({c_counter: fCounter}).then((value) {
          setState(() => fCounter);
        }).catchError((onError) {
          setState(() => fCounter--);
        });
        break;
      case 2:
        _firestore
            .collection(p_counter)
            .doc(c_counter_three)
            .set({c_counter: fCounter}).then((value) {
          setState(() => fCounter);
        }).catchError((onError) {
          setState(() => fCounter--);
        });
        break;
      default:
        break;
    }
  }

  @override
  void initState() {
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var w = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            appText(
              'Page $t_counter of ${counter + 1} is',
              color: Colors.black87,
              size: 18,
            ),
            const SizedBox(height: 10),
            appText('$fCounter',
                size: w / 3, isBold: true, color: Colors.black),
            const SizedBox(height: 20),
            FlatButton(
              color: Colors.redAccent,
              padding: EdgeInsets.all(15),
              splashColor: Colors.red[100],
              child: appText(t_increament_me, color: Colors.white, size: 20),
              textColor: Colors.white,
              onPressed: increamentCounter,
            ),
            const SizedBox(height: 10),
            InkWell(
              child: appText(t_reset,
                  isUnderline: true, color: Colors.black54, size: 16),
              onTap: resetCount,
            ),
          ],
        ),
      ),
    );
  }
}
