module.exports = (grunt) ->
  grunt.initConfig
    pkg: '<json:package.json>'

    #watch for changes in files
    watch:
      files: ['Gruntfile.coffee', 'src/coffee/*.coffee', 'src/sass/*.sass']
      tasks: 'onwatch'

    #compile coffee files
    coffee:
      lib:
        files:
          'deploy/js/all.js': 'src/**/*.coffee'

    #compile sass files
    sass:
      dist:
        options:
          style: 'expanded'
        files:
          'deploy/css/main.css': 'src/sass/reset.sass'
      
    #uglify javascript
    uglify:
      options:
        mangle: false
      my_target:
        files:
          'deploy/js/all.min.js': ['deploy/js/all.js']

  #add event to listen for file changes
  grunt.event.on "watch", (action, filepath, target) ->
    grunt.log.writeln "#{filepath} has #{action}"

  grunt.loadNpmTasks 'grunt-contrib-coffee'
  grunt.loadNpmTasks 'grunt-contrib-watch'
  grunt.loadNpmTasks 'grunt-contrib-uglify'
  grunt.loadNpmTasks 'grunt-contrib-sass'

  grunt.registerTask 'default', ['watch']
  grunt.registerTask 'onwatch', ['coffee', 'sass', 'uglify']