#import app.math.vec2
class MathUtils
  @calculateControlPoints: (points, factor = 0.5) ->
    startIndex = 1
    endIndex = points.length
    cp = new Array()
    controlPoints = new Array()
    for i in [startIndex...endIndex+1]
      prev = i-1
      cur = i%endIndex
      next = (i+1)%endIndex

      cp = this.getControlPoints(points[prev], points[cur], points[next], factor)
      controlPoints.push(cp[0])
      controlPoints.push(cp[1])
    
    return controlPoints

  @getControlPoints: ( p1, p2, p3, t) ->
    d1 = Math.sqrt(Math.pow(p2.x - p1.x, 2) + Math.pow(p2.y - p1.y, 2))
    d2 = Math.sqrt(Math.pow(p3.x - p2.x, 2) + Math.pow(p3.y - p2.y, 2))

    fa = t * d1 / (d1 + d2)
    fb = t - fa

    point1 = new Vec2 Math.round(p2.x + fa * (p1.x - p3.x)), Math.round(p2.y + fa * (p1.y - p3.y))
    point2 = new Vec2 Math.round(p2.x - fb * (p1.x - p3.x)), Math.round(p2.y - fb * (p1.y - p3.y))
    return [point1, point2]