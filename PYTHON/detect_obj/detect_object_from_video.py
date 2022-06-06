import cv2
capure = cv2.VideoCapture('video4.mp4')

import numpy as np


object_detector=cv2.createBackgroundSubtractorMOG2(history=100, varThreshold=40)
roi =[]
while True:

    ret, frame = capure.read()


    #roi = frame[180: 700, 180: 1000]
    roi = frame

    mask = object_detector.apply(roi)
    cv2.imshow('Mask1', mask)
    contours, _ = cv2.findContours(mask, cv2.RETR_TREE , cv2.CHAIN_APPROX_SIMPLE )

    for con in contours:
        area = cv2.contourArea(con)
        print(area)
        if area > 200 :
            cv2.drawContours(roi, [con], -1 , (0,255,255), 2)

    cv2.imshow('Frame', frame)
    cv2.imshow('Mask', mask)

    if cv2.waitKey(33) & 0xFF == ord('q'):
        break

capure.release()
cv2.destroyAllWindows()