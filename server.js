var express = require('express'),
    auth = require('http-auth'),
    fs = require('fs'),
    app = express();

var appEnv = process.env.APP_ENV;

var passwdFile = __dirname + '/../config/' + appEnv + '.htpasswd';

if (fs.existsSync(passwdFile)) {

  var basic = auth.basic({
      realm: appEnv,
      file: passwdFile
  });

  app.use(auth.connect(basic));

}

app.use(express.static('./dist/'));

app.all('*', function(req, res, next) {
  res.header("Access-Control-Allow-Origin", "*");
  res.header("Access-Control-Allow-Headers", "X-Requested-With");
  next();
});

app.set('port', process.env.PORT || 5000);

app.listen(app.get('port'), function () {
  console.log('Express server listening on port ' + app.get('port'));
});
