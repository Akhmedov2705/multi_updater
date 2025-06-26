import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';

class UpdaterWrapper extends StatefulWidget {
  final Widget child;
  final String iosPath;
  final String androidPath;
  final bool useFirebase;
  final String remoteConfigKey;
  final String? jsonUrl;
  final VoidCallback? onUpdateTap;

  const UpdaterWrapper({
    super.key,
    required this.child,
    required this.iosPath,
    required this.androidPath,
    this.useFirebase = true,
    this.remoteConfigKey = 'latest_version',
    this.jsonUrl,
    this.onUpdateTap,
  });

  @override
  State<UpdaterWrapper> createState() => _UpdaterWrapperState();
}

class _UpdaterWrapperState extends State<UpdaterWrapper> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _checkVersion());
  }

  Future<void> _checkVersion() async {
    final info = await PackageInfo.fromPlatform();
    final currentVersion = info.version;
    final packageName = info.packageName;

    String? latestVersion;

    if (widget.useFirebase) {
      try {
        final remoteConfig = FirebaseRemoteConfig.instance;
        await remoteConfig.setDefaults({widget.remoteConfigKey: '1.0.0'});
        await remoteConfig.fetchAndActivate();
        latestVersion = remoteConfig.getString(widget.remoteConfigKey);
      } catch (_) {}
    }

    if ((latestVersion == null || latestVersion.isEmpty) &&
        widget.jsonUrl != null) {
      try {
        final response = await http.get(Uri.parse(widget.jsonUrl!));
        if (response.statusCode == 200) {
          final data = jsonDecode(response.body);
          latestVersion = data[packageName];
        }
      } catch (_) {}
    }

    if (latestVersion != null &&
        _isOlderVersion(currentVersion, latestVersion)) {
      _showUpdateDialog();
    }
  }

  bool _isOlderVersion(String current, String latest) {
    List<int> c = current.split('.').map(int.parse).toList();
    List<int> l = latest.split('.').map(int.parse).toList();
    for (int i = 0; i < 3; i++) {
      if (c[i] < l[i]) return true;
      if (c[i] > l[i]) return false;
    }
    return false;
  }

  void _showUpdateDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        title: const Text("Yangilanish mavjud"),
        content: const Text("Iltimos, ilovani yangilang."),
        actions: [
          TextButton(
            onPressed:
                widget.onUpdateTap ??
                () async {
                  final url = Platform.isAndroid
                      ? widget.androidPath
                      : widget.iosPath;
                  if (await canLaunchUrl(Uri.parse(url))) {
                    await launchUrl(
                      Uri.parse(url),
                      mode: LaunchMode.externalApplication,
                    );
                  }
                },
            child: const Text("Yangilash"),
          ),
          TextButton(onPressed: () => exit(0), child: const Text("Chiqish")),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
