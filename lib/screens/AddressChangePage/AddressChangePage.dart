import 'package:flutter/material.dart';

class AddressChangePage extends StatefulWidget {
  const AddressChangePage({Key? key}) : super(key: key);

  @override
  State<AddressChangePage> createState() => _AddressChangePageState();
}

class _AddressChangePageState extends State<AddressChangePage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // Text editing controllers for user input fields
  final TextEditingController _addressLine1Controller = TextEditingController();
  final TextEditingController _addressLine2Controller = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _stateController = TextEditingController();
  final TextEditingController _postalCodeController = TextEditingController();
  final TextEditingController _countryController = TextEditingController();

  @override
  void initState() {
    super.initState();

    // Initialize controller values with any existing saved address data
    // (Load from local storage or database if applicable)
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(

        title: const Text('주소 변경'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Address line 1 input field
              TextFormField(
                controller: _addressLine1Controller,
                decoration: const InputDecoration(
                  labelText: '주소 1행',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '주소 1행을 입력해주세요.';
                  }
                  return null;
                },
              ),
              // Address line 2 input field (optional)
              TextFormField(
                controller: _addressLine2Controller,
                decoration: const InputDecoration(
                  labelText: '주소 2행 (선택사항)',
                ),
              ),
              // City input field
              TextFormField(
                controller: _cityController,
                decoration: const InputDecoration(
                  labelText: '도시',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '도시를 입력해주세요.';
                  }
                  return null;
                },
              ),
              // State input field
              TextFormField(
                controller: _stateController,
                decoration: const InputDecoration(
                  labelText: '도/도',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '도/도를 입력해주세요.';
                  }
                  return null;
                },
              ),
              // Postal code input field
              TextFormField(
                controller: _postalCodeController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: '우편번호',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '우편번호를 입력해주세요.';
                  }
                  return null;
                },
              ),
              // Country input field
              TextFormField(
                controller: _countryController,
                decoration: const InputDecoration(
                  labelText: '국가',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '국가를 입력해주세요.';
                  }
                  return null;
                },
              ),
              // Save button
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    // Save the entered address information
                    // (Save to local storage or database)

                    // Show a success message or navigate back to previous page
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('주소가 변경되었습니다.'),
                      ),
                    );
                  }
                },
                child: const Text('저장'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
