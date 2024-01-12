import 'package:flutter/material.dart';
import 'package:flutter_desktop_sqlite_app/Components/button.dart';
import 'package:flutter_desktop_sqlite_app/Components/colors.dart';
import 'package:flutter_desktop_sqlite_app/Components/input_field.dart';
import 'package:flutter_desktop_sqlite_app/SQLite/database_helper.dart';
import '../../Json/account_json.dart';

class Accounts extends StatefulWidget {
  const Accounts({super.key});

  @override
  State<Accounts> createState() => _AccountsState();
}

class _AccountsState extends State<Accounts> {
  late DatabaseHelper handler;
  late Future<List<AccountsJson>> accounts;
  final db = DatabaseHelper();

  @override
  void initState() {
    handler = db;
    accounts = handler.getAccounts();
    handler.init().whenComplete(() {
    accounts = getAllRecords();
    });

    super.initState();
  }

  Future<List<AccountsJson>> getAllRecords()async{
    return await handler.getAccounts();
  }

  Future<void> _onRefresh()async{
      setState(() {
        accounts = getAllRecords();
      });
  }

  Future<List<AccountsJson>> filter ()async{
    return await handler.filter(searchController.text);
  }

  final accHolder = TextEditingController();
  final accName = TextEditingController();
  final searchController = TextEditingController();
  bool isSearchOn = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          addDialog();
          accHolder.clear();
          accName.clear();
        },
        child: const Icon(Icons.add),
      ),
      appBar: AppBar(
        toolbarHeight: 70,
        title: isSearchOn?  Container(
          margin: const EdgeInsets.symmetric(horizontal: 2,vertical: 10),
          padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 10),
          width: MediaQuery.of(context).size.width *.4,
          height: 45,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(.5),
                blurRadius: 1,
                spreadRadius: 0
              )
            ]
          ),
          child: TextFormField(
            onChanged: (value){
              setState(() {
                accounts = filter();
              });
            },
            controller: searchController,
            decoration: InputDecoration(
              suffixIcon: searchController.text.isNotEmpty? IconButton(
                  onPressed: (){
                    setState(() {
                      searchController.clear();
                      _onRefresh();
                    });
                  },
                  icon: const Icon(Icons.clear,size: 17)):const SizedBox(),
              border: InputBorder.none,
              hintText: "Search accounts here",
              icon: const Icon(Icons.search),
            ),
          ),
        ) : const Text("Accounts"),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: IconButton(onPressed: (){
              setState(() {
                isSearchOn = !isSearchOn;
              });
            }, icon: const Icon(Icons.search)),
          )
        ],
      ),
      body: FutureBuilder(
        future: accounts,
        builder: (BuildContext context, AsyncSnapshot<List<AccountsJson>> snapshot) {
          if(snapshot.connectionState == ConnectionState.waiting){
            return const Center(
                child: CircularProgressIndicator());
          }else if(snapshot.hasData && snapshot.data!.isEmpty){
            return const Center(child: Text("No account found"));
          }else if(snapshot.hasError){
            return Text(snapshot.error.toString());
          }else{
            final items = snapshot.data?? <AccountsJson>[];
            return ListView.builder(
                itemCount: items.length,
                itemBuilder: (context,index){
              return ListTile(
                leading: CircleAvatar(
                  radius: 20,
                  child: Text(items[index].accHolder[0]),
                ),
                title: Text(items[index].accHolder),
                subtitle: Text(items[index].accName),
                trailing: IconButton(
                  onPressed: (){
                    setState(() {
                      deleteAccount(items[index].accId);
                    });
                  },
                  icon: Icon(Icons.delete,color: Colors.red.shade900),
                ),

                onTap: (){
                  setState(() {
                    //To open update dialog
                    updateDialog(items[index].accId);

                    //To show selected account in textfield for update method
                    accHolder.text = items[index].accHolder;
                    accName.text = items[index].accName;
                  });
                },
                tileColor: index%2 == 1? primaryColor.withOpacity(.03) : Colors.transparent,
              );
            });
          }
        },

      )
    );
  }

  void addDialog(){
    showDialog(context: context, builder: (context){
      return  AlertDialog(
        title: const Text("Add New Account"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
           InputField(hint: "Account Holder", icon: Icons.person, controller: accHolder),
           InputField(hint: "Account Name", icon: Icons.account_circle_rounded, controller: accName),
          ],
        ),

        actions: [
          Button(
              label: "ADD ACCOUNT",
              press: (){
                Navigator.pop(context);
                addAccount();
          })
        ],
      );
    });
  }

  //Update Dialog
  void updateDialog(id){
    showDialog(context: context, builder: (context){
      return  AlertDialog(
        title: const Text("Update Account"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            InputField(hint: "Account Holder", icon: Icons.person, controller: accHolder),
            InputField(hint: "Account Name", icon: Icons.account_circle_rounded, controller: accName),
          ],
        ),

        actions: [
          Button(
              label: "UPDATE",
              press: (){
                Navigator.pop(context);
                //Lets create update method
                updateAccount(id);
              })
        ],
      );
    });
  }


  //Add Account
  void addAccount()async{
    var res = await handler.insertAccount(AccountsJson(
        accHolder: accHolder.text,
        accName: accName.text,
        accStatus: 1,
        createdAt: DateTime.now().toIso8601String()));

      if(res>0){
      setState(() {
        _onRefresh();
      });
     }
  }

  //Delete Account
  void deleteAccount(id)async{
    var res = await handler.deleteAccount(id);
    if(res > 0){
      setState(() {
        _onRefresh();
      });
    }
  }

  //Update Account
 void updateAccount(accId)async{
   var res = await handler.updateAccount(accHolder.text, accName.text, accId);
   if(res>0){
     setState(() {
       _onRefresh();
     });
   }
 }
}
