import cv2
import numpy as np

quality = 10


def viewImage(image):
    cv2.namedWindow('Display', cv2.WINDOW_NORMAL)
    cv2.imshow('Display', image)
    cv2.waitKey(0)
    cv2.destroyAllWindows()


# convert to hsv
image = cv2.imread('pexels-photo-628229.jpeg')
hsv_img = cv2.cvtColor(image, cv2.COLOR_BGR2HSV)
# viewImage(hsv_img)

# filter color
green_low = np.array([45, 100, 50])
green_high = np.array([75, 255, 255])
curr_mask = cv2.inRange(hsv_img, green_low, green_high)
hsv_img[curr_mask > 0] = ([75, 255, 200])
# viewImage(hsv_img)
RGB_again = cv2.cvtColor(hsv_img, cv2.COLOR_HSV2RGB)
gray = cv2.cvtColor(RGB_again, cv2.COLOR_RGB2GRAY)
# viewImage(gray)
ret, threshold = cv2.threshold(gray, 90, 255, 0)
# viewImage(threshold)
contours, hierarchy = cv2.findContours(threshold, cv2.RETR_TREE, cv2.CHAIN_APPROX_SIMPLE)
cv2.drawContours(image, contours, -1, (0, 0, 255), 3)
# viewImage(image)

count = 0
for x in contours:
    rect = cv2.minAreaRect(x)
    if rect[1][0] < quality or rect[1][1] < quality: continue
    box = cv2.boxPoints(rect)
    box = np.int0(box)
    M = cv2.moments(x)
    cX = int(M["m10"] / M["m00"])
    cY = int(M["m01"] / M["m00"])
    cv2.drawContours(image, [box], -1, (0, 255, 255), 2)
    count = count + 1
    cv2.putText(image, str(count), (cX - 1, cY - 1), cv2.FONT_HERSHEY_SIMPLEX, 0.5, (255, 255, 255), 2)

viewImage(image)



