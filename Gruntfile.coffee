module.exports = (grunt) ->
  grunt.initConfig
    pkg: '<json:package.json>'

    #watch for changes in files
    watch:
      files: ['Gruntfile.coffee', 'src/coffee/**/*.coffee', 'src/sass/*.sass']
      tasks: 'onwatch'

    #compile coffee files
    percolator:
      main:
        source: 'src/coffee'
        output: 'deploy/js/main.js'
        main: 'Main.coffee'
        compile: true
        opts: "--bare"
      app:
        source: 'src/coffee'
        output: 'deploy/js/app.js'
        main: 'Application.coffee'
        compile: true
        opts: "--bare"

    #compile sass files
    sass:
      dist:
        options:
          style: 'expanded'
          noCache: true
        files:
          'deploy/css/main.css': 'src/sass/reset.sass'
      
    #uglify javascript
    uglify:
      options:
        mangle: true
      my_target:
        files:
          'deploy/js/app.min.js': ['deploy/js/app.js']

  #add event to listen for file changes
  grunt.event.on "watch", (action, filepath, target) ->
    #grunt.log.writeln "#{filepath} has #{action}"

  grunt.loadNpmTasks 'grunt-coffee-percolator-v2'
  grunt.loadNpmTasks 'grunt-contrib-watch'
  grunt.loadNpmTasks 'grunt-contrib-uglify'
  grunt.loadNpmTasks 'grunt-contrib-sass'

  grunt.registerTask 'default', ['watch', 'percolator:main']
  grunt.registerTask 'onwatch', ['percolator:app', 'sass']