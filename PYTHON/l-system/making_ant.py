import turtle
from random import randint

WIDTH, HEIGHT = 1600, 900
screen = turtle.Screen()
screen.setup(WIDTH, HEIGHT)
screen.screensize(3 * WIDTH, 3 * HEIGHT)
screen.bgcolor("white")
screen.delay(0)

t = turtle.Turtle()
t.pensize(2)
t.speed(0)
t.color("black")
t.setpos(0, -HEIGHT // 2)

step = 100
gens = 7

t.setheading(0)
t.goto(0, 0)
t.clear()


def add_to_map(x, y, map, p):
    print(f"x:{x} y:{y} map:{map}")
    find_status = 0
    for point in map:
        if point["x"] == x and point["y"] == y:
            find_status = 1
    if find_status == 0:
        map.append({'x': x, 'y': y, 's': 'white', 'p': p})

    return map


map = [{'x': 0, 'y': 0, 's': "white", 'p': "up"}]
for gen in range(gens):

    for point in map:
        if point["s"] == "white":
            point["s"] = "black"
            if point["p"] == "up":
                x, y = point['x'] + step, point['y']
                point["p"] = "right"
            elif point["p"] == "left":
                x, y = point['x'], point['y'] + step
                point["p"] = "up"
            elif point["p"] == "down":
                x, y = point['x'] - step, point['y']
                point["p"] = "left"
            elif point["p"] == "right":
                x, y = point['x'], point['y'] - step
                point["p"] = "down"

            map = add_to_map(round(x), round(y), map, point["p"])

        elif point["s"] == "black":
            point["s"] = "white"
            if point["p"] == "up":
                x, y = point['x'] - step, point['y']
                point["p"] = "left"
            elif point["p"] == "left":
                x, y = point['x'], point['y'] - step
                point["p"] = "down"
            elif point["p"] == "down":
                x, y = point['x'] + step, point['y']
                point["p"] = "right"
            elif point["p"] == "right":
                x, y = point['x'], point['y'] + step
                point["p"] = "up"
            map = add_to_map(round(x), round(y), map, point["p"])

for point in map:
    t.goto(point['x'], point['y'])

screen.exitonclick()
