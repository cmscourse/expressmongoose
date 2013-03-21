// Generated by CoffeeScript 1.6.2
(function() {
  var Client, ObjectId, Project, Schema, app, express, getAll, mongoose, request;

  express = require('express');

  app = express();

  mongoose = require('mongoose');

  request = require('request');

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

  app.listen(process.env.PORT || 3001);

}).call(this);
