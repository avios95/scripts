import cv2
import numpy as np


def nothing(args): pass


def draw_contours_on(image, layer, b, g, r):
    count = 0
    blurred = cv2.GaussianBlur(layer[180: 1000, 0: 2000], (5, 5), 0)
    gray = cv2.cvtColor(blurred, cv2.COLOR_BGR2GRAY)
    ret, threshold = cv2.threshold(gray, 1, 255, 0)
    kernel = np.ones((5, 5), 'uint8')
    dilate_img = cv2.dilate(threshold, kernel, iterations=1)
    contours, hierarchy = cv2.findContours(dilate_img, cv2.RETR_EXTERNAL, cv2.CHAIN_APPROX_SIMPLE)
    for con in contours:
        area = cv2.contourArea(con)
        if area > 100:
            count += 1
            M = cv2.moments(con)
            cX = int(M["m10"] / M["m00"])
            cY = int(M["m01"] / M["m00"])
            cv2.drawContours(image[180: 1000, 0: 2000], [con], -1, (r, g, b), -1)
            cv2.putText(image[180: 1000, 0: 2000], str(count), (cX - 1, cY - 1), cv2.FONT_HERSHEY_SIMPLEX, 0.5, (0, 255, 255), 2)


    return image


capure = cv2.VideoCapture('video5.mp4')
object_detector = cv2.createBackgroundSubtractorMOG2(history=100, varThreshold=30)
low_red = np.array([161, 155, 84])
high_red = np.array([179, 255, 255])
low_blue = np.array([94, 80, 2])
high_blue = np.array([126, 255, 255])
low_green = np.array([25, 52, 72])
high_green = np.array([102, 255, 255])
low_white = np.array([0, 42, 0])
high_white = np.array([149, 255, 255])

# frame = cv2.imread('photo1.jpg')
# hsv = cv2.cvtColor(frame, cv2.COLOR_BGR2HSV)
# mask_red = cv2.inRange(hsv, low_red, high_red)
# image_red = cv2.bitwise_and(frame, frame, mask=mask_red)
# mask_blue = cv2.inRange(hsv, low_blue, high_blue)
# image_blue = cv2.bitwise_and(frame, frame, mask=mask_blue)
# mask_green = cv2.inRange(hsv, low_green, high_green)
# image_green = cv2.bitwise_and(frame, frame, mask=mask_green)
# mask_white = cv2.inRange(hsv, low_white, high_white)
# image_white = cv2.bitwise_and(frame, frame, mask=mask_white)
# cv2.imshow("image_white", draw_contours_on(frame.copy(), image_white, 255, 255, 255))
# cv2.imshow("image_green", draw_contours_on(frame.copy(), image_green, 0, 255, 0))
# cv2.imshow("image_blue", draw_contours_on(frame.copy(), image_blue, 0, 0, 255))
# cv2.imshow("image_red", draw_contours_on(frame.copy(), image_red, 255, 0, 0))


while True:

    ret, frame = capure.read()
    # frame = cv2.resize(frame,None, fx=0.5, fy=0.5)
    hsv = cv2.cvtColor(frame, cv2.COLOR_BGR2HSV)
    mask_red = cv2.inRange(hsv, low_red, high_red)
    image_red = cv2.bitwise_and(frame, frame, mask=mask_red)
    mask_blue = cv2.inRange(hsv, low_blue, high_blue)
    image_blue = cv2.bitwise_and(frame, frame, mask=mask_blue)
    mask_green = cv2.inRange(hsv, low_green, high_green)
    image_green = cv2.bitwise_and(frame, frame, mask=mask_green)
    mask_white = cv2.inRange(hsv, low_white, high_white)
    image_white = cv2.bitwise_and(frame, frame, mask=mask_white)
    cv2.imshow("image_white", draw_contours_on(frame.copy(), image_white, 255, 255, 255))
    cv2.imshow("image_green", draw_contours_on(frame.copy(), image_green, 0, 255, 0))
    cv2.imshow("image_blue", draw_contours_on(frame.copy(), image_blue, 0, 0, 255))
    cv2.imshow("image_red", draw_contours_on(frame.copy(), image_red, 255, 0, 0))

    if cv2.waitKey(35) & 0xFF == ord('q'):
        break

capure.release()
cv2.destroyAllWindows()
