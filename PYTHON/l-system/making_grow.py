import turtle

def apply_rules(axiom):
    return ''.join([rule_1 if chr == chr_1 else
                    rule_2 if chr == chr_2 else
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

gens = 6
axiom = "XY"
chr_1, rule_1 = "F", "FF"
chr_2, rule_2 = "X", "F[+X]F[-X]+X"
step = 7
angle = 22.5
stack =[]


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
for chr in axiom:
    if chr ==chr_1:
        t.forward(step)
    elif chr == "+":
        t.right(angle)
    elif chr == "-":
        t.left(angle)
    elif chr == "[":
        angle_, pos_ =t.heading(), t.pos()
        stack.append((angle_,pos_))
    elif chr == "]":
        angle_,pos_ = stack.pop()
        t.setheading(angle_)
        t.penup()
        t.goto(pos_)
        t.pendown()


screen.exitonclick()
