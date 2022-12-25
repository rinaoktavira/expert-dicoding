import 'dart:convert';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:http/io_client.dart';

import '../data/models/movie_detail_model.dart';

class SslPinning {
  Future<SecurityContext> get globalContext async {
    final sslCert =
        await rootBundle.load('assets/certificates/certificate.cer');
    SecurityContext securityContext = SecurityContext(withTrustedRoots: false);
    securityContext.setTrustedCertificatesBytes(sslCert.buffer.asInt8List());
    return securityContext;
  }

  Future<MovieDetailResponse> getMovieDetailResponse() async {
    HttpClient client = HttpClient(context: await globalContext);
    client.badCertificateCallback =
        (X509Certificate cert, String host, int port) => false;
    IOClient ioClient = IOClient(client);
    final response =
        await ioClient.get(Uri.parse('https://api.themoviedb.org/'));

    return MovieDetailResponse.fromJson(jsonDecode(response.body)[0]);
  }
}
