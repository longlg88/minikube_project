var http = require('http');
const os = require('os');

console.log("Test server starting...");

var handleRequest = function(request, response) {
  console.log('Received request for URL: ' + request.connection.remoteAddress);
  response.writeHead(200);
  response.end("You've hit "+os.hostname()+"\n");
};
var www = http.createServer(handle);
www.listen(8080);

