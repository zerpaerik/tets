import 'package:flutter/material.dart';

class EndDrawer extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Container(
       width: 230,
      child: Drawer(
      child: ListView(
        children: <Widget>[
        SizedBox(
          height : 20.0, 
          child  : DrawerHeader(
              child  : Text('Emplooy 0001', style: TextStyle(color: Colors.grey, fontFamily: 'OpenSans-Regular', fontSize: 20, fontWeight: FontWeight.bold)),
              decoration:  BoxDecoration(color: Colors.white),
              margin : EdgeInsets.only(left:70),
              padding: EdgeInsets.zero
          ),
        ),
          ListTile(
            leading: Icon(Icons.account_circle),
            title: Text('Informacion personal', style: TextStyle(color: Colors.grey, fontFamily: 'OpenSans-Regular',fontSize: 15),),
            onTap: (){
              Navigator.pushNamed(context, '/view-profile-oblig');
            },
          ),
          ListTile(
            leading: Icon(Icons.info_outline),
            title: Text('Informacion academica/profesional', style: TextStyle(color: Colors.grey, fontFamily: 'OpenSans-Regular',fontSize: 15)),
            onTap: (){
              Navigator.pushNamed(context, '/transactionsList');
            },
          ),
          ListTile(
            leading: Icon(Icons.work),
            title: Text('Trabajos anteriores', style: TextStyle(color: Colors.grey, fontFamily: 'OpenSans-Regular',fontSize: 15)),
            onTap: (){
              Navigator.pushNamed(context, '/transactionsList');
            },
          ),
          ListTile(
            leading: Icon(Icons.group_work),
            title: Text('Ofertas laborales', style: TextStyle(color: Colors.grey, fontFamily: 'OpenSans-Regular',fontSize: 15)),
            onTap: (){
              Navigator.pushNamed(context, '/transactionsList');
            },
          ),
           ListTile(
            leading: Icon(Icons.exit_to_app),
            title: Text('Cerrar Sesión', style: TextStyle(color: Colors.grey, fontFamily: 'OpenSans-Regular',fontSize: 15)),
            //onTap: _showErrorDialog,
           //onTap: _submit
          ),
        ]
      )
    )

                
    );
  }
}