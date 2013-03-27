(function() {
  var Client, ObjectId, Project, Schema, app, express, getAll, mongoose, request;

  var express = require('express')
  , app = express()
  , mongoose = require('mongoose')
  , request = require('request')
  , flash = require('connect-flash')
  , passport = require('passport')
  , util = require('util')
  , LocalStrategy = require('passport-local').Strategy
  , routes = require('./routes')
  , user = require('./routes/user')
  , http = require('http')
  , path = require('path')
  , cloudinary = require('cloudinary')
  , fs = require('fs')
  , crypto = require('crypto')

  app.locals.title = "Brian's Awesome Gallery";


 var users = [
    { id: 1, username: 'bob', password: 'secret', email: 'bob@example.com' }
  , { id: 2, username: 'joe', password: 'birthday', email: 'joe@example.com' }
];

function findById(id, fn) {
  var idx = id - 1;
  if (users[idx]) {
    fn(null, users[idx]);
  } else {
    fn(new Error('User ' + id + ' does not exist'));
  }
}

function findByUsername(username, fn) {
  for (var i = 0, len = users.length; i < len; i++) {
    var user = users[i];
    if (user.username === username) {
      return fn(null, user);
    }
  }
  return fn(null, null);
}

passport.serializeUser(function(user, done) {
  done(null, user.id);
});

passport.deserializeUser(function(id, done) {
  findById(id, function (err, user) {
    done(err, user);
  });
});

passport.use(new LocalStrategy(
  function(username, password, done) {
    // asynchronous verification, for effect...
    process.nextTick(function () {

      // Find the user by username.  If there is no user with the given
      // username, or the password is not correct, set the user to `false` to
      // indicate failure and set a flash message.  Otherwise, return the
      // authenticated `user`.
      findByUsername(username, function(err, user) {
        if (err) { return done(err); }
        if (!user) { return done(null, false, { message: 'Unknown user ' + username }); }
        if (user.password != password) { return done(null, false, { message: 'Invalid password' }); }
        return done(null, user);
      })
    });
  }
));





  mongoose.connect(process.env.MONGOHQ_URL || 'mongodb://127.0.0.1/briandb');

  Schema = mongoose.Schema;

  ObjectId = Schema.ObjectID;

  Client = new Schema({
    client_name: {
      type: String,
      trim: true
    }
  });

  Project = new Schema({
    client_id: {
      type: String,
      trim: true
    },
    project_title: {
      type: String,
      required: true,
      trim: true
    },
    clients: [Client],
    shoe_size: Number,
    eye_color: String
  });

  Project = mongoose.model('Project', Project);

  app.set('view engine', 'ejs');

  app.set('views', __dirname + '/views');

  app.use(express["static"](__dirname + '/public'));

  app.use(express.logger());
  app.use(express.cookieParser());
  app.use(express.bodyParser());
  app.use(express.methodOverride());
  app.use(express.session({ secret: 'keyboard cat' }));
  // Initialize Passport!  Also use passport.session() middleware, to support
  // persistent login sessions (recommended).
  app.use(flash());
  app.use(passport.initialize());
  app.use(passport.session());
  app.use(app.router);




  getAll = [];

  getAll.projects = function(req, res) {
    return res.render('layout.jade', {
      type: 'foo'
    });
  };

  getAll.music = function(req, res) {
    return res.render('layout.jade', {
      type: 'music'
    });
  };

  getAll.musicFolder = function(req, res) {
    return res.render('layout-folder.jade', {
      type: req.params.folderId
    });
  };

  app.get('/', function(req, res){
  res.render('index', { user: req.user });
});

app.get('/account', ensureAuthenticated, function(req, res){
  res.render('account', { user: req.user });
});

app.get('/login', function(req, res){
  res.render('login', { user: req.user, message: req.flash('error') });
});

// POST /login
//   Use passport.authenticate() as route middleware to authenticate the
//   request.  If authentication fails, the user will be redirected back to the
//   login page.  Otherwise, the primary route function function will be called,
//   which, in this example, will redirect the user to the home page.
//
//   curl -v -d "username=bob&password=secret" http://127.0.0.1:3000/login
app.post('/login',
  passport.authenticate('local', { failureRedirect: '/login', failureFlash: true }),
  function(req, res) {
    res.redirect('/');
  });

// POST /login
//   This is an alternative implementation that uses a custom callback to
//   acheive the same functionality.
/*
app.post('/login', function(req, res, next) {
  passport.authenticate('local', function(err, user, info) {
    if (err) { return next(err) }
    if (!user) {
      req.flash('error', info.message);
      return res.redirect('/login')
    }
    req.logIn(user, function(err) {
      if (err) { return next(err); }
      return res.redirect('/users/' + user.username);
    });
  })(req, res, next);
});
*/

app.get('/logout', function(req, res){
  req.logout();
  res.redirect('/');
});


  app.get('/testpage', function (req,res){
    res.render('testpage')
  })

  app.get('/singleproject', function(req, res) {
    Project.find({}, function(err, dat) {
      res.json(dat);
    });
  });

  app.get('/', function(req, res) {
    Project.find({}, function(err, dat) {
      res.json(dat);
    });
  });

  app.get('/all', getAll.projects);
  app.get('/greet/:name', function(req,res){
    res.render('greet', {
      name: req.params.name
    })
  })

  app.delete('/remove/:id', function(req, res) {
    Project.find({
      _id: req.params.id
    }).remove();
    return res.send('done');
  });

  app.get('/', function(req, res) {
    return Project.find({}, function(error, data) {
      return res.json(data);
    });
  });
  app.get('/responsive', function(req,res){
    res.render('responsive')
  })

  app.get('/show/:id', function(req, res) {
    return Project.findOne({
      _id: req.params.id
    }, function(error, doc) {
      return res.json(doc);
    });
  });

  app.post('/addproject/:project_title', function(req, res) {
    var project, project_data;

    project_data = {
      project_title: req.params.project_title
    };
    project = new Project(project_data);
    return project.save(function(error, data) {
      if (error) {
        return res.json(error);
      } else {
        return res.json(data);
      }
    });
  });

  app.get('/addclient/:project_title/:client', function(req, res) {
    var project;

    project = new Project();
    Project.findOne({
      project_title: req.params.project_title
    }, function(error, project) {
      if (error) {
        return res.json(error);
      } else if (project === null) {
        return res.json('no such user!');
      } else {
        project.clients.push({
          name: req.params.client
        });
        return project.save(function(error, data) {
          if (error) {
            return res.json(error);
          } else {
            return res.json(data);
          }
        });
      }
    });
    return console.log(req.params.project_name);
  });

  app.listen(process.env.PORT || 4000);

function ensureAuthenticated(req, res, next) {
  if (req.isAuthenticated()) { return next(); }
  res.redirect('/login')
}



}).call(this);
