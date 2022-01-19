import 'package:flutter/material.dart';
import 'package:sqlite_implementation/constants.dart';
import 'package:sqlite_implementation/sql_helper.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // All kelas
  List<Map<String, dynamic>> _classes = [];

  bool _isLoading = true;

  // This function is used to fetch all data from database
  void _refreshClasses() async {
    final data = await SQLHelper.getClasses();
    setState(() {
      _classes = data;
      _isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _refreshClasses(); //Load the diary when the app start
  }

  final TextEditingController _namaKelasController = TextEditingController();
  final TextEditingController _tahunAjaranController = TextEditingController();
  final TextEditingController _jumlahSiswaController = TextEditingController();

  // This function will be triggered when the floating action button is pressed
  // Also when we want to update a kelas
  void _showForm(int? id) async {
    if (id != null) {
      final existingKelas =
          _classes.firstWhere((element) => element['id'] == id);
      _namaKelasController.text = existingKelas['nama_kelas'];
      _tahunAjaranController.text = existingKelas['tahun_ajaran'];
      _jumlahSiswaController.text = existingKelas['jumlah_siswa'].toString();
    }

    showModalBottomSheet(
      context: context,
      elevation: 5,
      isScrollControlled: true,
      builder: (_) => Container(
        padding: EdgeInsets.only(
          top: 15,
          left: 15,
          right: 15,
          bottom: MediaQuery.of(context).viewInsets.bottom + 120,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            TextField(
              controller: _namaKelasController,
              decoration: const InputDecoration(hintText: 'Nama kelass'),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _tahunAjaranController,
              decoration: const InputDecoration(hintText: 'Tahun ajaran'),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _jumlahSiswaController,
              decoration: const InputDecoration(hintText: 'Jumlah siswa'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                // Save new kelas
                if (id == null) {
                  await _addKelas();
                }
                if (id != null) {
                  await _updateClass(id);
                }

                // Close the bottom sheet
                Navigator.of(context).pop();
              },
              child: Text(id == null ? 'Tambahkan' : 'Update'),
            ),
          ],
        ),
      ),
    );
  }

  // Insert new kelas to the database
  Future<void> _addKelas() async {
    await SQLHelper.createClass(
      _namaKelasController.text,
      _tahunAjaranController.text,
      int.parse(_jumlahSiswaController.text),
    );
    _refreshClasses();
  }

  // Update an existing kelas
  Future<void> _updateClass(int id) async {
    await SQLHelper.updateClass(
      id,
      _namaKelasController.text,
      _tahunAjaranController.text,
      int.parse(_jumlahSiswaController.text),
    );
    _refreshClasses();
  }

  // Delete a kelas
  void _deleteItem(int id) async {
    await SQLHelper.deleteClass(id);
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text('Kelas berhasil dihapus')));
    _refreshClasses();
  }

  @override
  Widget build(BuildContext context) {
    // Provide total height and width of the screen
    Size size = MediaQuery.of(context).size;

    return SafeArea(
      child: Scaffold(
        backgroundColor: kBackgroundColor,
        body: Column(
          children: [
            Container(
              child: Center(child: Image.asset('images/logo.png')),
              height: size.height * 0.15,
            ),
            Expanded(
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.only(top: 14, bottom: 20),
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                  color: kPrimaryColor,
                ),
                child: _isLoading
                    ? const Center(
                        child: CircularProgressIndicator(),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.all(8),
                        itemCount: _classes.length,
                        itemBuilder: (context, index) => Card(
                          color: Colors.white,
                          margin:
                              EdgeInsets.only(bottom: 16, left: 8, right: 8),
                          elevation: 6,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(14),
                            child: Slidable(
                              startActionPane: ActionPane(
                                motion: const ScrollMotion(),
                                children: [
                                  Container(
                                    width: 70,
                                    height: double.infinity,
                                    color: Colors.red,
                                    child: IconButton(
                                      icon: const Icon(Icons.delete),
                                      iconSize: 32,
                                      color: Colors.white,
                                      onPressed: () => _deleteItem(
                                        _classes[index]['id'],
                                      ),
                                    ),
                                  ),
                                  Container(
                                    width: 70,
                                    height: double.infinity,
                                    color: kDarkColor,
                                    child: IconButton(
                                        icon: const Icon(Icons.edit),
                                        iconSize: 32,
                                        color: Colors.white,
                                        onPressed: () =>
                                            _showForm(_classes[index]['id'])),
                                  ),
                                ],
                              ),
                              child: ListTile(
                                title: Text(
                                  _classes[index]['nama_kelas'],
                                  style: const TextStyle(
                                      color: kDarkColor,
                                      fontWeight: FontWeight.w700),
                                ),
                                subtitle: Text(
                                  _classes[index]['tahun_ajaran'],
                                ),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      _classes[index]['jumlah_siswa']
                                          .toString(),
                                    ),
                                    const Icon(
                                      Icons.people,
                                      color: kDarkColor,
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
              ),
            )
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            _showForm(null);

            // Clear the textfields
            _namaKelasController.text = '';
            _tahunAjaranController.text = '';
            _jumlahSiswaController.text = '';
          },
          backgroundColor: kDarkColor,
          child: Icon(Icons.add),
        ),
      ),
    );
  }
}
