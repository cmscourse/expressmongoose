    express = require 'express'
    app = express()
    mongoose = require 'mongoose'
    request = require 'request'

    `
    var express = require('express')
    , passport = require('passport')
    , LocalStrategy = require('passport-local').Strategy
    , mongodb = require('mongodb')
    , mongoose = require('mongoose')
    , bcrypt = require('bcrypt')
    , SALT_WORK_FACTOR = 10;



    var db = mongoose.connection;
    db.on('error', console.error.bind(console, 'connection error:'));
    db.once('open', function callback() {
      console.log('Connected to DB');
      });


// User Schema
var userSchema = mongoose.Schema({
  username: { type: String, required: true, unique: true },
  email: { type: String, required: true, unique: true },
  password: { type: String, required: true},
});


// Bcrypt middleware
userSchema.pre('save', function(next) {
	var user = this;

	if(!user.isModified('password')) return next();

	bcrypt.genSalt(SALT_WORK_FACTOR, function(err, salt) {
		if(err) return next(err);

		bcrypt.hash(user.password, salt, function(err, hash) {
			if(err) return next(err);
			user.password = hash;
			next();
		});
	});
});


// Password verification
userSchema.methods.comparePassword = function(candidatePassword, cb) {
	bcrypt.compare(candidatePassword, this.password, function(err, isMatch) {
		if(err) return cb(err);
		cb(null, isMatch);
	});
};


// Seed a user
var User = mongoose.model('User', userSchema);
var user = new User({ username: 'bob', email: 'bob@example.com', password: 'secret' });
user.save(function(err) {
  if(err) {
    console.log(err);
  } else {
    console.log('user: ' + user.username + " saved.");
  }
});


// Passport session setup.
//   To support persistent login sessions, Passport needs to be able to
//   serialize users into and deserialize users out of the session.  Typically,
//   this will be as simple as storing the user ID when serializing, and finding
//   the user by ID when deserializing.
passport.serializeUser(function(user, done) {
  done(null, user.id);
});

passport.deserializeUser(function(id, done) {
  User.findById(id, function (err, user) {
    done(err, user);
  });
});



    `

    mongoose.connect process.env.MONGOHQ_URL or 'mongodb://127.0.0.1/briandb'

    Schema = mongoose.Schema
    ObjectId = Schema.ObjectID

    Client = new Schema
      client_name:
        type: String
        trim: true

    Project = new Schema
      client_id:
        type: String
        trim: true
      project_title:
        type: String
        required: true
        trim: true
      page_name:
        type: String
      clients: [Client]
      shoe_size: Number
      eye_color: String


    Project = mongoose.model 'Project', Project


    app.set 'view engine', 'ejs'
    app.set 'views', __dirname + '/views'
    app.use express.static __dirname + '/public'
    `
  app.engine('ejs', require('ejs-locals'));
  app.use(express.logger());
  app.use(express.cookieParser());
  app.use(express.bodyParser());
  app.use(express.methodOverride());
  app.use(express.session({ secret: 'keyboard cat' }));
  // Initialize Passport!  Also use passport.session() middleware, to support
  // persistent login sessions (recommended).
  app.use(passport.initialize());
  app.use(passport.session());
  app.use(app.router);
  app.use(express.static(__dirname + '/../../public'));
    `

    getAll = []

    getAll.projects = (req,res) ->#  {{{
      res.render 'layout.jade', {type:'foo'}

    getAll.music = (req,res) ->
      res.render 'layout.jade', {type:'music'}

    getAll.musicFolder = (req,res) ->
      res.render 'layout-folder.jade', {type: req.params.folderId}

    app.get '/', (req,res) ->
      Project.find {},(errdor, data) ->
        res.json data

    app.get '/bootswatch', (req,res) ->
      Project.findOne {page_name: 'home'}, (error, data) ->
        res.render 'responsiveView',{type: data.project_title}

    app.get '/all', getAll.projects

    app.get '/remove/:id', (req,res) ->
      Project.find({ _id: req.params.id }).remove()
      res.send 'done'# }}}



    `
app.get('/passport', function(req, res){
  res.render('index', { user: req.user });
});

app.get('/account', ensureAuthenticated, function(req, res){
  res.render('account', { user: req.user });
});

app.get('/login', function(req, res){
  res.render('login', { user: req.user, message: req.session.messages });
});

// POST /login
//   Use passport.authenticate() as route middleware to authenticate the
//   request.  If authentication fails, the user will be redirected back to the
//   login page.  Otherwise, the primary route function function will be called,
//   which, in this example, will redirect the user to the home page.
//
//   curl -v -d "username=bob&password=secret" http://127.0.0.1:3000/login
//
/***** This version has a problem with flash messages
app.post('/login',
  passport.authenticate('local', { failureRedirect: '/login', failureFlash: true }),
  function(req, res) {
    res.redirect('/');
  });
*/

// POST /login
//   This is an alternative implementation that uses a custom callback to
//   acheive the same functionality.
app.post('/login', function(req, res, next) {
  passport.authenticate('local', function(err, user, info) {
    if (err) { return next(err) }
    if (!user) {
      req.session.messages =  [info.message];
      return res.redirect('/login')
    }
    req.logIn(user, function(err) {
      if (err) { return next(err); }
      return res.redirect('/');
    });
  })(req, res, next);
});

app.get('/logout', function(req, res){
  req.logout();
  res.redirect('/');
});

    `

    app.get '/', (req,res) ->
      Project.find {},(error, data) ->
        res.json(data)

    app.get '/show/:id', (req,res) ->
      Project.findOne { _id: req.params.id },(error, doc) ->
        res.json doc

    app.get '/home', (req, res) ->
      Project.findOne {page_name: 'home'}, (error, data) ->
        res.render 'layout.jade',{type: data.project_title}

    app.post '/:pagename/:project_title', (req,res) ->
      Project.findOne({page_name: req.params.pagename}).remove()
      project_data =
        page_name: req.params.pagename
        project_title: req.params.project_title
      project = new Project(project_data)
      project.save (error, data) ->
        if(error)
          res.json error
        else
          res.json data


      Project.findOne {page_name: 'home'}, (error, data) ->

    app.post '/addproject/:page_name/:project_title', (req, res) ->
      project_data =
        page_name: req.params.page_name
        project_title: req.params.project_title

      project = new Project(project_data)
      project.save (error, data) ->
        if(error)
          res.json error
        else
          res.json data

    app.get '/addclient/:project_title/:client', (req, res) ->
      project = new Project()
      Project.findOne {project_title: req.params.project_title}, (error,project) ->
        if(error)
          res.json(error)

        else if(project == null)
          res.json('no such user!')

        else
          project.clients.push({ name: req.params.client })
          project.save( (error, data) ->
            if(error)
              res.json(error)
            else
              res.json(data)
          )

      console.log req.params.project_name


    app.listen(process.env.PORT || 3001)

    `
function ensureAuthenticated(req, res, next) {
  if (req.isAuthenticated()) { return next(); }
  res.redirect('/login')
}
    `
