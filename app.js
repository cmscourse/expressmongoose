(function() {
  var Hobby, ObjectId, Project, Schema, app, express, getAll, mongoose;

  express = require('express');

  app = express.createServer();

  mongoose = require('mongoose');

  mongoose.connect(process.env.MONGOHQ_URL || 'mongodb://127.0.0.1/sampledb');

  Schema = mongoose.Schema;

  ObjectId = Schema.ObjectID;

  Hobby = new Schema({
    name: {
      type: String,
      required: true,
      trim: true
    }
  });

  Project = new Schema({
    first_name: {
      type: String,
      trim: true
    },
    last_name: {
      type: String,
      trim: true
    },
    project_title: {
      type: String,
      required: true,
      trim: true
    },
    hobbies: [Hobby],
    shoe_size: Number,
    eye_color: String
  });

  Project = mongoose.model('Project', Project);

  app.set('view engine', 'jade');

  app.set('views', __dirname + '/views');

  app.use(express.static(__dirname + '/public'));

  getAll = {};

  getAll.projects = function(req, res) {
    console.log('getAll');
    return res.render('foo.jade', {
      foo: 'bar'
    });
  };

  app.get('/', function(req, res) {
    return Project.find({}, function(error, data) {
      return res.json(data);
    });
  });

  app.get('/all', getAll.projects);

  app.get('/remove/:id', function(req, res) {
    Project.find({
      _id: req.params.id
    }).remove();
    return res.send('done');
  });

  app.get('/show/:id', function(req, res) {
    return Project.findOne({
      _id: req.params.id
    }, function(error, doc) {
      return res.json(doc);
    });
  });

  app.get('/addproject/:project_title', function(req, res) {
    var person, project_data;
    project_data = {
      project_title: req.params.project_title
    };
    person = new Project(project_data);
    return person.save(function(error, data) {
      if (error) {
        return res.json(error);
      } else {
        return res.json(data);
        /*
            app.get('/addhobby/:username/:hobby', (req, res) -> {
              Person.findOne{ username: req.params.username }, (error, person) ->
                    if(error){
                        res.json(error)
                    }
                    else if(person == null){
                        res.json('no such user!')
                    }
                    else{
                        person.hobbies.push({ name: req.params.hobby })
                        person.save( (error, data) -> {
                            if(error){
                                res.json(error)
                            }
                            else{
                                res.json(data)
                            }
                        })
                    }
        
            })
        */
      }
    });
  });

  app.listen(process.env.PORT || 3001);

}).call(this);
