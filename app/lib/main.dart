import 'package:app/bloc/item/bloc.dart';
import 'package:app/bloc/item/event.dart';
import 'package:app/bloc/item/state.dart';
import 'package:app/bloc/list/bloc.dart';
import 'package:app/bloc/list/event.dart';
import 'package:app/bloc/list/state.dart';
import 'package:app/repository/firebase_product_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'model/product.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Liste des courses',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  final _globalKey = GlobalKey<ScaffoldState>();

  MyHomePage({Key key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  ListBloc _listBloc;
  ItemBloc _itemBloc;

  @override
  void initState() {
    super.initState();
    FirebaseProductRepository repository = FirebaseProductRepository();
    _listBloc = ListBloc(repository: repository)..add(FetchList());
    _itemBloc = ItemBloc(repository: repository);
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ListBloc, ListState>(
        bloc: _listBloc,
        listener: (context, state) {
          print(state);
          if (state is ItemDeleted) {
            _listBloc.add(FetchList());
          }
        },
        builder: (context, state) {
          return Scaffold(
              key: widget._globalKey,
              appBar: AppBar(title: Text("Liste des courses")),
              bottomSheet: BlocConsumer<ItemBloc, ItemState>(
                  bloc: _itemBloc,
                  listener: (context, itemState) {},
                  builder: (context, itemState) {
                    return Container(child: _bottomSheetBuilder(itemState));
                  }),
              floatingActionButton: BlocConsumer<ItemBloc, ItemState>(
                  bloc: _itemBloc,
                  listener: (context, itemState) {},
                  builder: (context, itemState) {
                    if (!(itemState is ItemCreating)) {
                      return FloatingActionButton(
                          onPressed: () {
                            _itemBloc.add(CreateItem());
                          },
                          child: Icon(Icons.add));
                    } else {
                      return Container(width: 0.0, height: 0.0);
                    }
                  }),
              body: () {
                if (state is ListLoaded) {
                  return StreamBuilder<List<Product>>(
                    stream: state.itemListStream,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.active) {
                        return ListView.builder(
                          itemCount: snapshot.data.length,
                          itemBuilder: (context, index) {
                            Product product = snapshot.data[index];
                            return Dismissible(
                                key: Key(product.id),
                                onDismissed: (direction) {
                                  _listBloc.add(DeleteItem(product.id));
                                },
                                child: InkWell(
                                  child: Card(
                                      elevation: 1,
                                      color: Colors.white,
                                      child: ClipPath(
                                        child: Container(
                                            height: 50,
                                            decoration: BoxDecoration(
                                                border: Border(
                                                    left: BorderSide(
                                                        color: Colors.green,
                                                        width: 4))),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: SizedBox(
                                                  height: 50,
                                                  child: Row(children: [
                                                    Text(product.name)
                                                  ])),
                                            )),
                                        clipper: ShapeBorderClipper(
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(3))),
                                      )),
                                  onTap: () {
                                    //_listBloc.add(DeleteItem(product.id));
                                  },
                                ));
                          },
                        );
                      } else if (snapshot.connectionState ==
                          ConnectionState.waiting) {
                        print("waiting ...");
                        return Center(child: CircularProgressIndicator());
                      } else {
                        return Center(child: Text("pas de données"));
                      }
                    },
                  );
                } else {
                  print(state);
                  return Center(child: CircularProgressIndicator());
                }
              }());
        });
  }

  Widget _bottomSheetBuilder(ItemState itemState) {
    if (itemState is ItemCreating) {
      final _formKey = GlobalKey<FormState>();
      return Card(
        color: Color.fromRGBO(220, 220, 220, 0.5),
        child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
                height: 200,
                child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        TextFormField(
                          initialValue: "",
                          maxLines: 2,
                          decoration: InputDecoration(
                            hintText: "Nom du produit",
                            labelText: "Entrer produit à acheter",
                          ),
                          validator: (value) {
                            if (value.isEmpty) {
                              return "Merci d'entrer un nom valide";
                            } else {
                              itemState.product = Product(name: value);
                              return null;
                            }
                          },
                        ),
                        SizedBox(height: 20.0),
                        RaisedButton(
                          child: Text("Enregistrer"),
                          onPressed: () {
                            if (_formKey.currentState.validate()) {
                              _itemBloc.add(SaveItem(itemState.product));
                            }
                          },
                        )
                      ],
                    )))),
      );
    } else {
      return Container(width: 0.0, height: 0.0);
    }
  }
}
