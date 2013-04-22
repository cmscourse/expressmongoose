    express = require 'express'
    app = express()
    mongoose = require 'mongoose'
    request = require 'request'

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


    app.set 'view engine', 'jade'
    app.set 'views', __dirname + '/views'
    app.use express.static __dirname + '/public'

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

    app.get '/all', getAll.projects

    app.get '/remove/:id', (req,res) ->
      Project.find({ _id: req.params.id }).remove()
      res.send 'done'# }}}

    app.get '/', (req,res) ->
      Project.find {},(error, data) ->
        res.json(data)

    app.get '/show/:id', (req,res) ->
      Project.findOne { _id: req.params.id },(error, doc) ->
        res.json doc

    app.get '/home', (req, res) ->
      Project.findOne {page_name: 'home'}, (error, data) ->
        res.render 'layout.jade',{type: data.project_title}

    app.post '/home/:project_title', (req,res) ->
      Project.findOne({page_name: 'home'}).remove()
      project_data =
        page_name: 'home'
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

