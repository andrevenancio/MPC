class Application
  constructor: ->
    data = [
      ['a', 'b'],
      ['a', 'b', 'c'],
    ]
    
    sequence = []
    for i in [0...data.length]
      for j in [0...data[i].length]
        console.log data[i], data[i][j]
        sequece.push(data[i] + ' ' + data[i][j])
