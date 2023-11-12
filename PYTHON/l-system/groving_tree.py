import turtle
from random import randint


def apply_rules(axiom):
    return ''.join([rule_1 if chr == chr_1 else
                    chr for chr in axiom])


def get_result_gen(gens, axiom):
    for gen in range(gens):
        axiom = apply_rules(axiom)
    return axiom


WIDTH, HEIGHT = 1600, 900
screen = turtle.Screen()
screen.setup(WIDTH, HEIGHT)
screen.screensize(3 * WIDTH, 3 * HEIGHT)
screen.bgcolor("black")
screen.delay(0)

t = turtle.Turtle()
t.pensize(2)
t.speed(0)
t.color("green")
t.setpos(0, -HEIGHT // 2)

gens = 12
axiom = "XY"
chr_1, rule_1 = "X", "F[@[-X]+X]"
step = 80

color = [0.35, 0.2, 0.0]
angle = lambda : randint(0, 45)
stack = []
thickness = 20

axiom = get_result_gen(gens, axiom)
print(f"axiom {axiom}")

turtle.pencolor("white")
turtle.goto(-WIDTH // 2 + 100, -HEIGHT // 2 + 100)
turtle.clear()
turtle.write(f"gen: {gens}")

# t.setheading(0)
# t.goto(0, 0)
t.clear()

t.left(90)
t.pensize(thickness)
for chr in axiom:
    t.color(color)
    if chr == "F" or chr == "X":
        t.forward(step)
    elif chr == "@":
        step -= 6
        color[1] += 0.04
        thickness -= 2
        thickness = max(1, thickness)
        t.pensize(thickness)
    elif chr == "+":
        t.right(angle())
    elif chr == "-":
        t.left(angle())
    elif chr == "[":
        angle_, pos_ = t.heading(), t.pos()
        stack.append((angle_, pos_, thickness, step, color[1]))
    elif chr == "]":
        angle_, pos_, thickness, step, color[1] = stack.pop()
        t.pensize(thickness)
        t.setheading(angle_)
        t.penup()
        t.goto(pos_)
        t.pendown()

screen.exitonclick()
