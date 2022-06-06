import cv2
import numpy as np

quality = 10
def viewImage(image):
    cv2.namedWindow('Display', cv2.WINDOW_GUI_NORMAL)
    cv2.imshow('Display', image)
    cv2.waitKey(0)
    cv2.destroyAllWindows()

def nothing(args):pass


cv2.namedWindow("setup", cv2.WINDOW_GUI_NORMAL)
cv2.createTrackbar("b1", "setup", 40, 255, nothing)
cv2.createTrackbar("g1", "setup", 25, 255, nothing)
cv2.createTrackbar("r1", "setup", 60, 255, nothing)
cv2.createTrackbar("b2", "setup", 255, 255, nothing)
cv2.createTrackbar("g2", "setup", 160, 255, nothing)
cv2.createTrackbar("r2", "setup", 255, 255, nothing)
cv2.createTrackbar("t", "setup", 60, 255, nothing)
cv2.createTrackbar("b", "setup", 49, 255, nothing)

while True:
    image = cv2.imread('photo12.jpg')
    hsv = cv2.cvtColor(image, cv2.COLOR_BGR2HSV)
    cv2.namedWindow('hsv', cv2.WINDOW_GUI_NORMAL)
    cv2.imshow('hsv',hsv)
    r1 = cv2.getTrackbarPos('r1', 'setup')
    g1 = cv2.getTrackbarPos('g1', 'setup')
    b1 = cv2.getTrackbarPos('b1', 'setup')
    r2 = cv2.getTrackbarPos('r2', 'setup')
    g2 = cv2.getTrackbarPos('g2', 'setup')
    b2 = cv2.getTrackbarPos('b2', 'setup')
    t = cv2.getTrackbarPos('t', 'setup')
    b = cv2.getTrackbarPos('b', 'setup')
    if (b % 2) == 0: b = b+1

    hsv_min = np.array((g1, b1, r1), np.uint8)
    hsv_max = np.array((g2, b2, r2), np.uint8)
        ###############################################################
    # hsv_min = np.array((25, 80, 63), np.uint8)
    # hsv_max = np.array((96, 255, 255), np.uint8)
    curr_mask = cv2.inRange(hsv, hsv_min, hsv_max)
    img_m = cv2.bitwise_and(hsv, hsv, mask=curr_mask)

    blurred = cv2.GaussianBlur(img_m, (b, b), 0)
    cv2.namedWindow('blurred', cv2.WINDOW_GUI_NORMAL)
    cv2.imshow('blurred', blurred)

    gray = cv2.cvtColor(blurred, cv2.COLOR_RGB2GRAY)
    cv2.namedWindow('gray', cv2.WINDOW_GUI_NORMAL)
    cv2.imshow('gray', gray)

    ret, threshold = cv2.threshold(gray, t, 255, 0)
    cv2.namedWindow('threshold', cv2.WINDOW_GUI_NORMAL)
    cv2.imshow('threshold', threshold)
    contours, hierarchy = cv2.findContours(threshold, cv2.RETR_EXTERNAL, cv2.CHAIN_APPROX_SIMPLE)
    cv2.drawContours(image, contours, -1, (0, 0, 255), 1)

    count = 0
    for x in contours:
        rect = cv2.minAreaRect(x)
        if rect[1][0] < quality or rect[1][1] < quality: continue
        box = cv2.boxPoints(rect)
        box = np.int0(box)
        M = cv2.moments(x)
        cX = int(M["m10"] / M["m00"])
        cY = int(M["m01"] / M["m00"])
        cv2.drawContours(image, [box], -1, (0, 255, 255), 1)
        count = count + 1
        cv2.putText(image, str(count), (cX - 1, cY - 1), cv2.FONT_HERSHEY_SIMPLEX, 0.5, (255, 255, 255), 2)

    cv2.namedWindow('FinalImage', cv2.WINDOW_GUI_NORMAL)
    cv2.imshow('FinalImage',image)



    if cv2.waitKey(33) & 0xFF == ord('q'):
        break

cv2.destroyAllWindows()


# viewImage(image)