import turtle

turtle.pensize(5)
for i in range(0, 400, 20):
    turtle.forward(i)
    turtle.right(90)


turtle.Screen().exitonclick()