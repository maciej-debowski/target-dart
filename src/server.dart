import 'dart:ffi';
import 'dart:io';
import 'dart:developer';
import 'dart:convert';
import 'dart:math';
import 'package:path/path.dart';
import 'package:mime/mime.dart';
import 'package:colorize/colorize.dart';

import './route.dart';
import './file.dart';
import './response.dart';
import './type.dart';
import './template.dart';
import './dbhandler.dart';
import './model.dart';

class TargetServer {
    int port;
    String ip;
    String path;
    int get getPort => port;
    String get getIp => ip;
    List<TargetRoute> routes = [ new TargetRoute("get", "", (HttpRequest request, TargetServer srv) async { return 'hello!'; }, new ExtendedContentType(ContentType.html, "")) ];
    var tables = {};
    var config;
    List<TargetModel> models;

    HttpServer server;
    HttpServer get getServer => server;
    TargetDatabase db;

    void Models(var models) {
      this.models = models;

      for(var model in models) {
        this.tables[model.name] = model;
      }
    }

    void Config(var config) {
      this.config = config;
      this.db = TargetDatabase();
      this.db.Connect(config);
    }

    TargetServer(this.port, this.ip, this.path) {
        HttpServer.bind(this.ip, this.port).then((HttpServer server) { 
            this.server = server;
            print("");
            server.listen((HttpRequest request) async {
                TargetResponse response = await this.HandleRequest(request);

                if(response.mime == '') { // No mime type
                  request.response.headers.contentType = response.type.contentType;
                  var content = response.content;

                  if(response.type.extendedType == 'THTML') {
                    Target_THTML_File _file = Target_THTML_File(content, this);
                    await _file.Compile();

                    await Future.delayed(Duration(milliseconds: 5)); // Need to do sth with it.

                    content = _file.GetContent();
                  }

                  request.response.write(content);
                }
                else { // Has mime type
                  request.response.headers.set('Content-Type', response.mime);
                  if(response.mime == 'text/css' || response.mime == 'application/javascript') request.response.write(response.content);
                  else request.response.add(response.raw);
                }
                
                // EOR
                request.response.close();

                // Logging

                var timespan = DateTime.now();
                var path = request.uri.path;
                var status = 200;
                var method = request.method;
                var ip = request.connectionInfo.remoteAddress.address;

                Colorize _ts = new Colorize("$timespan");
                Colorize _ip = new Colorize("$ip");
                Colorize _me = new Colorize("$method");
                Colorize _pa = new Colorize("$path");
                Colorize _st = new Colorize("$status"); 

                _ts.white();
                _ts.bgMagenta();

                _ip.bold();
                _ip.lightRed();

                _me.bgGreen();
                _me.white();

                _pa.lightCyan();

                _st.green();

                print("$_ts $_ip   $_me $_pa $_st");
            });
        });
    } 

    void Logger(String text) {
      print('[Target]: $text');
    }

    void Run() async {
      this.Logger('Starting Target Server at: $ip:$port');
      this.Running();

      this.Logger('Starting database models!');  
      for(var model in this.models) {
        model.Update(this.db, this.Logger, this.config);
      }

      this.Logger('Tip: to mix Laravel Mix (Vue SCSS etc) use npx mix watch command');
    }

    void Running() {
      this.Logger('Running...');
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
          (route) => route.path == path && route.method.toLowerCase() == request.method.toLowerCase(), 
          orElse: () => 
            new TargetRoute("get", "/404", (HttpRequest request, TargetServer srv) async { 
              return await TargetFile("/views/404.thtml", this.path).Content_Utf8(); 
            }, new ExtendedContentType(ContentType.html, "THTML")
          )
        );

        TargetRoute route = findRoute();
        String response_content = await route.callback(request, this);

        TargetResponse response = TargetResponse(route.type, response_content, '', '');

        return response;
    }

    void Router(RouterInstance) {
      this.routes = RouterInstance.GetRoutes(this);
    }
}