import cv2
import numpy as np

def viewImage(name,image):
    cv2.namedWindow(name,  cv2.WINDOW_NORMAL)
    cv2.imshow(name, image)



image = cv2.imread('blob1.png', 0)
image = cv2.bitwise_not(image)
params = cv2.SimpleBlobDetector_Params()
params.minThreshold = 40
params.maxThreshold = 255
params.minDistBetweenBlobs = 1
#
params.filterByColor = True
params.blobColor = 255


params.filterByCircularity = False
params.filterByArea = False
params.filterByInertia = False
params.filterByConvexity = False


detector = cv2.SimpleBlobDetector_create(params)
keypoints = detector.detect(image)


blank = np.zeros((1, 1))
blobs = cv2.drawKeypoints(image, keypoints, blank, (0, 255, 255),cv2.DRAW_MATCHES_FLAGS_DRAW_RICH_KEYPOINTS )


viewImage('blobs',blobs)







cv2.waitKey(0)
cv2.destroyAllWindows()