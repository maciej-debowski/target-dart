import 'dart:ffi';
import 'dart:io';
import 'dart:developer';
import 'dart:convert';
import './route.dart';

class TargetServer {
    int port;
    String ip;
    int? get getPort => port;
    String? get getIp => ip;
    List<TargetRoute> routes = [ new TargetRoute("first", "", (HttpRequest request) { return 'hello!'; }) ];

    HttpServer? server;
    HttpServer? get getServer => server;

    TargetServer(this.port, this.ip) {
        HttpServer.bind(this.ip, this.port).then((HttpServer server) { 
            this.server = server;
            server.listen((HttpRequest request) {
                request.response.write(this.HandleRequest(request));
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

    String HandleRequest(HttpRequest request) {
        String path = request.uri.path;
        String query = request.uri.query;

        TargetRoute findRoute() => this.routes.firstWhere((route) => route.path == path, orElse: () => new TargetRoute("get", "/404", (HttpRequest request) { return "404"; }));

        TargetRoute route = findRoute();
        String response = "";

        //((String text) {
        //  response = text;
        //});

        return route.callback(request);
    }

    void Router(RouterInstance) {
      this.routes = RouterInstance.GetRoutes();
    }
}