import 'dart:ffi';
import 'dart:io';
import 'dart:developer';
import 'dart:convert';
import 'dart:math';
import 'package:path/path.dart';
import 'package:mime/mime.dart';

import './route.dart';
import './file.dart';
import './response.dart';
import './type.dart';
import './template.dart';

class TargetServer {
    int port;
    String ip;
    String path;
    int get getPort => port;
    String get getIp => ip;
    List<TargetRoute> routes = [ new TargetRoute("first", "", (HttpRequest request) async { return 'hello!'; }, new ExtendedContentType(ContentType.html, "")) ];
    var config;

    HttpServer server;
    HttpServer get getServer => server;

    void Config(var config) {
      this.config = config;
    }

    TargetServer(this.port, this.ip, this.path) {
        HttpServer.bind(this.ip, this.port).then((HttpServer server) { 
            this.server = server;
            server.listen((HttpRequest request) async {
                TargetResponse response = await this.HandleRequest(request);

                print(
                  "[Incoming response for request]: \n (IP): " + request.connectionInfo.remoteAddress.address + 
                  "\n (Mime Type): " + response.mime + 
                  "\n (URL Path): " + request.uri.path + 
                  "\n (Extended Type): " + response.type.extendedType + 
                  "\n");

                if(response.mime == '') { // No mime type
                  request.response.headers.contentType = response.type.contentType;
                  var content = response.content;

                  if(response.type.extendedType == 'THTML') {
                    Target_THTML_File _file = Target_THTML_File(content, this);
                    await _file.Compile();

                    await Future.delayed(Duration(milliseconds: 25)); // Need to do sth with it.

                    content = _file.GetContent();
                  }

                  request.response.write(content);
                }
                else { // Has mime type
                  request.response.headers.set('Content-Type', response.mime);
                  if(response.mime == 'text/css' || response.mime == 'application/javascript') request.response.write(response.content);
                  else request.response.add(response.raw);
                }
                
                
                request.response.close();
            });
        });
    } 

    void Run() {
        print('Starting Target Server at: $ip:$port');
        this.Running();
    }

    void Running() {
        print('running...');
    }

    Future<TargetResponse> HandleRequest(HttpRequest request) async {
        String path = request.uri.path;
        String query = request.uri.query;

        var blocks = path.split("/");

        if(blocks[1] == '_' || blocks[0] == '_' || path == '/favicon.ico') {
          if(path == '/favicon.ico') path = "_/" + path; 
          var _path = '/public/' + path.split("_/")[1];

          final mimeType = lookupMimeType(_path);

          // 
          TargetFile file = await TargetFile(_path, this.path);
          var content = await file.Content_Utf8();
          List<int> raw = [];

          if(content == "--utf-error") {// First didn't worked
            raw = await file.GetRaw();
          }
          
          return TargetResponse(new ExtendedContentType(ContentType.binary, ""), content, mimeType, raw);
        }

        TargetRoute findRoute() => this.routes.firstWhere(
          (route) => route.path == path, 
          orElse: () => 
            new TargetRoute("get", "/404", (HttpRequest request) async { 
              return await TargetFile("/views/404.thtml", this.path).Content_Utf8(); 
            }, new ExtendedContentType(ContentType.html, "THTML")
          )
        );

        TargetRoute route = findRoute();
        String response_content = await route.callback(request);

        TargetResponse response = TargetResponse(route.type, response_content, '', '');

        return response;
    }

    void Router(RouterInstance) {
      this.routes = RouterInstance.GetRoutes(this);
    }
}